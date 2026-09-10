# LPM Strand: Evolution and Competition for Forest Resources

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment
> (including a new International Curriculum Grounding section, US NGSS + Sachsen Gymnasium
> Biologie), competency alignment, and assessment status are drafted below (2026-08-29). Step 5
> (a formal, schema-validated ConceptBase LPM contribution) is not done.

## Model
- [Run the model](../models/evolution-competition-forest-resources/app.html)
- [Model metadata](../models/evolution-competition-forest-resources/metadata.json)
- [Download .nlogo](../models/evolution-competition-forest-resources/model.nlogo)

## Overview

Foresters harvest a shared, regrowing resource (trees, logistic growth) at one of two rates:
modest (`Percent-cut-modest`) or greedy (`Percent-cut-greedy`). Foresters that accumulate more
wealth reproduce more; offspring inherit their parent's harvest type, with a chance of mutation.
The model's own documentation names the resource explicitly as a **common-pool resource**
(accessible to all, depletable by use) — this is a natural-selection model built directly on top
of a commons-governance scenario, not a separate topic bolted on. Because greedy foresters
out-harvest (and so, other things equal, out-earn and out-reproduce) modest ones in the short run,
the model lets a class watch — parameter by parameter — how a population can evolve toward
resource overuse even without any forester "deciding" to overexploit the forest.

## Grade-Band Progression

### Grades 6-8: Selection Pressure on Resource-Use Strategies

**Learning Objectives:**
- Observe that foresters vary in how much of a tree they harvest, and that this variation is
  heritable (offspring usually match the parent's type).
- Recognize that harvest rate affects both individual wealth and the shared forest stock.
- Notice the pattern: with `Reproduction?` on and `Mutation-rate` at 0%, whichever type starts
  more common tends to become more common still — and connect this to differential reproduction,
  not to foresters "wanting" more trees.

**Key Concepts:** Trait variation (modest/greedy), differential reproduction, common-pool
resource, forest stock as a shared, depletable resource.

**Activities:**
1. Run the model with `Number-Modest` set to different starting fractions and observe whether the
   final trait frequency depends on the starting frequency.
2. Watch the "Forest stock (% of maximum)" plot alongside "Trait Frequencies (%)" and describe, in
   words, the relationship between the two.
3. Discuss: does any individual forester decide to overharvest the forest, or does forest decline
   emerge from many individual harvest choices plus differential reproduction?

**Assessment Indicators:** Describes harvest type as a heritable trait; connects trait-frequency
change to differential reproduction, not intention; distinguishes individual harvest choice from
population-level forest decline.

### Grades 9-12: Evolutionary Dynamics of a Commons Dilemma

**Learning Objectives:**
- Explain why greedy harvesting can be individually advantageous (more wealth, more offspring) even
  as it collectively depletes the shared resource — i.e. why natural selection does not
  automatically select for sustainable outcomes.
- Analyze how `Growth-rate`, `Max-Treeheight`, `Living-costs`, and `Mutation-rate` each shift the
  balance between forest stock and forester population.
- Connect the model's mechanism explicitly to real common-pool-resource problems (e.g.
  overfishing, deforestation) and to Ostrom's work on commons governance, while being precise
  about what the model does and doesn't simulate (it has no institutions, monitoring, or
  communication between foresters — compare to `evolution-resource-use-social-behavior`, which
  adds exactly that).

**Key Concepts:** Common-pool resources; carrying capacity; logistic growth; natural selection
under resource competition; trade-offs between individual fitness and collective sustainability.

**Activities:**
1. Systematically vary `Percent-cut-greedy` while holding other parameters fixed and record the
   long-run forest stock and total forester population — build a causal map of the relationship.
2. Set `Mutation-rate` above 0 and observe whether a stable sustainable population can persist
   against continual reintroduction of greedy mutants, or whether it eventually collapses.
3. Compare this model's outcome space to `evolution-resource-use-social-behavior` (same
   modest/greedy trait, but with an added punishment mechanism) and discuss what's missing here
   that changes the outcome there.

**Assessment Indicators:** Explains the individual-fitness-vs-collective-outcome tension without
resorting to "foresters are greedy people" moralizing; connects specific sliders to specific
outcome changes; identifies what mechanism (monitoring/punishment/institutions) this model lacks
relative to the social-behavior model.

## Content Anchor Alignment

