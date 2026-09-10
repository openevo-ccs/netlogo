# LPM Strand: Evolution and Competition for Resources (Abstract)

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment
> (including a new International Curriculum Grounding section, US NGSS + Sachsen Gymnasium
> Biologie), competency alignment, and assessment status are drafted below (2026-08-29). Step 5
> (a formal, schema-validated ConceptBase LPM contribution) is not done.

## Model
- [Run the model](../models/evolution-competition-resources-abstract/app.html)
- [Model metadata](../models/evolution-competition-resources-abstract/metadata.json)
- [Download .nlogo](../models/evolution-competition-resources-abstract/model.nlogo)

## Overview

This is the abstracted sibling of `evolution-competition-forest-resources`: agents (default
appearance "Bacteria") harvest a fixed amount of resource per iteration — `Harvest-sustainables`
vs. `Harvest-greedy` — from patches that regrow logistically. There's no forestry framing here;
the model's own documentation states its purpose plainly: "we can also observe
**predator-prey-dynamics** between the resource and its user population." That reframing is the
strand's hook — the same mechanism (differential harvest → differential fitness → trait-frequency
change → resource-stock feedback) that plays out as commons overuse in the forestry version plays
out here as an oscillating predator-prey-style population cycle, because this version adds a
`Death-rate` (independent of energy) that the forestry version doesn't have.

## Grade-Band Progression

### Grades 6-8: Resource Competition Without a Cover Story

**Learning Objectives:**
- Describe the resource-harvest-reproduction cycle without needing a forestry or any other
  real-world frame — i.e. reason about the mechanism itself, abstractly.
- Observe that the resource level and the agent population level both fluctuate, and notice
  whether they move together or in opposite directions over time.
- Distinguish "sustainable" and "greedy" as labels for a harvest-amount trait, not as moral
  categories.

**Key Concepts:** Trait variation, resource regrowth, differential reproduction, population
fluctuation.

**Activities:**
1. Run the model with `Reproduction` on and watch "Populations (% of carrying capacity)" — record
   whether Resource and Agents plot lines move together, oppositely, or with a lag.
2. Switch `Agents-Appearance` between "Bacteria," "Persons," and "Circles" and discuss: does
   changing what the agents *look like* change what the model is actually simulating? (It
   shouldn't — this is a lesson in distinguishing a model's surface representation from its
   underlying mechanism.)
3. Compare this model side-by-side with `evolution-competition-forest-resources` and list what's
   the same mechanism underneath the different presentation.

**Assessment Indicators:** Describes the harvest-reproduction cycle without relying on a forestry
metaphor; notices the lag/oscillation pattern between resource and population; explicitly
identifies the forest-resources model as "the same mechanism, different presentation."

### Grades 9-12: Predator-Prey Dynamics as a General Pattern

**Learning Objectives:**
- Explain why a harvester population and its resource can oscillate — the resource depletes when
  harvester population/greediness is high, harvesters then decline (via `Death-rate` and reduced
  reproduction) once resource is scarce, allowing the resource to recover, which then allows the
  harvester population to grow again.
- Connect this pattern explicitly to classical predator-prey (Lotka-Volterra-style) dynamics,
  while being precise about what's different (this is trait-frequency evolution *within* one
  interacting resource-harvester system, not two separate species with independent population
  dynamics).
- Analyze how `Death-rate` (independent of energy) changes the qualitative dynamics compared to
  the forest-resources model, which has no such independent death term.

**Key Concepts:** Population oscillation; carrying capacity; density-dependent regulation; natural
selection under fluctuating resource availability; model abstraction (what's gained/lost by
stripping away the forestry cover story).

**Activities:**
1. Run BehaviorSpace-style repeated trials varying `Death-rate` from 0% to 10% and characterize
   how oscillation amplitude/period changes.
