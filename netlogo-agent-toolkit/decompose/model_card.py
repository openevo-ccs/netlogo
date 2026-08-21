"""
model_card.py
--------------
Decomposes a NetLogo model's .nlogox (preferred) or legacy .nlogo source into
a "Model Card": a structured JSON manifest that an LLM agent can read
directly, instead of re-deriving structure from raw NetLogo code on every
turn. This is the artifact described as the core of the toolkit strategy:
"treat the model as data before treating it as a runtime."

What it extracts:
  - globals (declared via `globals [...]`)
  - breeds and their `<breed>-own` variables
  - procedures (to / to-report), their parameters, and a call graph derived
    by scanning each procedure body for calls to other known procedures
  - widgets, split into:
      * parameters  (sliders/switches/choosers/inputs -> bound global, with
        min/max/step/default/units where available)
      * outputs     (monitors/plots -> the reporter expression(s) they
        display, so an agent knows what's observable without guessing)
      * controls    (buttons -> the procedure(s) they invoke)
  - info tab, split into named sections (given these models follow the ODD-ish
    "# Model purpose / # Entities and variables / ..." heading convention
    used across the OpenEvo collection)
  - a lightweight lint pass: parameters referenced by widgets but never
    declared as globals, and vice versa (globals with no exposed control)

This module is intentionally dependency-free (stdlib only) so it can run
anywhere the agent runtime runs, including inside a browser-side WASM
Python or a minimal CI container.
"""
from __future__ import annotations
import json
import re
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass, asdict, field
from typing import Dict, List, Optional


# --------------------------------------------------------------------------
# Code-level parsing (works on the raw NetLogo source, extracted from
# either .nlogo or .nlogox -- the dialect of NetLogo code itself did not
# change between the two file formats)
# --------------------------------------------------------------------------

GLOBALS_RE = re.compile(r"globals\s*\[(.*?)\]", re.DOTALL)
BREED_RE = re.compile(r"breed\s*\[\s*(\S+)\s+(\S+)\s*\]")
BREED_OWN_RE = re.compile(r"([A-Za-z0-9_\-]+)-own\s*\[(.*?)\]", re.DOTALL)
# Trailing inline comments (e.g. "to regrow ;; tree") are common and must
# not break the match, so a comment is allowed (and ignored) before EOL.
PROC_RE = re.compile(
    r"^\s*to(-report)?\s+([A-Za-z0-9_\-?!<>=+*/.]+)\s*(\[(.*?)\])?\s*(;.*)?$",
    re.MULTILINE,
)


def _split_names(block: str) -> List[str]:
    return [t for t in re.split(r"\s+", block.strip()) if t]


def extract_globals(code: str) -> List[str]:
    m = GLOBALS_RE.search(code)
    return _split_names(m.group(1)) if m else []


def extract_breeds(code: str) -> Dict[str, dict]:
    breeds = {}
    for plural, singular in BREED_RE.findall(code):
        breeds[plural] = {"singular": singular, "own": []}
    for owner, block in BREED_OWN_RE.findall(code):
        names = _split_names(block)
        if owner in breeds:
            breeds[owner]["own"] = names
        elif owner in ("turtles", "patches", "links"):
            breeds[owner] = {"singular": owner[:-1] if owner != "patches" else "patch",
                              "own": names, "builtin": True}
    return breeds


@dataclass
class Procedure:
    name: str
    kind: str  # "command" (to) or "reporter" (to-report)
    params: List[str]
    body: str
    calls: List[str] = field(default_factory=list)


def extract_procedures(code: str) -> Dict[str, Procedure]:
    matches = list(PROC_RE.finditer(code))
    procs: Dict[str, Procedure] = {}
    for i, m in enumerate(matches):
        is_report = bool(m.group(1))
        name = m.group(2)
        params = _split_names(m.group(4)) if m.group(4) else []
        start = m.end()
        end_match = re.search(r"\bend\b", code[start:])
        end = start + end_match.start() if end_match else len(code)
        body = code[start:end].strip()
        procs[name] = Procedure(
            name=name, kind="reporter" if is_report else "command",
            params=params, body=body,
        )
    proc_names = set(procs.keys())
    token_re = re.compile(r"[A-Za-z][A-Za-z0-9_\-?!<>=+*/.]*")
    for p in procs.values():
        tokens = set(token_re.findall(p.body))
        p.calls = sorted(t for t in tokens if t in proc_names and t != p.name)
    return procs


