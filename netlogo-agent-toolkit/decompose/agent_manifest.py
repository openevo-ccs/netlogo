"""
agent_manifest.py
------------------
Takes a Model Card (model_card.py's output) and emits a smaller,
purpose-built "agent manifest": exactly the control-surface shape a live,
LLM-driven orchestrator needs to drive a running NetLogo Web session --
nothing more.

This shape is not invented -- it is reverse-engineered from a real, working
consumer: the Me-Mo project's (d:\\dev_local\\me-mo, a separate, independent
repo -- referenced here as prior art, not a dependency) browser-side bridge
between an LLM orchestrator and a live NetLogo Web `SessionLite` instance:

  - `android_app/me-mo-app/js/netlogo-bridge.js`'s `applyOps()` issues three
    kinds of ops an orchestrator can emit: `set` (slider/switch by name),
    `run` (arbitrary command), and `animate` (click the real forever/"Start"
    button by its visible display text and watch ticks advance) -- which is
    exactly `entry_points` + `controls.sliders/switches/buttons` below.
  - `android_app/server/whiteboard_assets.py`'s `NETLOGO_MODELS[id]` dict
    hand-transcribes, per model, a `controls` block (slider/switch
    name+range) and a `state_reporters` map (a hand-picked subset of real
    monitor/plot-pen reporter expressions) for the orchestrator's system
    prompt and for reading live state back after each turn.

Today that transcription is done by hand, once, for exactly one model
(Two Foresters). This module generates the same shape for any model this
toolkit can build a Model Card for, as a superset candidate list --
`available_reporters` intentionally includes every monitor/plot-pen
expression the model exposes, not just the handful a given lesson cares
about, so picking the meaningful subset stays a human (or downstream-agent)
judgment call informed by real data instead of hand-deriving reporter
expressions from raw NetLogo code.

Dependency-free (stdlib only), matching the rest of this toolkit.
"""
from __future__ import annotations
import json
import re
import sys
from typing import Dict, List, Optional


def _slug(text: Optional[str]) -> str:
    s = re.sub(r"[^a-z0-9]+", "_", (text or "").strip().lower())
    return re.sub(r"_+", "_", s).strip("_")


# NetLogo monitor/plot-pen reporters overwhelmingly take the shape
# `<agg> [<var>] of <agentset>` (e.g. "sum [wealth] of farmers1") -- pulling
# the bracketed variable name out is a cheap, generally-useful disambiguator
# for widgets that share a display label (this collection's Two Foresters
# has two monitors both displayed "Forester 1": one reports wealth, one
# reports harvest -- slug-only keys would silently collide).
_VAR_IN_BRACKETS_RE = re.compile(r"\[\s*([A-Za-z_][A-Za-z0-9_\-?]*)\s*\]")


def _reporter_key(base_label: str, expr: str, used: set) -> str:
    base = _slug(base_label) or "reporter"
    m = _VAR_IN_BRACKETS_RE.search(expr or "")
    candidate = f"{base}_{_slug(m.group(1))}" if m else base
    key = candidate
    i = 2
    while key in used:
        key = f"{candidate}_{i}"
        i += 1
    used.add(key)
    return key


def _find_setup_button(controls: List[dict]) -> Optional[dict]:
    for c in controls:
        if c.get("forever"):
            continue
        display = (c.get("display") or "").strip().lower()
        code = (c.get("code") or "").strip().lower()
        if display == "setup" or re.search(r"^\s*setup\b", code):
            return c
    return None


def _find_forever_button(controls: List[dict]) -> Optional[dict]:
    for c in controls:
        if c.get("forever"):
            return c
    return None


def build_agent_manifest(card: dict, title: Optional[str] = None) -> dict:
    slug = card.get("slug", "unknown")
    controls = card.get("controls", [])
    parameters = card.get("parameters", [])
    outputs = card.get("outputs", [])

    setup_btn = _find_setup_button(controls)
    forever_btn = _find_forever_button(controls)

    entry_points = {
        "setup": (setup_btn.get("code").strip() if setup_btn and setup_btn.get("code") else
                  ("setup" if "setup" in card.get("procedures", {}) else None)),
        "step": (forever_btn.get("code").strip() if forever_btn and forever_btn.get("code") else
                 ("go" if "go" in card.get("procedures", {}) else None)),
        "forever_button_display": forever_btn.get("display") if forever_btn else None,
    }

    sliders = [
        {"name": p["variable"], "min": p.get("min"), "max": p.get("max"),
         "step": p.get("step"), "default": p.get("default")}
        for p in parameters if p.get("widget") == "slider"
    ]
    switches = [
        {"name": p["variable"], "default": p.get("default")}
        for p in parameters if p.get("widget") == "switch"
    ]
    choosers = [
        {"name": p["variable"], "values": p.get("values"), "default": p.get("default")}
        for p in parameters if p.get("widget") == "chooser"
    ]
    buttons = [
        {"display": c.get("display"), "code": c.get("code"), "forever": bool(c.get("forever"))}
        for c in controls
    ]

    # Only <monitor> widgets are schema-guaranteed to hold a bare *reporter*
    # expression (NetLogo's own widget format: a monitor's <source> is
    # always a reporter). A plot pen's update code is a *command* block --
    # `plot <reporter>`, `plotxy ...`, `if [...] [ plot ... ]`,
    # `carefully [...] [...]` are all real, common shapes here (see e.g.
    # island-world's pens) -- and is therefore NOT safe to hand to something
    # that calls `runReporter()`/`report()` on it (interface.py's own
    # contract: report() must never accept arbitrary free-text NetLogo).
    # Plot pens are still valuable context, so they're kept separately,
    # clearly labeled as command code rather than folded into
    # `available_reporters` as if they were agent-callable.
    used_keys: set = set()
    available_reporters: Dict[str, str] = {}
    plot_pens: List[dict] = []
    for out in outputs:
        if out.get("widget") == "monitor":
            expr = (out.get("reporter") or "").strip()
            if not expr:
                continue
            key = _reporter_key(out.get("display") or "monitor", expr, used_keys)
            available_reporters[key] = expr
        elif out.get("widget") == "plot":
            plot_label = out.get("display") or "plot"
            for pen in out.get("pens", []):
                code = (pen.get("update") or "").strip()
                if not code:
                    continue
                plot_pens.append({"plot": plot_label, "pen": pen.get("display"), "update_code": code})

    return {
        "id": slug,
        "title": title or slug,
        "entry_points": entry_points,
        "controls": {
            "sliders": sliders,
            "switches": switches,
            "choosers": choosers,
            "buttons": buttons,
        },
        "available_reporters": available_reporters,
        "plot_pens": plot_pens,
    }


def main():
    if len(sys.argv) < 3:
        print("usage: agent_manifest.py model-card.json output.json [title]", file=sys.stderr)
        sys.exit(1)
    card_path, out_path = sys.argv[1], sys.argv[2]
    title = sys.argv[3] if len(sys.argv) > 3 else None
    with open(card_path, "r", encoding="utf-8") as f:
        card = json.load(f)
    manifest = build_agent_manifest(card, title=title)
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)
    print(f"Wrote {out_path}")
    print(f"  entry_points: {manifest['entry_points']}")
    print(f"  sliders: {len(manifest['controls']['sliders'])}  switches: {len(manifest['controls']['switches'])}  "
          f"choosers: {len(manifest['controls']['choosers'])}  buttons: {len(manifest['controls']['buttons'])}")
    print(f"  available_reporters: {len(manifest['available_reporters'])}  plot_pens: {len(manifest['plot_pens'])}")


if __name__ == "__main__":
    main()