2. Build a causal map of the full feedback loop (resource level → harvest success → energy →
   reproduction/death → agent population → total harvest pressure → resource level) and identify
   where the delays are.
3. Compare to a real predator-prey system (e.g. lynx-hare population cycles) via Analogy Mapping,
   explicitly naming where the analogy holds and where it breaks (this model has one population
   playing both "predator" and evolving-trait roles, not two).

**Assessment Indicators:** Explains the oscillation mechanistically, not just descriptively;
correctly attributes the qualitative behavior to specific parameters (`Death-rate` especially);
uses the predator-prey analogy precisely, naming its limits.

## Content Anchor Alignment

**Primary:**
1. **Computer Models** — the strand's central pedagogical move (surface representation vs.
   underlying mechanism, via the `Agents-Appearance` chooser) is a "what is this model actually
   simulating" lesson only a computer model affords this directly.
2. **Governing the Commons** — same common-pool-resource mechanism as the forest-resources model,
   without the concrete framing.

**Secondary:**
3. **Cross-Species Comparisons** — the model's own stated predator-prey framing invites direct
   comparison to real predator-prey population cycles across many taxa.
4. **Global Sustainability Goals** — resource oscillation and collapse risk generalizes to any
   real depletable-resource system.

## Thinking Tool Integration

1. **Causal Mapping** — the resource-harvest-reproduction-death feedback loop, with explicit
   attention to the delay between resource depletion and population decline (the mechanism behind
   the oscillation).
2. **Analogies & Analogy Mapping** — map to real predator-prey systems (lynx-hare, algae-zooplankton);
   name explicitly where the analogy breaks (one evolving population here, not two independent
   species).
3. **Structure of Knowledge Diagrams** — useful specifically because this model is *already* an
   abstraction; ask students to build the SoK diagram themselves and then re-attach a concrete
   example (forestry, fisheries, a real predator-prey system) at the bottom layer.

## International Curriculum Grounding

Real, citation-grounded — distinct from the OpenEvo/ConceptBase competency alignment below.

**US — NGSS.**
- **HS-LS2-2** (LS2.A, Interdependent Relationships in Ecosystems) — "mathematical
  representations to support and revise explanations based on evidence about factors affecting
  biodiversity and populations in ecosystems." Direct match for the oscillation-pattern activity.
- **HS-LS2-1** (LS2.A) — carrying-capacity factors, matching the resource/agent-population plot.
- **HS-LS4-2** (LS4.B, Natural Selection) — same four-factor evolution account as the
  forest-resources model.
- **MS-LS2-1** (LS2.A) — "analyze and interpret data...for the effects of resource availability on
  organisms and populations."

**Germany — Sachsen Gymnasium Biologie** (from `EvoMentor/importers/fwu_sn_fine_grained_candidates.json`;
coverage status `fine-grained-content-staged-untagged` — **grade band unspecified in the current
staged data**):

- *"Zusammenwirken von Mutation, Rekombination, Selektion und Isolation..."* —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-7649-1` (also `-7649-2`).
- *"Kennen von Prinzipien der Evolution von Organismen"* — `-7646-1`/`-7646-2`.
- **This model's strongest German match**: *"interspezifische Beziehungen - Konkurrenz, Symbiose,
  Parasitismus, Räuber-Beute-Beziehung"* (interspecific relationships — competition, symbiosis,
  parasitism, **predator-prey relationship**) —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-120088-1` and `-7969-1`. This is a direct
  citation match to this specific model's own self-description ("predator-prey-dynamics"), found
  via a broader term search this pass (not the "evolution" label filter, but the same staged
  Gymnasium Biologie dataset) — a stronger, more specific match than the general
  evolution-factors entries above.
- *"Parameter und Wachstum einer Population"* (population growth parameters) —
  `-7970-1`/`-7970-2` — matches the logistic-growth/carrying-capacity mechanic directly.

