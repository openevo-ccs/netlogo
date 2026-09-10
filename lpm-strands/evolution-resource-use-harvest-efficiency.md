# LPM Strand: Evolution of Resource Use with Harvest Efficiency

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment
> (including a new International Curriculum Grounding section, US NGSS + Sachsen Gymnasium
> Biologie), competency alignment, and assessment status are drafted below (2026-08-29). Step 5
> (a formal, schema-validated ConceptBase LPM contribution) is not done. This model already has real
> teaching materials linked from `metadata.json` (a slide deck and a lesson-plan document) — this
> strand does not duplicate those, it builds the LPM layer around them.

## Model
- [Run the model](../models/evolution-resource-use-harvest-efficiency/app.html)
- [Model metadata](../models/evolution-resource-use-harvest-efficiency/metadata.json)
- [Download .nlogo](../models/evolution-resource-use-harvest-efficiency/model.nlogo)
- [Existing slide deck (UI overview)](https://docs.google.com/presentation/d/e/2PACX-1vQz-oiLWn1fp-CzcrUkqoR5kE6tPNWtmNQO4Fg2D6UPlWDhZMAC1-ZZDAWaOGMgTW-KHzfoRMTtgQeP/pub?start=false&loop=false&delayms=3000)
- [Existing lesson plan](https://docs.google.com/document/d/1MsaUu3s7zfMZcLVSsZP8g6v0p46OAfOgx3HnyenSb0Q/edit?usp=sharing)

## Overview

Agents each carry a continuous **harvest-amount trait** (not a binary sustainable/greedy choice)
that starts randomly distributed between 0.5 and 99.5 and evolves via mutation and differential
reproduction. What makes this model distinct from its siblings is `harvest-costs-factor`: energy
actually received is `Harvest amount - Harvest costs × (1.2 ^ harvest amount)` — an explicit
**diminishing-returns** function. At `harvest-costs-factor = 0`, harvesting is free regardless of
amount and the population evolves toward maximal harvest (and resource depletion); as the factor
rises, high-harvest strategies become actively costly, and the population's evolved harvest-rate
distribution shifts downward. This is the strand's central lesson: whether "greed evolves" is not
a fixed biological fact about resource users, it's *conditional on the cost structure of
harvesting itself* — a genuinely different claim from the binary-trait models in this set.

## Grade-Band Progression

### Grades 9-12: Harvest Efficiency as an Evolutionary Trade-off

**Learning Objectives:**
- Read the histogram of agents by harvest amount and describe how the distribution's shape (not
  just its mean) changes as `harvest-costs-factor` changes.
- Explain diminishing returns as a real functional relationship (not just "high harvest is bad")
  — connect the formula `Harvest amount - Harvest costs × (1.2^harvest amount)` to the model's
  observed outcomes.
- Predict, before running the model, what happens to the evolved harvest-rate distribution as
  `harvest-costs-factor` increases from 0 to 1, then check the prediction.
- Distinguish this model's continuous-trait evolution from the binary sustainable/greedy trait in
  `evolution-competition-forest-resources` and `evolution-competition-resources-abstract`.

**Key Concepts:** Continuous trait variation; diminishing returns; trade-offs; natural selection on
a quantitative trait; carrying capacity.

**Activities:**
1. Run the model at `harvest-costs-factor = 0`, record the final harvest-amount distribution
   (histogram), then repeat at `0.3`, `0.6`, and `1.0` — build a table of how the distribution's
   center and spread change.
2. Graph the diminishing-returns formula by hand (or spreadsheet) for a few `harvest-costs-factor`
   values and connect the shape of that curve to the model's evolved outcome.
3. Compare this model's outcome logic to `evolution-competition-forest-resources`'s binary
   modest/greedy trait: what does a continuous trait let you observe that a binary one can't?
4. Use the existing lesson plan and slide deck (linked above) alongside this strand's grade-band
   framing.

**Assessment Indicators:** Connects the diminishing-returns formula to the observed shift in
harvest-rate distribution; predicts direction of change correctly before running the model;
articulates what a continuous trait adds over a binary one.

### Grades 9-12 (extension) / Undergraduate: Optimal Foraging and Real-World Harvest Economics

**Learning Objectives:**
- Connect the model's harvest-cost mechanic to optimal foraging theory (an established framework
  in behavioral ecology and human evolutionary anthropology) and to real resource-economics
  concepts like marginal cost of extraction.