**Primary:**
1. **Governing the Commons** — the model's own documentation names the resource a common-pool
   resource explicitly; this is this strand's strongest, least-forced anchor.
2. **Computer Models** — manipulating harvest-rate and regrowth parameters directly, rather than
   being told the tragedy-of-the-commons outcome.

**Secondary:**
3. **Global Sustainability Goals** — direct real-world parallel to forestry/fisheries management
   (SDG 15 Life on Land).

## Thinking Tool Integration

1. **Causal Mapping** — map the loop: harvest rate → individual wealth → reproduction → trait
   frequency → aggregate harvest pressure → forest stock → (feedback) available resource per
   forester. Look for the delay between a trait-frequency shift and its effect on forest stock.
2. **Structure of Knowledge Diagrams** — facts (a modest forester earns less than a greedy one
   this round) → concepts (differential fitness, carrying capacity) → principle (natural selection
   does not optimize for collective sustainability by default).
3. **Analogies & Analogy Mapping** — map modest/greedy foresters ↔ low-intensity/high-intensity
   fishing fleets or logging operations; name where the analogy breaks (real foresters can
   communicate, form institutions, and change strategy within a lifetime — this model's foresters
   cannot).

## International Curriculum Grounding

Real, citation-grounded — distinct from the OpenEvo/ConceptBase competency alignment below.

**US — NGSS.**
- **HS-LS2-1** (LS2.A, Interdependent Relationships in Ecosystems) — "mathematical and/or
  computational representations to support explanations of factors that affect carrying capacity
  of ecosystems at different scales." Direct match: `Growth-rate` and `Max-Treeheight` are the
  model's explicit carrying-capacity parameters.
- **MS-LS2-1** (LS2.A) — "analyze and interpret data...for the effects of resource availability on
  organisms and populations of organisms." Direct match: the Forest Stock and Forester Population
  plots.
- **HS-LS4-2** (LS4.B, Natural Selection) — the four-factor account of evolution (population
  growth potential, heritable variation, competition for limited resources, differential
  survival/reproduction) maps onto this model's mechanism precisely.
- **HS-LS4-6** (LS4.D, Biodiversity and Humans) — "create or revise a simulation to test a
  solution to mitigate adverse effects of human activity on biodiversity" — this model is directly
  usable as such a simulation for a forestry-sustainability unit, not only an evolution unit.

**Germany — Sachsen Gymnasium Biologie** (from `EvoMentor/importers/fwu_sn_fine_grained_candidates.json`;
coverage status `fine-grained-content-staged-untagged` — **grade band unspecified in the current
staged data**):

- *"Zusammenwirken von Mutation, Rekombination, Selektion und Isolation als ausgewählte Faktoren
  der Synthetischen Evolutionstheorie"* — `https://lp-sachsen.org/resource/lernziel-lerninhalt-7649-1`
  (also `-7649-2`) — mutation and selection are the model's two evolutionary mechanisms.
- *"Kennen von Prinzipien der Evolution von Organismen"* —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-7646-1` (also `-7646-2`).
- Supplementary real entries from the same Gymnasium Biologie document (found via a broader term
  search this pass, not the "evolution" label filter): *"intraspezifische Beziehungen –
  Konkurrenz"* (intraspecific relationships — competition) —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-120087-1`; *"Konkurrenz"* —
  `-7561-1`/`-7561-2`, `-7566-1`/`-7566-2` — direct match for the modest-vs-greedy competition
  mechanic itself. *"Anwenden der Kenntnisse über die Selbstregulation in Ökosystemen auf
  einwandernde Tier- und Pflanzenarten"* (applying knowledge of ecosystem self-regulation) —
  `-8011-1`/`-8011-2` — matches the model's logistic regrowth/self-regulation dynamic.
  *"Ökosystemmanagement"* (ecosystem management) — `-120096-1`, `-125117-1` — direct match for the
  forestry-sustainability framing of the whole model.

**Gap flagged**: no ConceptBase concept (main or the pending `extend-bio-core-evolution-mechanisms`
branch) directly names "common-pool resource" or "commons governance" as a biology/evolution
concept — that framing currently lives only in `OE-CONCEPT-oe-interdisciplinary-institutions`
(a general institutions concept, not commons-specific) and in the model's own documentation.

## Competency Alignment

Verified against the real ConceptBase registry (`d:/dev/openevo-ccs-lab/conceptbase/registry/concept/`,
2026-08-29):

