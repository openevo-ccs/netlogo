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
validation/run_smoke_tests.py    runs every model's .nlogox headless against a real
                                  NetLogo 7 install and reports pass/fail
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
table shows 14/14 converted with no exceptions), and — as of 2026-08-21 —
all 14 also compile and run on a real NetLogo 7.0.4 engine (see step 4b).

Documented conversion assumptions (places the public wiki schema turned out
to be wrong or silent) are in the module docstring — notably: real 7.0.4
holds every code/text-bearing element's content as the element's own
text/CDATA (`<button>foo</button>`), not a nested `<source>` child as the
wiki's per-widget documentation pattern implies by analogy.

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

**4b. Validate against a real engine.** `validation/run_smoke_tests.py` runs
every model's `.nlogox` headless against a real NetLogo 7 install
(`org.nlogo.headless.Main`, bypassing `netlogo-headless.bat`'s quoting bug
on install paths with spaces). 14/14 compile and run cleanly. See "Known
gaps" below for what this caught and fixed in both the converter and the
Model Card reader.

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

- **Resolved 2026-08-21: validated against a real NetLogo 7.0.4 engine.**
  A NetLogo 7.0.4 desktop install became available; `validation/run_smoke_tests.py`
  runs every model's `.nlogox` headless (`org.nlogo.headless.Main`, bypassing
  `netlogo-headless.bat` — its `-D...=^"%BASE_DIR%"` pattern has a real
  quoting bug on any install path containing a space, e.g. the default
  `C:\Program Files\NetLogo 7.0.4`: a trailing backslash immediately before a
  closing quote is parsed as an escaped literal quote, not a terminator,
  corrupting the rest of the command line). All 14 models now compile and
  run 20 ticks cleanly.
  Getting there found and fixed real converter bugs the public wiki schema
  didn't surface, confirmed by diffing against NetLogo 7.0.4's own bundled
  sample `.nlogox` models (e.g. `models/Sample Models/Biology/Wolf Sheep
  Predation.nlogox`):
    - `kind` (button) and `direction` (slider) are **capitalized** enum
      tokens (`Observer`/`Turtle`/`Patch`/`Link`, `Horizontal`/`Vertical`) —
      the wiki documents them lowercase, which 7.0.4 rejects outright with
      `scala.MatchError`.
    - Every code/text-bearing element (`<code>`, `<info>`, `<button>`,
      `<monitor>`, plot/pen `<setup>`/`<update>`, `<note>`, `<input>`) holds
      its content as the element's **own text/CDATA**, never a nested
      `<source>`/`<text>`/`<value>` child as the wiki's per-widget analogy
      implied. `model_card.py`'s extraction had the same wrong assumption
      (it round-tripped against the converter's own prior — also wrong —
      output), so fixing the writer without fixing the reader would have
      silently zeroed out every model's `procedures`/`entry_points`/control
      `code` fields; both were fixed together.
    - Chooser numeric choices use `type="double"`, not `type="number"`
      (that's the `<input>` box's vocabulary).
    - `<model version="...">` carries a `"NetLogo "` prefix (e.g.
      `"NetLogo 7.0.4"`), not a bare version number.
  Separately, headless `--setup-file` does not work as documented in 7.0.4
  — confirmed against a known-good NetLogo-authored sample model, not just
  our own output — so `run_smoke_tests.py` embeds a throwaway
  `<experiments>` block directly in a scratch copy of each `.nlogox` instead
  (and reads the model's *actual* Setup-button code from `model-card.json`
  rather than assuming a procedure literally named `setup` — Evolution of
  Ethnocentrism's Setup button calls `setup-full`).
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
- **`app.html` (the browser-playable NetLogo Web export in each model's
  folder) is still a NetLogo 6.1 export, unrelated to this toolkit's `.nlogox`
  work** — the `.nlogox`/model-card/agent-manifest files are validated
  against a real NetLogo 7.0.4 engine, but nothing regenerates `app.html`
  from them. NetLogo 7's "Save As NetLogo Web..." (`org.nlogo.app.tools.
  NetLogoWebSaver`) is GUI-only, no CLI/headless equivalent exists (confirmed
  via `NetLogo_Console --help`). A same-process reflective call to it throws
  `FileNotFoundException` on a jar-packaged resource it expects to read some
  other way when the real app bootstraps normally. A follow-up attempt to
  drive the real GUI programmatically via Java Access Bridge + Windows UI
  Automation got the JVM-side AT stack loading cleanly (`-Djavax.
  accessibility.assistive_technologies=com.sun.java.accessibility.internal.
  AccessBridge`, `--add-modules=jdk.accessibility`, `--add-exports=
  jdk.accessibility/com.sun.java.accessibility.internal=java.desktop`, plus
  registering `windowsaccessbridge-64.dll` into `System32`) but the native
  bridge never actually exposed the Swing menu tree to an external UI
  Automation client (0 descendant elements found even after the JVM-side
  activation stopped erroring) — the remaining gap is undiagnosed. Re-export
  is a manual, per-model, GUI click-through for now: open `model.nlogo` (or
  `.nlogox`) in the real NetLogo 7 desktop app, **File → Save As NetLogo
  Web...**, save over `app.html` — see the procedure below for how to do
  that without losing the current 6.x version.

## Upgrading a model's web export to NetLogo 7

Every model keeps **both** web-export versions side by side rather than a
hard cutover — the enrichment work above (`.nlogox`, model-card, agent
manifest) doesn't require `app.html` itself to be NetLogo 7, and several
things depend on today's known-working 6.x export (e.g. the sibling `me-mo`
repo has already copied `two-foresters/app.html` for an offline demo). The
convention:

- `app.html` — whichever version is currently the **live default** (what
  `assets/models.json`'s `htmlApp`, each model's `metadata.json`, and the
  explorer app actually load). Right now that's still NetLogo 6.1 for every
  model.
- `app-legacy6.html` — the NetLogo 6.x export, preserved permanently once a
  model is upgraded, so nothing that depended on the pre-upgrade version
  breaks silently.

To upgrade one model once you can do the GUI export (manually, or via a
future working automation):

1. `cp models/<slug>/app.html models/<slug>/app-legacy6.html` — preserve
   the current version **before** touching `app.html`.
2. In the NetLogo 7 desktop app: open `models/<slug>/model.nlogo` (or the
   validated `.nlogox`), **File → Save As NetLogo Web...**, save over
   `models/<slug>/app.html`.
3. Actually open the new `app.html` in a browser and click through it —
   don't just trust that the export succeeded.
4. If it works: done. Both files now exist; `app.html` is v7 and is the new
   live default automatically (nothing else needs to change, since
   `models.json`/`metadata.json` already point at `app.html` by filename).
   Consider adding an explicit `htmlAppLegacy` pointer to that model's
   `metadata.json` and `assets/models.json` entry so the explorer can
   surface a "classic version" link, if that's wanted.
5. If it doesn't work: `cp models/<slug>/app-legacy6.html models/<slug>/app.html`
   to restore the known-good version immediately — never leave a broken
   `app.html` live — then keep investigating before retrying.

Do this per model, not as a bulk operation — verify each one before moving
to the next, and don't pre-create `app-legacy6.html` files for models that
haven't actually been re-exported yet (that's just a same-content duplicate
until step 2 actually changes `app.html`, and at ~5.3MB per model, doing
that for all 14 speculatively adds ~75MB of pure duplication to the repo for
zero new information).

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
