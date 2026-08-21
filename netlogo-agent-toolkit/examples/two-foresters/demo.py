#!/usr/bin/env python3
"""
demo.py
-------
Illustrative, single-model, in-memory walkthrough of the toolkit pipeline
against Two Foresters -- reads the real, canonical model source directly
from ../../../models/two-foresters/ (this repo's actual source of truth)
and never writes any files itself. For the real, committed per-model
artifacts (<slug>.nlogox, model-card.json, agent-manifest.json) see
models/two-foresters/ directly, or regenerate all 14 with
../../batch_process.py.

    1. convert  models/two-foresters/model.nlogo  ->  .nlogox (in memory)
    2. extract  that .nlogox                       ->  Model Card (in memory)
    3. validate a synthetic broken experiment fixture against the model card
    4. validate a correctly-written experiment, as a positive control
    5. run the reference simulator: private vs. commons forest management
       under asymmetric harvest rates, and print the wealth/stock deltas

Run from anywhere:
    python3 examples/two-foresters/demo.py
"""
import hashlib
import sys
from pathlib import Path

EXAMPLE_DIR = Path(__file__).parent
TOOLKIT_ROOT = EXAMPLE_DIR.parent.parent
MODELS_ROOT = TOOLKIT_ROOT.parent / "models"
sys.path.insert(0, str(TOOLKIT_ROOT))
sys.path.insert(0, str(EXAMPLE_DIR))

from converter.nlogo_to_nlogox import convert as nlogo_to_nlogox
from decompose.model_card import build_model_card
from experiments.validate_experiment import validate
from reference_runtime import TwoForestersReferenceRuntime


def section(title):
    print(f"\n{'=' * 70}\n{title}\n{'=' * 70}")


def main():
    src = MODELS_ROOT / "two-foresters" / "model.nlogo"

    section("1. Convert .nlogo -> .nlogox (in memory)")
    raw = src.read_text(encoding="utf-8")
    xml_str, report = nlogo_to_nlogox(raw)
    print(f"Converted {src} ({len(xml_str)} bytes of .nlogox) -- not written to disk; "
          f"see models/two-foresters/two-foresters.nlogox for the committed version.")
    for w in report.warnings:
        print(f"  WARNING: {w}")

    section("2. Extract Model Card (in memory)")
    card = build_model_card(xml_str, slug="two-foresters")
    print(f"  procedures: {len(card['procedures'])}  entry points: {card['entry_points']}")
    print(f"  parameters: {[p['variable'] for p in card['parameters']]}")
    print(f"  outputs:    {len(card['outputs'])} widgets")

    section("3. Validate a synthetic broken-experiment fixture (expect FAIL)")
    broken_path = EXAMPLE_DIR.parent.parent / "experiments" / "fixtures" / "two-foresters-harvest-regrowth.SYNTHETIC-BUGGY.xml"
    results = validate(broken_path.read_text(encoding="utf-8"), card)
    for r in results:
        print(f"[{'PASS' if r.ok else 'FAIL'}] {r.experiment_name}")
        for issue in r.issues:
            print(f"  {issue.severity.upper():7s} {issue.where}: {issue.message[:100]}")

    section("4. Validate a correctly-written experiment (expect PASS)")
    good_path = EXAMPLE_DIR.parent.parent / "experiments" / "fixtures" / "two-foresters-correct-sweep.xml"
    if good_path.exists():
        results = validate(good_path.read_text(encoding="utf-8"), card)
        for r in results:
            print(f"[{'PASS' if r.ok else 'FAIL'}] {r.experiment_name}")

    section("5. Reference simulation: private vs. commons management")
    model_hash = hashlib.sha256(xml_str.encode()).hexdigest()[:16]

    def run(private, cut1, cut2, seed=42, ticks=60):
        rt = TwoForestersReferenceRuntime(card, model_hash, seed=seed)
        rt.set_param("Percent-cut1", cut1)
        rt.set_param("Percent-cut2", cut2)
        rt.set_param("Private-forest?", private)
        rt.setup()
        rt.step(ticks)
        return rt.series(), rt

    print("Modest forester (1) at 20% cut rate, greedy forester (2) at 90% cut rate:")
    s_priv, rt_priv = run(True, 20.0, 90.0)
    s_comm, rt_comm = run(False, 20.0, 90.0)

    print(f"\n  Private forests:")
    print(f"    modest wealth = {s_priv['forester1_wealth'][-1]:.1f}   "
          f"forest1 stock = {s_priv['forest1_stock_pct'][-1]:.1f}%")
    print(f"    greedy wealth = {s_priv['forester2_wealth'][-1]:.1f}   "
          f"forest2 stock = {s_priv['forest2_stock_pct'][-1]:.1f}%")
    print(f"    total stock   = {s_priv['total_stock_pct'][-1]:.1f}%")

    print(f"\n  Shared commons:")
    print(f"    modest wealth = {s_comm['forester1_wealth'][-1]:.1f}")
    print(f"    greedy wealth = {s_comm['forester2_wealth'][-1]:.1f}")
    print(f"    total stock   = {s_comm['total_stock_pct'][-1]:.1f}%")

    delta = s_comm['forester2_wealth'][-1] - s_priv['forester2_wealth'][-1]
    print(f"\n  The greedy forester earns {delta:+.1f} more wealth under commons than "
          f"private, at the modest forester's expense -- reproducing the model's "
          f"documented social-dilemma dynamic.")

    print(f"\n  Reproducibility check: two independent runs with seed=42 -> "
          f"world_hash equal: {run(True, 20.0, 90.0)[1].world_hash() == rt_priv.world_hash()}")


if __name__ == "__main__":
    main()