**Gap flagged**: no ConceptBase concept for "predator-prey dynamics" or "population oscillation"
specifically exists (main or the pending `extend-bio-core-evolution-mechanisms` branch); the
closest is the general `OE-CONCEPT-bio-core-population`.

## Competency Alignment

Verified against the real ConceptBase registry (`d:/dev/openevo-ccs-lab/conceptbase/registry/concept/`,
2026-08-29):

- **OE-CONCEPT-bio-core-natural-selection (Natural Selection, BIO-CORE-v1.0.0)**.
- **OE-CONCEPT-bio-core-population (Population, BIO-CORE-v1.0.0)** — the oscillating
  resource/agent population as the direct object of study; performance indicator: read and
  interpret the "Populations (% of carrying capacity)" plot correctly.
- **OE-CONCEPT-bio-core-fitness (Fitness, BIO-CORE-v1.0.0)**.
- **OE-SANDBOX-CONCEPT-000009 (Agent-Based Modeling, OE-INTERDISCIPLINARY-v1.0.0)** — performance
  indicator: explain why changing `Agents-Appearance` doesn't change the underlying simulated
  mechanism (surface representation vs. model logic).

**Not yet in ConceptBase**: predator-prey dynamics / population oscillation as a named concept
(see gap note above).

## Assessment

**No assessment file exists yet** for this model. Needs building.

**Vignette sketch, grounded in the actual model**: "You ran the model with `Harvest-sustainables`
at 7, `Harvest-greedy` at 15, `Death-rate` at 3%, and `Reproduction` on. Over 1000 ticks, you
observed the resource level and agent population rise and fall in a repeating cycle, with the
population peak always arriving about 50-80 ticks after the resource peak. A classmate says 'the
agents are causing the cycle by getting greedier over time.' Using the model's actual mechanism,
explain what's really driving the cycle and why there's a delay between the resource peak and the
population peak." — targets misconceptions about agency/intention in oscillating systems and
tests understanding of causal delay, mirroring `assessments/island-world.json`'s existing pattern
of testing understanding of *balance between two forces* (there: migration vs. selection; here:
harvest pressure vs. regrowth).

## Common Misconceptions

1. "Agents get greedier over time and that causes the cycle" — the cycle is driven by the
   resource-population feedback loop, not by a trend in average greediness (which itself
   fluctuates as a *result* of the cycle, not a cause independent of it).
2. "The model simulates real predator-prey species" — it simulates one population and one
   resource, which happens to produce a formally similar oscillation; naming this precisely is
   part of the Undergraduate/9-12-level lesson, not an incidental detail.
3. "Changing the agents' appearance changes what's being simulated" — surface representation vs.
   underlying mechanism.
4. "A stable-looking average conceals a stable population" — oscillating systems can have a
   roughly constant long-run average while never actually being at that average.

## Connections to Other Models

- **evolution-competition-forest-resources** — same underlying mechanism with a concrete forestry
  framing and no independent `Death-rate`; the primary "surface vs. mechanism" comparison for this
  strand.
- **evolution-resource-use-harvest-efficiency** — replaces the binary trait with a continuous
  harvest-amount trait and adds harvesting-cost diminishing returns.
- **wolves-sheep-grass** (out of scope for this pass, not evolution-themed) — the NetLogo Models
  Library's canonical predator-prey model; a natural cross-reference for the Undergraduate band's
  Lotka-Volterra comparison, even though it isn't part of this pass's scope.

## References

- Hanisch, S. (2022). Evolution and competition for resources. OpenEvo NetLogo Models.
  https://openevo.eva.mpg.de/teachingbase/netlogo/

## Schema-Ready Contribution

**Not done.** A formal LPM contribution to ConceptBase, validated against its real `lpm.schema.yaml`, is the
natural next step for this strand, not claimed here.

---

**Status:** In progress — grade-band/content-anchor/international-grounding/competency drafted
2026-08-29; assessment item bank and schema contribution (steps 4-5) still pending.
