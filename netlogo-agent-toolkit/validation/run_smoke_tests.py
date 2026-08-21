"""
run_smoke_tests.py
-------------------
Validates every model's <slug>.nlogox against a REAL NetLogo 7 engine: for
each model, reads its already-generated model-card.json to find the actual
Setup/Start button code (not a hardcoded "setup"/"go" -- see
evolution-ethnocentrism, whose Setup button calls `setup-full`), embeds a
throwaway BehaviorSpace <experiments> block matching NetLogo 7.0.4's real
schema (confirmed against NetLogo's own bundled sample .nlogox models --
notably `timeLimit` is an <experiment> attribute and metrics are wrapped in
<metrics><metric>...</metric></metrics>, not the smoke_experiment.xml
fixture's standalone-BehaviorSpace-XML shape, since `--setup-file` does not
work as documented in 7.0.4 even against a known-good NetLogo sample model),
and runs it 20 ticks headless via `org.nlogo.headless.Main`.

This bypasses `netlogo-headless.bat`, which has a real quoting bug on any
Windows install path containing a space (e.g. the default "C:\\Program
Files\\NetLogo 7.0.4"): its `-D...=^"%BASE_DIR%"` pattern ends each -D value
with a trailing backslash immediately before the closing quote, which
Windows argv parsing treats as an escaped literal quote rather than a
terminator, corrupting the rest of the command line.

Usage:
    python3 run_smoke_tests.py [--netlogo-dir "C:\\Program Files\\NetLogo 7.0.4"]

Requires a real NetLogo 7 desktop install (auto-detected under
"C:\\Program Files\\NetLogo *" if --netlogo-dir is omitted) and that
batch_process.py has already been run so every model has a fresh .nlogox +
model-card.json.
"""
from __future__ import annotations
import argparse
import glob
import json
import os
import subprocess
import sys

TOOLKIT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODELS_DIR = os.path.join(os.path.dirname(TOOLKIT_DIR), "models")

EXPERIMENT_TEMPLATE = (
    '<experiments><experiment name="smoke" repetitions="1" '
    'sequentialRunOrder="true" runMetricsEveryStep="false" timeLimit="20">'
    '<setup>{setup}</setup><go>{go}</go>'
    '<metrics><metric>ticks</metric></metrics>'
    '</experiment></experiments>'
)


def find_netlogo_dir() -> str:
    candidates = sorted(glob.glob(r"C:\Program Files\NetLogo *"), reverse=True)
    if not candidates:
        raise SystemExit("No NetLogo install found under 'C:\\Program Files\\NetLogo *'. "
                          "Pass --netlogo-dir explicitly.")
    return candidates[0]


def build_smoke_copy(slug: str, out_dir: str) -> str:
    card_path = os.path.join(MODELS_DIR, slug, "model-card.json")
    nlogox_path = os.path.join(MODELS_DIR, slug, f"{slug}.nlogox")
    card = json.load(open(card_path, encoding="utf-8"))
    setup = next((c["code"] for c in card["controls"] if c["display"] == "Setup" and c["code"]), "setup")
    go = next((c["code"] for c in card["controls"] if c.get("forever") and c["code"]), "go")

    content = open(nlogox_path, encoding="utf-8").read().rstrip()
    assert content.endswith("</model>"), f"{slug}: .nlogox doesn't end with </model>"
    content = content[:-len("</model>")] + EXPERIMENT_TEMPLATE.format(setup=setup, go=go) + "</model>\n"

    dst = os.path.join(out_dir, f"{slug}.smoke.nlogox")
    open(dst, "w", encoding="utf-8").write(content)
    return dst


def run_headless(netlogo_dir: str, model_path: str, log_path: str) -> int:
    java = os.path.join(netlogo_dir, "runtime", "bin", "java.exe")
    jar = os.path.join(netlogo_dir, "app", os.path.basename(glob.glob(os.path.join(netlogo_dir, "app", "netlogo-*.jar"))[0]))
    cmd = [
        java,
        "-XX:MaxRAMPercentage=50", "-Dfile.encoding=UTF-8",
        f"-Dnetlogo.docs.dir={netlogo_dir}",
        f"-Dnetlogo.models.dir={os.path.join(netlogo_dir, 'models')}",
        f"-Dnetlogo.extensions.dir={os.path.join(netlogo_dir, 'extensions')}",
        "--add-exports=java.base/java.lang=ALL-UNNAMED",
        "--add-exports=java.desktop/sun.awt=ALL-UNNAMED",
        "--add-exports=java.desktop/sun.java2d=ALL-UNNAMED",
        "-classpath", jar,
        "org.nlogo.headless.Main",
        "--model", model_path,
        "--experiment", "smoke",
        "--table", "-",
    ]
    with open(log_path, "w", encoding="utf-8") as log:
        proc = subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT)
    return proc.returncode


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--netlogo-dir", default=None, help=r'e.g. "C:\Program Files\NetLogo 7.0.4"')
    ap.add_argument("--keep-artifacts", action="store_true",
                     help="keep generated .smoke.nlogox/.log files instead of deleting on success")
    args = ap.parse_args()

    netlogo_dir = args.netlogo_dir or find_netlogo_dir()
    out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "smoke-runs")
    os.makedirs(out_dir, exist_ok=True)

    slugs = sorted(os.path.basename(os.path.dirname(p)) for p in
                    glob.glob(os.path.join(MODELS_DIR, "*", "model-card.json")))

    results = []
    for slug in slugs:
        model_path = build_smoke_copy(slug, out_dir)
        log_path = os.path.join(out_dir, f"{slug}.log")
        code = run_headless(netlogo_dir, model_path, log_path)
        results.append((slug, code))
        print(f"{'PASS' if code == 0 else 'FAIL'}  {slug}  (exit {code})")
        if code == 0 and not args.keep_artifacts:
            os.remove(model_path)
            os.remove(log_path)

    n_fail = sum(1 for _, c in results if c != 0)
    print(f"\n{len(results) - n_fail}/{len(results)} models validated cleanly against {netlogo_dir}.")
    if n_fail:
        print("See netlogo-agent-toolkit/validation/smoke-runs/*.log for failures.")
        sys.exit(1)


if __name__ == "__main__":
    main()