- Analyze how `Death-rate` (independent of energy) interacts with `harvest-costs-factor` to shape
  the population's long-run size and harvest-rate distribution.
- Evaluate the model's abstraction: it has no technology, no learning, and no social transmission
  of harvesting technique — all of that would need to enter as a *cost-factor change*, not as a
  new mechanism, since the model has none. Compare to `evolution-resource-use-behavior-imitation`
  (in this same model set), which adds exactly the missing social-learning mechanism.

**Key Concepts:** Optimal foraging theory; marginal cost/return; model scope and limitations;
quantitative-trait evolution.

**Activities:**
1. Design a BehaviorSpace experiment sweeping `harvest-costs-factor` × `Death-rate` and analyze
   the resulting harvest-rate distributions statistically.
2. Read a short optimal-foraging-theory summary (e.g. from human behavioral ecology) and identify
   which of its core ideas (patch choice, marginal value, diminishing returns) this model
   implements vs. omits.
3. Write a short comparison of this model to `evolution-resource-use-behavior-imitation`: what
   would have to be added here to let harvesting behavior change *within* an agent's lifetime,
   rather than only across generations?

**Assessment Indicators:** Connects model mechanics to optimal foraging theory with specific,
correct correspondences (not just a vague "it's related to economics" claim); designs a
methodologically sound BehaviorSpace sweep; identifies the model's missing mechanisms precisely.

## Content Anchor Alignment

**Primary:**
1. **Computer Models** — the diminishing-returns formula is directly inspectable and manipulable,
   letting students test a specific functional hypothesis rather than accept a stated outcome.
2. **Global Sustainability Goals** — harvest efficiency and its relationship to resource
   sustainability is a live real-world policy question (fisheries quotas, extraction-cost
   economics).

**Secondary:**
3. **Ancient Ancestors** — the model's own `metadata.json` subjects list "History" and "Human
   Evolution"; harvest-cost trade-offs connect directly to optimal foraging theory's account of
   ancestral human foraging decisions.

## Thinking Tool Integration

1. **Causal Mapping** — map: harvest amount → energy (net of harvest cost) → reproduction
   probability → offspring harvest-amount trait (with mutation) → population-level distribution
   shift → resource-stock feedback.
2. **Structure of Knowledge Diagrams** — facts (an agent with harvest-amount 40 nets less energy
   than one with harvest-amount 20, once `harvest-costs-factor` is high enough) → concept
   (diminishing returns) → principle (selection favors whatever trait value maximizes net fitness
   given the current cost structure, not whatever trait value maximizes gross harvest).
3. **Tinbergen's Questions** — apply specifically to "why does harvest efficiency matter": Function
   (what fitness problem does efficient harvesting solve?), Mechanism (the cost formula itself).

## International Curriculum Grounding

Real, citation-grounded — distinct from the OpenEvo/ConceptBase competency alignment below.

**US — NGSS.**
- **HS-LS4-2** (LS4.B, Natural Selection) — four-factor account of evolution; here on a
  continuous, not binary, trait.
- **HS-LS4-4** — "construct an explanation based on evidence for how natural selection leads to
  adaptation of populations" — direct match for the harvest-rate-distribution-shift activity.
- **HS-LS2-1** (LS2.A) — carrying capacity, matching the Populations plot.
- Note: NGSS does not have a DCI specifically for "diminishing returns" or "marginal cost" as an
  evolutionary mechanism — those are this model's own quantitative-trade-off framing, best
  grounded in optimal foraging theory (behavioral ecology) rather than a specific NGSS code; don't
  force one.

**Germany — Sachsen Gymnasium Biologie** (from `EvoMentor/importers/fwu_sn_fine_grained_candidates.json`;
coverage status `fine-grained-content-staged-untagged` — **grade band unspecified in the current
staged data**):

- *"Zusammenwirken von Mutation, Rekombination, Selektion und Isolation..."* —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-7649-1` (also `-7649-2`).
- **This model's strongest German match**: *"Anwenden der Kenntnisse über den Stoff- und
  Energiewechsel auf die Evolution der Ernährungsweisen"* (applying knowledge of metabolism/energy
  exchange to the evolution of feeding modes) —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-8153-1` and `-8153-2`. This is a direct,
  specific match: the model's entire mechanic *is* an energy-accounting function (harvest amount
  minus harvest cost) applied to the evolution of feeding/harvesting behavior — precisely what
  this Lernziel names.
