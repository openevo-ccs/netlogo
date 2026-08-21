# NetLogo Agent Toolkit

A generic, model-agnostic pipeline that turns any model in the sibling
[`models/`](../models/) collection (the [OpenEvo CCS Lab](https://openevo.eva.mpg.de/teachingbase/netlogo/)
collection, mirrored at `openevo-ccs/netlogo` on GitHub) into NetLogo 7 XML plus two
machine-readable decompositions built for AI-agent consumption. It started as a
prototype validated against one model (Two Foresters); it now runs cleanly
across all 14.

## What's here

```
converter/nlogo_to_nlogox.py     legacy .nlogo -> NetLogo 7 .nlogox converter
decompose/model_card.py          .nlogox -> structured Model Card (JSON)
decompose/agent_manifest.py      Model Card -> AI-agent control-surface manifest (JSON)
experiments/validate_experiment.py   BehaviorSpace XML validator against a Model Card
experiments/fixtures/            synthetic test fixtures for validate_experiment.py
                                  (not real collection artifacts — see their own comments)
runtime/interface.py             abstract tool contract (setup/step/report/...)
examples/two-foresters/          one worked example: a hand-written reference runtime
                                  implementing runtime/interface.py for Two Foresters
                                  specifically, plus demo.py, a narrated single-model
                                  walkthrough of the whole pipeline
batch_process.py                 runs convert -> model-card -> agent-manifest for every
                                  model in ../models/, writing outputs into each
                                  model's own folder (the real "run it for real" entry
                                  point — see Pipeline below)
```

**Generated artifacts live in `../models/<slug>/`, not in this toolkit.** Every model in
the collection now has, alongside its existing `app.html`/`model.nlogo`/`metadata.json`:
`<slug>.nlogox`, `model-card.json`, and `agent-manifest.json`. This toolkit is the
generator, not the storage location — that used to not be true (see History below).

Run `python3 batch_process.py` from this directory to regenerate all three files for
every model. Run `python3 examples/two-foresters/demo.py` for a single-model, narrated,
in-memory walkthrough of the same pipeline (writes nothing to disk).

## Pipeline

**1. Convert.** `nlogo_to_nlogox.py` parses the legacy 12-section `.nlogo`
format (documented at [NetLogo/NetLogo wiki: Pre-7.0.0 File Format](https://github.com/NetLogo/NetLogo/wiki/Pre%E2%80%907.0.0-File-Format-(.nlogo)-and-Widget-Format))
and emits valid NetLogo 7 `.nlogox` XML per the
[7.0.0 XML schema](https://github.com/NetLogo/NetLogo/wiki/XML-File-Format).
Runs cleanly across all 14 models in the collection (`batch_process.py`'s summary
table shows 14/14 converted with no exceptions).

Documented conversion assumptions (places the public wiki schema is
ambiguous or silent) are in the module docstring — notably: the wiki's
`<monitor>` element lists no reporter-source field at all, which can't be
right, so we infer one by analogy with `<button>`/`<plot>`.

**2. Decompose.** `model_card.py` turns the model into a JSON manifest an
agent can read directly instead of re-deriving structure from raw NetLogo
code every turn: globals, breeds + breed-vars, every procedure with a
call graph, every widget split into parameters (sliders/switches/choosers)
vs. outputs (monitors/plot pens) vs. controls (buttons), and the Info tab
split into its section headings.

None of the 14 models use link-breeds or extension calls (`py:`, `nw:`) — the
two parser gaps this module's regex-based approach hadn't been stress-tested
against — so the same code that was validated on Two Foresters runs clean on
the rest of the collection too.

**3. Generate the agent manifest.** `agent_manifest.py` takes a Model Card and
emits a smaller control-surface manifest — not a generic dump, but shaped
directly around what a live, LLM-driven orchestrator actually needs to drive a
running NetLogo Web session. That shape isn't invented: it's reverse-engineered
from a real, independent consumer — the Me-Mo project's browser-side bridge
between an LLM orchestrator and a live NetLogo Web session
(`js/netlogo-bridge.js`'s `applyOps()`/`getState()`, `whiteboard_assets.py`'s
`NETLOGO_MODELS[id]` dict) — which today hand-transcribes this exact shape,
once, for exactly one model. See the module docstring for the full mapping.

Key design point, found by actually running this over all 14 models rather
than just Two Foresters: a plot pen's update code is a NetLogo *command*
(`plot`, `plotxy`, `if [...] [ plot ... ]`, even `carefully [...] [...]` in
Island World), not a bare *reporter* — only `<monitor>` widgets are
schema-guaranteed to hold one. `available_reporters` is built from monitors
only, for exactly that reason (`interface.py`'s own contract: never let
something be evaluated as a reporter if it isn't one). Plot pens are kept
separately, under `plot_pens`, clearly labeled as command code.

**4. Validate.** `validate_experiment.py` cross-checks a saved BehaviorSpace
experiment against the Model Card *before* an agent is allowed to run it.
It caught two real bugs in a synthetic test fixture built to exercise this
checker (`experiments/fixtures/two-foresters-harvest-regrowth.SYNTHETIC-BUGGY.xml`
— see that file's own comment; it is a constructed regression fixture, not a
real saved experiment pulled from the collection):
  - References variables (`harvest-rate-1`, `energy`, `strategy`) that
    don't exist in Two Foresters at all (they belong to other, more evolved
    models in the same collection — grep-confirmed).
  - Every `steppedValueSet` uses `var=` instead of the schema's `variable=`
    attribute — a silent-failure bug worse than a crash, since a real
    BehaviorSpace runner would likely just never vary that parameter rather
    than erroring.

  `experiments/fixtures/two-foresters-correct-sweep.xml` is a positive control
  that passes clean, proving the validator discriminates rather than
  rubber-stamping.

**5. Run (worked example only).** `examples/two-foresters/reference_runtime.py`
implements the shared `ModelRuntime` contract from `runtime/interface.py`
(`describe/set_param/setup/step/report/sample_agents/patch_grid/snapshot/
world_hash/run_record`) as a pure-Python reimplementation of *Two Foresters'*
actual extracted procedures specifically — it is not a generic runtime for
the other 13 models. Verified:
  - **Reproducible**: same seed → identical `world_hash()` across independent runs.
  - **Guardrailed**: `set_param` rejects out-of-bounds values, unknown
    parameter names, and wrong types; `report()` only accepts the model's
    own declared monitor reporter expressions, never arbitrary NetLogo code.
  - **Substantively correct**: reproduces the model's documented
    social-dilemma dynamic — under asymmetric harvest rates (modest 20% /
    greedy 90%), moving from private to shared forests increases the greedy
    forester's wealth (3424 → 4810) at the modest forester's expense.

## Known gaps

- **No NetLogo 7 install was available to validate `.nlogox` against a real
  engine.** This is the gap that actually matters and remains open. A NetLogo
  6.4.0 desktop install *is* present on this machine, but 6.4.0 cannot open the
  new `.nlogox` format at all (it's NetLogo-7-only) — so it can't validate the
  converter's output directly, only serve as an oracle for the legacy `.nlogo`
  source.
- **A limited real-engine cross-check of the legacy `.nlogo` was attempted and
  intentionally not pushed further.** NetLogo 6.4.0's bundled JVM launcher
  script hard-codes JVM flags (`-XX:MaxRAMPercentage=50`, `--add-exports=...`)
  that assume a bundled Java 11+ runtime; this install's bundled `runtime/bin`
  is missing its actual `java.exe` (DLLs only), so it silently falls back to
  the system Java 8, which rejects those flags outright. Borrowing a Java 11
  JDK from another installed application (Gephi) got the JVM itself launching
  cleanly, and in the process caught a real bug in this repo's own smoke-test
  fixture (an XML comment containing `--`, illegal per the XML spec — Xerces
  and Python's `ElementTree` both correctly rejected it). Past that, NetLogo's
  headless `--setup-file` loader rejected the (now well-formed) fixture XML
  for a reason not further diagnosed. Given NetLogo 7 is where OpenEvo's
  actual direction is headed, further 6.x troubleshooting was deliberately
  not pursued past this point rather than expanding it into a full 14-model
  sweep — see `validation/smoke_experiment.xml` for the fixture as it stands.
- `model_card.py`'s procedure/call-graph parser is regex-based. It has now
  been run clean across all 14 models in the collection (none use
  link-breeds or extension calls), but a model outside this collection using
  either would still need real testing.
- The Model Card's `lineage` field is empty. The collection's own READMEs
  already state the derivation chain (Two Foresters → Evolution and
  Competition for Forest Resources → ...) — wiring those edges in is
  mostly transcription and unlocks cross-model teaching ("here's what
  changed from the model you just ran").
- `validate_experiment.py`'s reporter-expression check is lexical, not a
  real NetLogo parser — it catches wrong/missing identifiers but not
  semantic errors, and can miss issues inside nested `let`-bound locals.
- A few models expose sliders with a NetLogo *expression* as their bound,
  not a static number (Island World's `Number-Agents` slider:
  `max="count patches with [foodpatch? = true] / 2"`). `model_card.py`
  already passes this through as a raw string rather than crashing; any
  consumer of `agent-manifest.json`'s `controls.sliders[].max` needs to
  handle a non-numeric value, not assume every bound is a float.

## History

This toolkit was originally built and exercised only against Two Foresters,
and in doing so accumulated its own copy of that model's source
(`source-model/`) and its own copy of the generated outputs (`output/`) —
both have since been removed as duplicates of what already lives canonically
in `../models/two-foresters/`. The Two-Foresters-specific reference runtime
and demo moved to `examples/two-foresters/`; synthetic test fixtures moved to
`experiments/fixtures/`; a new `batch_process.py` and `decompose/agent_manifest.py`
generalize the pipeline to the whole collection.

## Provenance

Model source: OpenEvo / TeachingBase, OpenEvo CCS Lab
(https://openevo.eva.mpg.de/teachingbase/netlogo/), licensed CC BY-SA 4.0.
Collection mirror: `github.com/openevo-ccs/netlogo`.
