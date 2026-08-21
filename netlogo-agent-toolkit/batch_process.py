#!/usr/bin/env python3
"""
batch_process.py
-----------------
The real "run it for real" entry point: converts and decomposes every model
in the collection (../models/<slug>/model.nlogo), writing the generated
artifacts directly into that model's own folder --

    models/<slug>/<slug>.nlogox        NetLogo 7 XML
    models/<slug>/model-card.json      full structural decomposition
    models/<slug>/agent-manifest.json  AI-agent control-surface manifest

-- rather than into this toolkit's own space, so the collection's real
per-model home (documented in the top-level netlogo/README.md) stays the
one source of truth. For a single-model, narrated walkthrough of the same
pipeline instead of a batch run, see examples/two-foresters/demo.py.

Run from anywhere:
    python3 batch_process.py
"""
import json
import sys
from pathlib import Path

TOOLKIT_ROOT = Path(__file__).parent
MODELS_ROOT = TOOLKIT_ROOT.parent / "models"
sys.path.insert(0, str(TOOLKIT_ROOT))

from converter.nlogo_to_nlogox import convert as nlogo_to_nlogox
from decompose.model_card import build_model_card
from decompose.agent_manifest import build_agent_manifest


def process_one(slug_dir: Path) -> dict:
    slug = slug_dir.name
    nlogo_path = slug_dir / "model.nlogo"
    result = {"slug": slug, "ok": False, "warnings": [], "error": None}
    if not nlogo_path.exists():
        result["error"] = f"no model.nlogo in {slug_dir}"
        return result

    title = slug
    metadata_path = slug_dir / "metadata.json"
    if metadata_path.exists():
        try:
            title = json.loads(metadata_path.read_text(encoding="utf-8")).get("title", slug)
        except (json.JSONDecodeError, OSError):
            pass

    try:
        raw = nlogo_path.read_text(encoding="utf-8")
        xml_str, report = nlogo_to_nlogox(raw)
        result["warnings"].extend(report.warnings)

        card = build_model_card(xml_str, slug=slug)
        result["warnings"].extend(card.get("lint_warnings", []))

        manifest = build_agent_manifest(card, title=title)

        (slug_dir / f"{slug}.nlogox").write_text(xml_str, encoding="utf-8")
        (slug_dir / "model-card.json").write_text(json.dumps(card, indent=2), encoding="utf-8")
        (slug_dir / "agent-manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")

        result["ok"] = True
        result["procedures"] = len(card["procedures"])
        result["parameters"] = len(card["parameters"])
        result["outputs"] = len(card["outputs"])
        result["reporters"] = len(manifest["available_reporters"])
        result["plot_pens"] = len(manifest["plot_pens"])
    except Exception as e:  # noqa: BLE001 -- batch driver: one bad model must not abort the rest
        result["error"] = f"{type(e).__name__}: {e}"
    return result


def main():
    if not MODELS_ROOT.is_dir():
        print(f"models/ not found at {MODELS_ROOT}", file=sys.stderr)
        sys.exit(1)

    slug_dirs = sorted(p for p in MODELS_ROOT.iterdir() if p.is_dir())
    results = [process_one(d) for d in slug_dirs]

    print(f"{'model':40s} {'ok':4s} {'procs':6s} {'params':7s} {'outputs':8s} {'reporters':10s} {'pens':5s} warnings")
    print("-" * 105)
    n_ok = 0
    for r in results:
        if r["ok"]:
            n_ok += 1
            print(f"{r['slug']:40s} {'PASS':4s} {r['procedures']:<6d} {r['parameters']:<7d} "
                  f"{r['outputs']:<8d} {r['reporters']:<10d} {r['plot_pens']:<5d} {len(r['warnings'])}")
        else:
            print(f"{r['slug']:40s} {'FAIL':4s} {'-':6s} {'-':7s} {'-':8s} {'-':10s} {'-':5s} {r['error']}")

    print("-" * 100)
    print(f"{n_ok}/{len(results)} models converted + decomposed cleanly.")
    for r in results:
        for w in r["warnings"]:
            print(f"  [{r['slug']}] WARNING: {w}")

    sys.exit(0 if n_ok == len(results) else 1)


if __name__ == "__main__":
    main()
