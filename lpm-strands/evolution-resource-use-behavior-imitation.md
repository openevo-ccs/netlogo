# LPM Strand: Evolution of Resource Use Through Behavior Imitation

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment
> (including a new International Curriculum Grounding section, US NGSS + Sachsen Gymnasium
> Biologie), competency alignment, and assessment status are drafted below (2026-08-29). Step 5
> (a formal, schema-validated ConceptBase LPM contribution) is not done. This model already has two real
> linked teaching materials in `metadata.json` (a cultural-evolution-vs-gene-focused-evolution
> lesson plan, and "what motivates people to save energy") — this strand builds the LPM layer
> around them, not a replacement.

## Model
- [Run the model](../models/evolution-resource-use-behavior-imitation/app.html)
- [Model metadata](../models/evolution-resource-use-behavior-imitation/metadata.json)
- [Download .nlogo](../models/evolution-resource-use-behavior-imitation/model.nlogo)
- [Related: Cultural evolution vs. gene-focused evolution](https://openevo.eva.mpg.de/teachingbase/cultural-evolution-vs-gene-focused-evolution/)
- [Related: What motivates people to save energy](https://openevo.eva.mpg.de/teachingbase/what-motivates-people-to-save-energy/)

## Overview

This model takes the familiar sustainable/greedy harvest trait and adds a **second inheritance
channel**: alongside biological reproduction (offspring inherit a parent's trait, subject to
`behavior-innovation-rate`), agents can also **imitate** neighbors during their lifetime, according
to an `Imitation-bias` chooser with five real options — most successful, majority, minority, most
experienced, or parents. This is the strand's central pedagogical opportunity: it is the only
model in this set (and one of very few in the whole collection) that makes **biological and
cultural evolution run side by side, as two distinct, separately-controllable mechanisms acting on
the same trait**. Setting `Imitation-bias` to "parents" effectively disables cultural transmission
(behavior tracks biological inheritance only); every other setting introduces within-lifetime
behavior change, which the model's own documentation explicitly calls "cultural selection" and
connects to the emergence of "norms and traditions."

## Grade-Band Progression

### Grades 9-12: Two Channels of Inheritance

**Learning Objectives:**
- Distinguish biological inheritance (offspring resembling parents via reproduction) from cultural
  transmission (agents changing behavior within their lifetime via imitation) as two separate
  mechanisms this model implements explicitly and separately.
- Explain each of the five `Imitation-bias` options in the model's own terms (success bias,
  conformist/majority bias, anti-conformist/minority bias, prestige-by-experience bias, vertical/
  parental transmission) and predict how each would shape the spread of sustainable vs. greedy
  behavior differently.
- Observe how quickly trait frequencies shift under imitation (within a few dozen ticks) compared
  to under biological inheritance alone (many generations) — a directly observable difference in
  the *speed* of cultural vs. biological change.

**Key Concepts:** Biological vs. cultural evolution; imitation bias (success, conformist,
anti-conformist, prestige, vertical); norms and traditions; behavioral innovation.

**Activities:**
1. Set `Imitation-bias` to "parents" (biological inheritance only) and run the model; then set it
   to "majority" (conformist cultural transmission) with everything else unchanged, and compare how
   fast and how completely the sustainable/greedy trait frequency shifts.
2. Compare "most successful" (success bias) to "most experienced" (prestige-by-age bias) — do they
   converge on the same outcome, or can they diverge? Under what resource conditions?
3. Use `behavior-innovation-rate` (a within-lifetime "cultural mutation") alongside `Mutation-rate`-
   equivalent biological variation and discuss: are these the same kind of variation-generating
   process, or meaningfully different ones?
4. Connect to the linked "what motivates people to save energy" material: which of the five
   imitation biases best matches a specific real energy-conservation behavior-change campaign you
   can think of (e.g. neighborhood energy-use comparison letters as a majority/conformist-bias
   intervention)?

**Assessment Indicators:** Correctly distinguishes biological from cultural transmission using this
model's actual mechanism, not a generic definition; predicts differential outcomes across
imitation-bias settings and explains why; connects at least one imitation bias to a real
behavior-change intervention.

### Undergraduate: Dual Inheritance Theory and Norm Formation

**Learning Objectives:**
- Situate this model's mechanism within dual inheritance theory / gene-culture coevolution
  (Boyd & Richerson; Henrich) as a real, established theoretical framework, using the linked
  "cultural evolution vs. gene-focused evolution" lesson plan as a starting text.
- Analyze how spatial structure (`chance-agents-move`) interacts with imitation bias to produce
  clustered "traditions" — regions of the world that settle on different norms — versus a single
  global norm.
- Critically evaluate the model's simplifications: agents imitate based on perfect information
  about neighbors' harvest type, energy, and age within a fixed radius; real cultural transmission
  involves imperfect, costly, and strategically filtered information.

**Key Concepts:** Dual inheritance theory; gene-culture coevolution; conformist/anti-conformist/
success/prestige transmission biases (Henrich & Boyd's taxonomy); spatial clustering of norms;
model scope and limitations.

**Activities:**
1. Read the linked cultural-evolution-vs-gene-focused-evolution lesson plan and map its
   terminology onto this model's actual chooser options and mechanisms.
2. Design a BehaviorSpace experiment varying `Imitation-bias` × `chance-agents-move` and test
   whether low mobility produces spatially clustered "traditions" (different regions settling on
   different norms) while high mobility produces a single global norm.
3. Write a short critique of what this model's imitation mechanism omits relative to real human
   cultural transmission (e.g. no cost to imitating, no strategic information-hiding, no verbal/
   symbolic transmission) and what adding one of those would likely change.

**Assessment Indicators:** Uses dual inheritance theory terminology correctly and connects it to
specific model mechanisms; designs and interprets the mobility × imitation-bias experiment
correctly; identifies specific, non-generic model limitations.

## Content Anchor Alignment

**Primary:**
1. **Cultural Diversity** — the model's core mechanism is exactly what this anchor asks about:
   what's universal (the underlying selection-like dynamic) vs. culturally variable (which norm a
   given cluster of agents settles on, dependent on imitation bias and local history).
2. **Computer Models** — the only model in this set letting a student toggle between "biological
   inheritance only" and five distinct cultural-transmission mechanisms on the identical
   underlying trait and resource system.

**Secondary:**
3. **Governing the Commons** — same underlying commons dilemma as the forest-resources/abstract
   models, now with the added possibility that a cultural norm (not just biological selection) can
   stabilize sustainable behavior.
4. **Global Sustainability Goals** — the linked "what motivates people to save energy" material
   makes the real-world behavior-change connection explicit, not just implied.

## Thinking Tool Integration

1. **Analogies & Analogy Mapping** — map each `Imitation-bias` option to real cultural-transmission
   research (success bias ↔ copying successful farmers' techniques; majority/conformist bias ↔
   norm nudges like neighborhood energy-comparison letters; prestige/most-experienced bias ↔
   copying elders or high-status individuals); name explicitly where each analogy is precise and
   where the model's perfect-information assumption breaks it.
2. **Structure of Knowledge Diagrams** — the clearest use case in this whole set: facts (agent X
   copied agent Y's harvest behavior this tick) → concepts (imitation bias, cultural transmission) →
   principles (dual inheritance theory: biological and cultural evolution as two parallel, jointly-
   operating inheritance systems).
3. **Causal Mapping** — map how `Imitation-bias` + `chance-agents-move` jointly determine whether
   norms stay spatially clustered or homogenize globally.

## International Curriculum Grounding

Real, citation-grounded — distinct from the OpenEvo/ConceptBase competency alignment below.

**US — NGSS.** NGSS has **no Disciplinary Core Idea for cultural evolution or social learning
specifically** — its LS4 (evolution) strand is genetic/biological, and its closest DCI, LS2.D
(Social Interactions and Group Behavior), addresses behavior's role in survival/reproduction but
not cultural transmission mechanisms as such. Rather than force a weak match, this strand names
that gap directly: the biological-inheritance *half* of this model is still gettable via
**HS-LS4-2** (LS4.B, four-factor natural selection account — applies to the `behavior-innovation-
rate`/reproduction channel) and **HS-LS2-8** (LS2.D, group behavior and survival/reproduction —
applies loosely to the imitation channel's fitness consequences), but the cultural-transmission
mechanism itself (imitation bias, norm formation) is **not** NGSS-covered content. The German
Sachsen data below is this model's primary, better-fitting curriculum citation for that half.

**Germany — Sachsen Gymnasium Biologie** (from `EvoMentor/importers/fwu_sn_fine_grained_candidates.json`;
coverage status `fine-grained-content-staged-untagged` — **grade band unspecified in the current
staged data**):

- **This model's single most direct match in the whole eight-model set**: *"kulturelle Evolution"*
  (cultural evolution) — `https://lp-sachsen.org/resource/lernziel-lerninhalt-126109-1`. This is a
  named Lernziel in Sachsen's real Gymnasium Biologie curriculum data, and it is precisely this
  model's subject matter — not a loose thematic connection like most of this set's other
  citations.
- *"Zusammenwirken von Mutation, Rekombination, Selektion und Isolation..."* —
  `-7649-1`/`-7649-2` — grounds the model's biological-inheritance channel specifically.
- Supplementary: *"Kennen von Methoden und Bedeutung der Verhaltensbiologie"* (methods and
  significance of behavioral biology) — `-8099-1`/`-7838-1`/`-8099-2` — grounds the
  imitation/behavior-observation mechanism generally.

**Gap flagged**: ConceptBase does have real concepts for the general mechanism —
`OE-CONCEPT-oe-interdisciplinary-culture`, `OE-CONCEPT-oe-interdisciplinary-transmission`,
`OE-CONCEPT-oe-interdisciplinary-learning`, `OE-CONCEPT-oe-interdisciplinary-norms`,
`OE-CONCEPT-oe-interdisciplinary-innovation` all exist and are directly relevant (see Competency
Alignment). What's *missing* is a concept for the specific transmission-bias taxonomy (success,
conformist, anti-conformist, prestige/experience bias) this model implements as five distinct
chooser options — no such concept exists in ConceptBase main or in the pending
`extend-bio-core-evolution-mechanisms` branch (which is BIO-CORE-scoped and doesn't cover cultural
evolution at all).

## Competency Alignment

Verified against the real ConceptBase registry (`d:/dev/openevo-ccs-lab/conceptbase/registry/concept/`,
2026-08-29):

- **OE-CONCEPT-oe-interdisciplinary-culture (Culture, OE-INTERDISCIPLINARY-v1.0.0)**.
- **OE-CONCEPT-oe-interdisciplinary-transmission (Transmission, OE-INTERDISCIPLINARY-v1.0.0)** —
  performance indicator: distinguish vertical (parent-to-offspring) from oblique/horizontal
  (imitating any neighbor) transmission using the model's own `Imitation-bias` options.
- **OE-CONCEPT-oe-interdisciplinary-learning (Learning, OE-INTERDISCIPLINARY-v1.0.0)** — the only
  model in this set where agents "adapt their behavior over their lifetimes" (per the model's own
  documentation, under "Learning and Adaptation") — every sibling resource model explicitly states
  agents do *not* learn.
- **OE-CONCEPT-oe-interdisciplinary-norms (Norms, OE-INTERDISCIPLINARY-v1.0.0)** — direct match to
  the model's own "norms and traditions" language.
- **OE-CONCEPT-oe-interdisciplinary-innovation (Innovation, OE-INTERDISCIPLINARY-v1.0.0)** — direct
  match to `behavior-innovation-rate`.
- **OE-CONCEPT-oe-interdisciplinary-selection (Selection, OE-INTERDISCIPLINARY-v1.0.0)** — this
  concept's own definition set explicitly includes a **culture** sense ("differential persistence
  or spread of cultural variants...based on their fit to a social or environmental context"),
  making it a genuinely dual-purpose citation for this model specifically, not a stretch.

**Not yet in ConceptBase**: the specific transmission-bias taxonomy (success/conformist/
anti-conformist/prestige bias) — see gap note above.

## Assessment

**No assessment file exists yet** for this model. Needs building.

**Vignette sketch, grounded in the actual model**: "You ran the model twice with identical starting
conditions (`Sustainables` = 1 out of 50 agents, everything else default) except for
`Imitation-bias`. In Run 1 (`Imitation-bias` = 'parents'), the sustainable trait spread slowly, only
reaching 40% of the population by tick 2000. In Run 2 (`Imitation-bias` = 'majority'), it spread
much faster after crossing roughly 50% frequency, reaching 90% by tick 800 — but it also nearly
died out early on, when it was still rare. Using the model's actual mechanism, explain both
observations: why is majority-bias imitation slower than biological inheritance when a trait is
rare, and faster once the trait is common?" — targets frequency-dependent dynamics specific to
conformist transmission, a well-documented real phenomenon (Henrich & Boyd's conformist-bias
models) that this vignette asks students to notice from the model's own behavior rather than being
told.

## Common Misconceptions

1. "Cultural evolution and biological evolution are the same process with different content" —
   this model makes the mechanisms genuinely different (imitation happens within a lifetime, at
   `imitation-likelihood` each tick; biological inheritance happens only at reproduction) and lets
   students observe the speed difference directly.
2. "Imitating the majority always makes change slower" — majority/conformist bias can actually
   accelerate change once a trait crosses a threshold frequency, while making it harder for a rare
   trait to establish — a genuinely counterintuitive, frequency-dependent pattern worth surfacing
   explicitly (see the vignette sketch above).
3. "All imitation biases produce the same long-run outcome" — success, majority, minority, and
   experience biases can diverge, especially under different resource conditions or spatial
   mobility settings.
4. "Culture is separate from evolution" — this model is explicit evidence against treating culture
   as outside the domain of evolutionary/selective processes.

## Connections to Other Models

- **evolution-resource-use-harvest-efficiency** — same resource-competition base without any
  social-learning mechanism; the direct "what does adding imitation change" comparison.
- **evolution-competition-forest-resources** / **evolution-competition-resources-abstract** — same
  binary sustainable/greedy trait, biological inheritance only.
- **evolution-resource-use-social-behavior** — a different social mechanism (monitoring/punishment)
  layered on the same base trait; useful contrast between *cultural transmission* and *direct
  sanctioning* as two distinct routes to norm stabilization.

## References

- Hanisch, S. (2022). Evolution of resource use through behavior imitation. OpenEvo NetLogo
  Models. https://openevo.eva.mpg.de/teachingbase/netlogo/
- Existing linked lesson plan: Cultural evolution vs. gene-focused evolution (OpenEvo TeachingBase,
  linked above) — real, already-built teaching material for this exact model, predating this
  strand.
- Boyd, R., & Richerson, P. J. (1985). *Culture and the Evolutionary Process*. University of
  Chicago Press. (foundational dual-inheritance-theory source; not yet a LiteratureBase `lit:`
  record as far as this pass checked)
- Henrich, J., & Boyd, R. (1998). The evolution of conformist transmission and the emergence of
  between-group differences. *Evolution and Human Behavior*, 19(4), 215-241. (foundational
  conformist-bias source relevant to the vignette sketch above; not yet a LiteratureBase `lit:`
  record as far as this pass checked)

## Schema-Ready Contribution

**Not done.** A formal LPM contribution to ConceptBase, validated against its real `lpm.schema.yaml`, is the
natural next step for this strand, not claimed here.

---

**Status:** In progress — grade-band/content-anchor/international-grounding/competency drafted
2026-08-29; assessment item bank and schema contribution (steps 4-5) still pending.
