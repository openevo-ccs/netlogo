"""
validate_experiment.py
-----------------------
Cross-checks a saved BehaviorSpace experiment (.xml, same schema whether it's
embedded in a model's <experiments> section or a standalone file like
Northwestern's <experiments><experiment>...) against a model's Model Card,
*before* an agent is allowed to hand it to a headless NetLogo run.

This exists because of a concrete, real bug found in the OpenEvo CCS
collection this toolkit was built against: `experiments/two-foresters-
harvest-regrowth.xml` is saved as an experiment for the "Two Foresters"
model, but references variables (`harvest-rate-1`, `harvest-rate-2`,
`regrowth-rate`, `initial-strategy-1`, `initial-strategy-2`) and metrics
(`energy`, `strategy`) that do not exist anywhere in that model's code --
Two Foresters' actual sliders are `Percent-cut1`, `Percent-cut2`,
`Growth-Rate`, and its forester breed variables are `amount`, `harvest`,
`wealth`. A grep across the rest of the collection shows partial matches in
unrelated models (`evolution-resource-use-social-behavior` does have
`strategy`), suggesting this experiment file was either copied from a
different model and never adapted, or hand/LLM-authored by pattern-matching
plausible NetLogo naming conventions rather than reading the actual model.

An agent driving BehaviorSpace sweeps needs this check run *before*
`preview_experiment`/`run_experiment` (see runtime/interface.py), because a
sweep over nonexistent variables either errors out after JVM startup cost
(headless) or, worse, silently no-ops depending on the runner -- both are
expensive failure modes to discover only after burning a run budget.
"""
from __future__ import annotations
import json
import re
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from typing import List, Set


REPORTER_VAR_RE = re.compile(r"[A-Za-z][A-Za-z0-9_\-?!]*")


@dataclass
class ValidationIssue:
    severity: str  # "error" | "warning"
    where: str
    message: str


@dataclass
class ValidationResult:
    experiment_name: str
    issues: List[ValidationIssue] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not any(i.severity == "error" for i in self.issues)

    def to_dict(self) -> dict:
        return {
            "experiment_name": self.experiment_name,
            "ok": self.ok,
            "issues": [i.__dict__ for i in self.issues],
        }


def known_identifiers(card: dict) -> Set[str]:
    """Everything a `var="..."` attribute in an experiment is allowed to
    reference: declared globals, widget-bound parameter variables (NetLogo
    auto-declares these even if absent from `globals [...]`), and
    breed-owned variables (for metric/exitCondition expressions)."""
    ids = {g.lower() for g in card.get("globals", [])}
    ids |= {p["variable"].lower() for p in card.get("parameters", []) if p.get("variable")}
    for breed in card.get("breeds", {}).values():
        ids |= {v.lower() for v in breed.get("own", [])}
        if breed.get("singular"):
            ids.add(breed["singular"].lower())
    for breed_name in card.get("breeds", {}):
        ids.add(breed_name.lower())
    ids |= {name.lower() for name in card.get("procedures", {})}
    # NetLogo builtins that commonly appear in metrics/exit-conditions
    ids |= {"count", "sum", "mean", "ticks", "true", "false", "of", "with",
            "and", "or", "not"}
    return ids


def check_reporter_expr(expr: str, known: Set[str], where: str) -> List[ValidationIssue]:
    """Best-effort lexical check: every bare identifier in a reporter
    expression should resolve to something in `known`. This is NOT a real
    NetLogo parser -- it will not catch semantic errors, and it can
    false-positive on local `let`-bound names inside the expression itself.
    It exists to catch the specific, common failure mode of an experiment
    spec written against the wrong model or a stale variable name, which a
    lexical pass is enough for."""
    issues = []
    tokens = REPORTER_VAR_RE.findall(expr)
    local_lets = set(re.findall(r"\blet\s+([A-Za-z][A-Za-z0-9_\-?!]*)", expr))
    for tok in tokens:
        low = tok.lower()
        if low in known or low in {t.lower() for t in local_lets}:
            continue
        if tok[0].isdigit():
            continue
        issues.append(ValidationIssue(
            severity="warning", where=where,
            message=f"Identifier '{tok}' not found among model globals, "
                    f"parameters, breeds, or procedures -- verify it's a "
                    f"valid reference before running.",
        ))
    return issues