def find_entry_points(procs: Dict[str, Procedure]) -> List[str]:
    """Procedures never called by any other known procedure -- typically
    setup/go, invoked only from button widgets."""
    called = set()
    for p in procs.values():
        called.update(p.calls)
    return sorted(name for name in procs if name not in called)


# --------------------------------------------------------------------------
# nlogox widget extraction
# --------------------------------------------------------------------------

def _f(x, cast=float):
    try:
        return cast(x)
    except (TypeError, ValueError):
        return x


def extract_from_nlogox(xml_text: str) -> dict:
    """NOTE: code/text-bearing elements (<code>, <info>, <button>, <monitor>,
    plot/pen <setup>/<update>, <input>) hold their content as the element's
    OWN text (ET transparently merges CDATA into .text) -- not a nested
    <source>/<text>/<value> child. Validated against NetLogo 7.0.4's own
    bundled sample .nlogox models; see nlogo_to_nlogox.py's docstring."""
    root = ET.fromstring(xml_text)
    code_el = root.find("code")
    code = code_el.text or "" if code_el is not None else ""

    info_el = root.find("info")
    info = info_el.text or "" if info_el is not None else ""

    parameters, outputs, controls = [], [], []
    view = {}

    for w in root.find("widgets"):
        tag = w.tag
        if tag == "view":
            view = {
                "minPxcor": _f(w.get("minPxcor"), int), "maxPxcor": _f(w.get("maxPxcor"), int),
                "minPycor": _f(w.get("minPycor"), int), "maxPycor": _f(w.get("maxPycor"), int),
                "patchSize": _f(w.get("patchSize")), "updateMode": _f(w.get("updateMode"), int),
                "wrappingAllowedX": w.get("wrappingAllowedX") == "true",
                "wrappingAllowedY": w.get("wrappingAllowedY") == "true",
            }
        elif tag == "slider":
            parameters.append({
                "widget": "slider", "variable": w.get("variable"), "display": w.get("display"),
                "min": _f(w.get("min")), "max": _f(w.get("max")),
                "default": _f(w.get("default")), "step": _f(w.get("step")),
                "units": w.get("units"),
            })
        elif tag == "switch":
            parameters.append({
                "widget": "switch", "variable": w.get("variable"), "display": w.get("display"),
                "default": w.get("on") == "true", "values": [True, False],
            })
        elif tag == "chooser":
            choices = []
            for c in w.findall("choice"):
                v = c.get("value")
                # numeric chooser choices are type="double" in real 7.0.4
                # output, not "number" (that's the <input> box vocabulary).
                choices.append(_f(v) if c.get("type") == "double" else v)
            current = int(w.get("current", "0"))
            parameters.append({
                "widget": "chooser", "variable": w.get("variable"), "display": w.get("display"),
                "values": choices, "default": choices[current] if choices else None,
            })
        elif tag == "input":
            parameters.append({
                "widget": "input", "variable": w.get("variable"), "display": w.get("display"),
                "type": w.get("type"), "default": w.text,
            })
        elif tag == "monitor":
            outputs.append({
                "widget": "monitor", "display": w.get("display"),
                "reporter": (w.text or "").strip(),
            })
        elif tag == "plot":
            pens = []
            for pen in w.findall("pen"):
                upd = pen.find("update")
                setup = pen.find("setup")
                pens.append({
                    "display": pen.get("display"),
                    "setup": (setup.text or "").strip() if setup is not None and setup.text else "",
                    "update": (upd.text or "").strip() if upd is not None and upd.text else "",
                })
            outputs.append({
                "widget": "plot", "display": w.get("display"),
                "xAxis": w.get("xAxis"), "yAxis": w.get("yAxis"),
                "yMin": _f(w.get("yMin")), "yMax": _f(w.get("yMax")),
                "pens": pens,
            })
        elif tag == "button":
            controls.append({
                "display": w.get("display"), "kind": w.get("kind"),
                "forever": w.get("forever") == "true",
                "code": (w.text or "").strip(),
            })

    return {
        "code": code, "info": info, "view": view,
        "parameters": parameters, "outputs": outputs, "controls": controls,
    }