- *"Kennen von Prinzipien der Evolution von Organismen"* — `-7646-1`/`-7646-2`.

**Gap flagged**: "diminishing returns," "marginal cost," and "optimal foraging" have no
ConceptBase concept (main or the pending `extend-bio-core-evolution-mechanisms` branch); the
closest existing concept is `OE-CONCEPT-bio-core-fitness`, which doesn't capture the
cost-function-shape idea specifically.

## Competency Alignment

Verified against the real ConceptBase registry (`d:/dev/openevo-ccs-lab/conceptbase/registry/concept/`,
2026-08-29):

- **OE-CONCEPT-bio-core-fitness (Fitness, BIO-CORE-v1.0.0)** — the model's central mechanism (net
  energy, not gross harvest, determines fitness); performance indicator: distinguish gross harvest
  from net fitness given a cost function.
- **OE-CONCEPT-bio-core-natural-selection (Natural Selection, BIO-CORE-v1.0.0)**.
- **OE-CONCEPT-bio-core-selection-pressure (Selection Pressure, BIO-CORE-v1.0.0)** —
  `harvest-costs-factor` as a directly manipulable selection-pressure parameter; performance
  indicator: predict how changing selection pressure shifts a continuous trait's distribution.
- **OE-CONCEPT-bio-core-mutation (Mutation, BIO-CORE-v1.0.0)**.

**Not yet in ConceptBase**: diminishing returns / marginal-cost-of-harvest as a named concept (see
gap note above).

## Assessment

**No assessment file exists yet** for this model. Needs building.

**Vignette sketch, grounded in the actual model**: "You ran the model twice, both times with
`Number-agents` at 50 and `Mutation-rate` at 0.5%. In Run 1, `harvest-costs-factor` was 0, and by
tick 500 the histogram showed most agents harvesting near 90-99.5 units. In Run 2,
`harvest-costs-factor` was 0.8, and by tick 500 most agents harvested near 5-15 units. Nothing else
changed between the runs. Using the model's actual harvest-cost formula, explain why the same
starting population evolved toward such different harvest rates." — targets the misconception that
"greed" or "sustainability" is a fixed trait of a population rather than a trait-value shaped by
the specific cost structure the population faces.

## Common Misconceptions

1. "Some populations are just greedier than others" — harvest rate is not a fixed population
   character, it's an evolved response to the specific cost structure; the same starting
   population evolves differently under different `harvest-costs-factor` values.
2. "More harvesting is always better for the harvester" — ignores diminishing returns; past a
   point, higher harvest amount yields *less* net energy, not more.
3. "The continuous trait model and the binary sustainable/greedy models are testing different
   biology" — they're the same underlying mechanism (variation, differential fitness, inheritance,
   mutation); the trait's structure (binary vs. continuous) is a modeling choice, not a difference
   in what evolution is doing.

## Connections to Other Models

- **evolution-competition-forest-resources** / **evolution-competition-resources-abstract** — same
  resource-competition mechanism with a binary rather than continuous harvest trait; useful
  contrast for what a continuous trait reveals that a binary one can't.
- **evolution-resource-use-behavior-imitation** — adds social learning (imitation) on top of a
  similar harvest-trait-evolution mechanism, letting harvest behavior change within a lifetime,
  not only across generations; the natural "what's still missing here" follow-on model.

## References

- Hanisch, S. (2022). Evolution of harvest rate with influence of harvesting cost. OpenEvo NetLogo
  Models. https://openevo.eva.mpg.de/teachingbase/netlogo/
- Existing lesson plan and slide deck (linked in Model section above) — real, already-built
  teaching materials for this specific model, predating this strand.

## Schema-Ready Contribution

**Not done.** A formal LPM contribution to ConceptBase, validated against its real `lpm.schema.yaml`, is the
natural next step for this strand, not claimed here.

---

**Status:** In progress — grade-band/content-anchor/international-grounding/competency drafted
2026-08-29; assessment item bank and schema contribution (steps 4-5) still pending.