- **OE-CONCEPT-bio-core-natural-selection (Natural Selection, BIO-CORE-v1.0.0)** — differential
  reproduction of modest vs. greedy foresters; performance indicator: explain trait-frequency
  change as a result of differential wealth accumulation, not forester intention.
- **OE-CONCEPT-bio-core-fitness (Fitness, BIO-CORE-v1.0.0)** — wealth as the model's proxy for
  reproductive fitness; performance indicator: connect harvest rate to fitness to trait frequency
  as a causal chain.
- **OE-CONCEPT-bio-core-mutation (Mutation, BIO-CORE-v1.0.0)** — `Mutation-rate` as the source of
  new trait variants; performance indicator: predict whether a sustainable-only population can
  resist reintroduction of greedy mutants.
- **OE-CONCEPT-oe-interdisciplinary-institutions (Institutions, OE-INTERDISCIPLINARY-v1.0.0)** —
  used carefully: this model has *no* institutions (no monitoring, no rules, no communication) —
  performance indicator: articulate what an institution would need to add to this model to change
  its outcome (a bridge to `evolution-resource-use-social-behavior`).
- **OE-CONCEPT-oe-interdisciplinary-selection (Selection, OE-INTERDISCIPLINARY-v1.0.0)**.

**Not yet in ConceptBase**: a commons-specific evolutionary/institutional concept (see gap note
above).

## Assessment

**No assessment file exists yet** for this model (`assessments/evolution-competition-forest-resources.json`
is not present). Needs building, following the `integrated-causal-reasoning-assessment` pattern.

**Vignette sketch, grounded in the actual model** (a starting point for that future item bank, not
a built assessment): "You set `Number-Modest` to 40 out of 50 foresters (80% modest), `Growth-rate`
to 0.2, and `Mutation-rate` to 0%, then ran the model. By tick 300, greedy foresters made up 95% of
the population and forest stock had fallen from 100% to 12% of maximum. A classmate says 'the
foresters decided to become greedy because the forest was running out.' What's wrong with that
explanation, and what actually happened, tick by tick?" — designed to target the same
teleological/individual-vs-population misconceptions as `bug-evolution`'s existing item bank, but
anchored in this model's commons-specific mechanism.

## Common Misconceptions

1. "Foresters decide to become greedy" — teleological/intentional-agent framing of a
   population-level, differential-reproduction process.
2. "Natural selection favors sustainability" — natural selection favors whatever increases
   relative reproduction *right now*, which is frequently the opposite of long-run sustainability
   in a commons without added institutions.
3. "The forest declining and foresters becoming greedy are two separate facts" — missing the
   causal loop between them.
4. "Mutation rate doesn't matter once a population is established" — ignores the ongoing
   reintroduction of greedy variants even after a sustainable equilibrium is reached.

## Connections to Other Models

- **evolution-competition-resources-abstract** — the same modest/greedy competition mechanic,
  generalized away from the forestry framing; use as a direct comparison of "does the concrete
  forestry story change how students reason about the abstract mechanism."
- **evolution-resource-use-harvest-efficiency** — replaces the binary modest/greedy trait with a
  continuous harvest-rate trait and adds diminishing-returns harvesting costs; a natural
  extension once this model's binary version is understood.
- **evolution-resource-use-social-behavior** — adds monitoring and punishment to essentially the
  same commons dilemma; the strongest direct A/B comparison in this set for "what changes the
  evolutionary outcome of a commons dilemma."
- **two-communities** (out of scope for this pass, but already an "in progress" strand) — commons
  framing without the evolutionary/reproduction mechanism; useful cross-model comparison of
  cooperation-without-evolution vs. cooperation-through-evolution.

## References

- Hanisch, S. (2022). Evolution and forest resource use. OpenEvo NetLogo Models.
  https://openevo.eva.mpg.de/teachingbase/netlogo/
- Ostrom, E. (1990). *Governing the Commons: The Evolution of Institutions for Collective Action*.
  Cambridge University Press. (real, DOI/ISBN-verifiable classic; not yet a LiteratureBase `lit:`
  record as far as this pass checked — flagged, not claimed as cited-and-linked)

## Schema-Ready Contribution

**Not done.** A formal LPM contribution to ConceptBase, validated against its real `lpm.schema.yaml`, is the
natural next step for this strand, not claimed here.

---

**Status:** In progress — grade-band/content-anchor/international-grounding/competency drafted
2026-08-29; assessment item bank and schema contribution (steps 4-5) still pending.