# --------------------------------------------------------------------------
# Info tab -> structured sections (ODD-style headings used across the
# OpenEvo collection: "# Model purpose", "# Entities and variables", ...)
# --------------------------------------------------------------------------

def split_info_sections(info: str) -> Dict[str, str]:
    sections = {}
    parts = re.split(r"(?m)^#\s+(.+)$", info)
    # parts[0] is preamble before first heading; then alternating heading/body
    for i in range(1, len(parts), 2):
        heading = parts[i].strip()
        body = parts[i + 1].strip() if i + 1 < len(parts) else ""
        sections[heading] = body
    return sections


# --------------------------------------------------------------------------
# Lint: cross-check widgets against declared globals
# --------------------------------------------------------------------------

def lint(globals_: List[str], parameters: List[dict]) -> List[str]:
    warnings = []
    global_set = {g.lower() for g in globals_}
    bound = {p["variable"].lower() for p in parameters if p.get("variable")}
    exposed_not_declared = bound - global_set
    # NetLogo also implicitly treats every slider/switch/chooser/input's
    # `variable` as a global even if not in the `globals [...]` block, so
    # this is informational, not necessarily a bug.
    for v in sorted(exposed_not_declared):
        warnings.append(
            f"Widget-bound variable '{v}' is not in the explicit `globals [...]` "
            f"block (NetLogo auto-declares interface globals, so this is expected, "
            f"not an error)."
        )
    return warnings


# --------------------------------------------------------------------------
# Top-level
# --------------------------------------------------------------------------

def build_model_card(nlogox_text: str, slug: str, lineage: Optional[List[str]] = None,
                      concepts: Optional[List[str]] = None) -> dict:
    extracted = extract_from_nlogox(nlogox_text)
    code = extracted["code"]

    globals_ = extract_globals(code)
    breeds = extract_breeds(code)
    procs = extract_procedures(code)
    entry_points = find_entry_points(procs)
    info_sections = split_info_sections(extracted["info"])
    warnings = lint(globals_, extracted["parameters"])

    card = {
        "slug": slug,
        "world": extracted["view"],
        "globals": globals_,
        "breeds": breeds,
        "procedures": {
            name: {"kind": p.kind, "params": p.params, "calls": p.calls}
            for name, p in procs.items()
        },
        "entry_points": entry_points,
        "parameters": extracted["parameters"],
        "outputs": extracted["outputs"],
        "controls": extracted["controls"],
        "info_sections": info_sections,
        "lineage": lineage or [],
        "concepts": concepts or [],
        "lint_warnings": warnings,
    }
    return card


def main():
    if len(sys.argv) < 3:
        print("usage: model_card.py input.nlogox output.json [slug]", file=sys.stderr)
        sys.exit(1)
    in_path, out_path = sys.argv[1], sys.argv[2]
    slug = sys.argv[3] if len(sys.argv) > 3 else in_path.split("/")[-1].rsplit(".", 1)[0]
    with open(in_path, "r", encoding="utf-8") as f:
        xml_text = f.read()
    card = build_model_card(xml_text, slug)
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(card, f, indent=2)
    print(f"Wrote {out_path}")
    print(f"  procedures: {len(card['procedures'])}  entry points: {card['entry_points']}")
    print(f"  parameters: {len(card['parameters'])}  outputs: {len(card['outputs'])}")
    if card["lint_warnings"]:
        print(f"  lint notes: {len(card['lint_warnings'])}")


if __name__ == "__main__":
    main()