def validate(experiment_xml: str, model_card: dict) -> List[ValidationResult]:
    root = ET.fromstring(experiment_xml)
    known = known_identifiers(model_card)
    param_vars = {p["variable"].lower() for p in model_card.get("parameters", []) if p.get("variable")}
    results = []

    experiments = root.findall(".//experiment") if root.tag != "experiment" else [root]
    for exp in experiments:
        name = exp.get("name", "<unnamed>")
        result = ValidationResult(experiment_name=name)

        # setup/go must reference real entry-point procedures
        setup_el = exp.find("setup")
        go_el = exp.find("go")
        entry_points = {n.lower() for n in model_card.get("entry_points", [])}
        all_procs = {n.lower() for n in model_card.get("procedures", {})}
        if setup_el is not None and setup_el.text:
            if setup_el.text.strip().lower() not in all_procs:
                result.issues.append(ValidationIssue(
                    "error", "setup",
                    f"'{setup_el.text.strip()}' is not a procedure in this model.",
                ))
        if go_el is not None and go_el.text:
            if go_el.text.strip().lower() not in all_procs:
                result.issues.append(ValidationIssue(
                    "error", "go",
                    f"'{go_el.text.strip()}' is not a procedure in this model.",
                ))

        # constants: steppedValueSet / enumeratedValueSet must reference
        # actual exposed parameters -- this is the check that catches the
        # two-foresters mismatch (error-level: a sweep can't run over a
        # variable that doesn't exist).
        for tag in ("steppedValueSet", "enumeratedValueSet"):
            for el in exp.findall(f".//{tag}"):
                var = el.get("variable")
                if var is None:
                    # The nlogox/BehaviorSpace schema requires `variable=`
                    # on both steppedValueSet and enumeratedValueSet. A
                    # missing `variable` attribute with some other
                    # attribute present (e.g. a stray `var=`) is a schema
                    # violation that a real BehaviorSpace parser will
                    # likely either reject or silently ignore -- either
                    # way the swept parameter never actually varies, which
                    # is a much more dangerous failure than an outright
                    # crash because it can produce a full run of
                    # apparently-valid but meaningless data.
                    other_attrs = {k: v for k, v in el.attrib.items()}
                    result.issues.append(ValidationIssue(
                        "error", tag,
                        f"Missing required 'variable' attribute (schema: "
                        f"{tag} requires variable::String). Found attributes "
                        f"{other_attrs!r} instead -- if one of these was meant "
                        f"to be 'variable', this element will silently not vary "
                        f"that parameter rather than erroring, which is worse "
                        f"than a crash.",
                    ))
                    continue
                if var.lower() not in param_vars:
                    result.issues.append(ValidationIssue(
                        "error", f"{tag}[variable={var!r}]",
                        f"'{var}' is not an exposed parameter (slider/switch/chooser/"
                        f"input) in this model. Exposed parameters are: "
                        f"{sorted(p['variable'] for p in model_card.get('parameters', []))}",
                    ))

        # metrics / exit condition: lexical check (warning-level, since we
        # aren't a real NetLogo parser)
        for metric_el in exp.findall(".//metric"):
            if metric_el.text:
                result.issues.extend(
                    check_reporter_expr(metric_el.text, known, "metric")
                )
        exit_el = exp.find("exitCondition")
        if exit_el is not None and exit_el.text:
            result.issues.extend(
                check_reporter_expr(exit_el.text, known, "exitCondition")
            )

        results.append(result)
    return results


def main():
    if len(sys.argv) < 3:
        print("usage: validate_experiment.py experiment.xml model-card.json", file=sys.stderr)
        sys.exit(1)
    exp_path, card_path = sys.argv[1], sys.argv[2]
    with open(exp_path) as f:
        exp_xml = f.read()
    with open(card_path) as f:
        card = json.load(f)

    results = validate(exp_xml, card)
    any_errors = False
    for r in results:
        status = "PASS" if r.ok else "FAIL"
        print(f"[{status}] experiment '{r.experiment_name}'")
        for issue in r.issues:
            print(f"  {issue.severity.upper():7s} {issue.where}: {issue.message}")
        if not r.ok:
            any_errors = True
    if len(sys.argv) > 3 and sys.argv[3] == "--json":
        print(json.dumps([r.to_dict() for r in results], indent=2))
    sys.exit(1 if any_errors else 0)


if __name__ == "__main__":
    main()
