# LPM Strand: Population Size and Living Costs

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment,
> competency alignment, international curriculum grounding, and a new assessment item bank are
> drafted below (2026-08-29, this pass builds the strand out from its prior stub in full). Step 5
> (a formal, schema-validated LPM contribution to ConceptBase, validated against its real `lpm.schema.yaml`)
> is not done — flagged as the natural next step, not claimed as complete. See
> [lpm-strands/README.md](README.md) for the full 5-step process this strand follows.
>
> **Companion to [two-foresters.md](two-foresters.md) and [two-communities.md](two-communities.md)**:
> this is the third case in the same commons-dilemma trilogy, isolating a third distinct causal
> lever — population size/density under a single, uniform, unchanging behavior rule — rather than
> individual authorship (Two Foresters) or population composition of fixed types (Two
> Communities). Written 2026-08-29 alongside a real International Curriculum Grounding pass on all
> three strands.

## Model
- [Run the model](../models/population-size-living-costs/app.html)
- [Model metadata](../models/population-size-living-costs/metadata.json)
- [Download .nlogo](../models/population-size-living-costs/model.nlogo)

## Overview

This strand explores the same underlying commons dilemma as [Two Foresters](two-foresters.md) and
[Two Communities](two-communities.md) — the tension between individual and collective interest in
harvesting a shared, regrowing resource — but isolates a third, distinct causal lever entirely.
Checked directly against the model's real mechanics (`models/population-size-living-costs/model-
card.json`): every forester in this model follows the *exact same* rule (move to the neighboring
patch with the tallest tree, harvest a fixed global percentage of it, pay a fixed global living
cost each round). There is no individual harvest-rate choice (unlike Two Foresters) and no
population split into two behavior types (unlike Two Communities). What the student actually
controls is **how many identical agents share one 375-patch forest** (`number-foresters`), plus
the forest's regrowth capacity (`growth-rate-trees`) and the per-round cost of living
(`living-cost`) that determines how quickly an underperforming forester goes bankrupt.

The model also has a mechanism neither sibling model has: **population size is not fixed after
setup**. Per the model's own documentation (`info_sections["Outputs / Result representation"]`),
"forester population... changes during a simulation only through the death of foresters" — death
results from the `death` procedure, triggered when a forester's accumulated wealth (harvest income
minus living costs) runs out. This makes Population Size and Living Costs a genuine
**density-dependent, self-regulating system**: population size affects the forest's fate, and the
forest's fate feeds back to affect population size, with no experimenter, designer, or agent
directly controlling either side of that loop after the simulation starts.

## Theoretical Rationale: Restructuration Theory

Parallel to, and a third distinct instance of, [bug-evolution.md](bug-evolution.md)'s,
[two-foresters.md](two-foresters.md)'s, and [two-communities.md](two-communities.md)'s
restructuration-theory rationale — a stated reason *why* this specific model should be expected to
support **integrated** (not dichotomized) causal reasoning about population-density effects on a
shared resource, not just an assumption that "using a computer model helps."

Wilensky & Papert (2010)'s restructuration theory (`theory:restructuration-theory`, TheoryBase)
argues a representational infrastructure change can restructure what is learnable in a domain, not
merely make existing content easier to teach. Manipulating `number-foresters` directly — while
every forester's own behavior rule stays fixed and identical — and watching the forest-stock and
forester-population plots diverge from a stable equilibrium into collapse and a subsequent,
*unscripted* population decline, is hypothesized to revise a learner's **hyperprior**-level belief
about causal structure for population-resource outcomes specifically: from dispositional/
individual-blame ("the new foresters must be greedier," the exact framing this strand's own
assessment item `PSLC-001` targets) toward density-dependent/emergent (a shared resource's fate,
and a population's own size, as the aggregate, feedback-driven consequence of *how many* identical
agents share a fixed-capacity resource). This is, again, the cooperation/commons-domain analogue of
the "centralized mindset" Resnick (1996) names for ecological cases — applied here to a case where
population size itself, not just the resource, is the emergent variable, which is a genuinely
different (and arguably still less intuitive) instance than either sibling model isolates.

This is a candidate mechanism, not a proven fact, and — following the same discipline
`two-communities.md` applies to its own claim — a **parallel, not identical**, claim to
`learningdependency:abm-decentralized-reasoning-precedes-icr-cooperation-social-dilemma`
(TheoryBase), whose worked example is Two Foresters specifically. No dedicated
Population-Size-and-Living-Costs-specific `learningdependency` record exists in TheoryBase, and
none is created as part of this pass — flagged as a finding for a future TheoryBase contribution,
consistent with `two-communities.md`'s own discipline on this point, not built here.

Grounded further in `cross-domain-construct:decentralized-causal-reasoning-domain-generality`
(TheoryBase): this strand is a third concrete attempt to develop that record's named-but-undeveloped
"social (unexplored)" domain instantiation, alongside Two Foresters (individual-authorship-driven)
and Two Communities (composition-driven) — this strand's own contribution is density/scale-driven.
None of the three strands changes that record's formal `domains[]` status, which remains out of
scope for this pass.

## Grade-Band Progression

*(`metadata.json` targets 6-8, 9-12, and Teacher education for this model — a different band set
than either Two Foresters (3-5/6-8/9-12) or Two Communities (6-8/9-12/Undergraduate).)*

### Grades 6-8: Introduction to Population Size and Resource Limits

**Learning Objectives:**
- Observe that increasing the number of foresters changes the forest's outcome, even when every
  forester's harvest rate and living cost stay exactly the same.
- Recognize "the new foresters must be greedier" as one possible explanation for a forest's decline,
  and test whether it holds up against what the model actually varies (nothing about behavior — only
  how many identical agents there are).
- Notice that the forester-population count itself can fall during a run, and connect that to
  foresters running out of savings — not to the student directly changing the population slider
  mid-run.
- Compare a small, clearly sustainable population to a large, clearly unsustainable one at the same
  harvest-rate and living-cost settings.

**Key Concepts:** Common-pool resource; population size/density; carrying capacity (informally);
sustainable vs. unsustainable resource use; feedback (informally, "the forest affects the people who
depend on it, and that comes back around").

**Activities:**
1. Run the model with a small `number-foresters` value (e.g. 10-20) and record the forest-stock and
   average-wealth trends.
2. Increase only `number-foresters` (leaving `harvest-rate`, `living-cost`, and `growth-rate-trees`
   untouched) toward the slider's upper range and compare outcomes.
3. Watch the "forester population" plot during a run that starts healthy and then declines — discuss
   what's causing individual foresters to disappear from the world.
4. Discuss: is the forest declining because people are being greedier, or because there are more of
   them sharing the same limited forest?

**Assessment Indicators:** Can describe how forest and population outcomes differ as population size
changes, with every forester's own rule held constant; distinguishes "more people, same rule" from "a
change in how people behave"; recognizes that a forester's disappearance from the world reflects the
model's own bankruptcy/death mechanism, not a slider the student is directly moving mid-run.

### Grades 9-12: Mechanisms — Density-Dependence, Carrying Capacity, and Feedback

**Learning Objectives:**
- Explain the model's core feedback loop: population size → per-capita harvest share → forest
  depletion → reduced future harvest income → living costs exceeding income → forester death →
  reduced population size — and identify that this loop has no designed controller.
- Analyze the logistic tree-regrowth function (`new height = current height + (growth rate * height)
  * (1 - (height / maximum tree height))`, the model's own documented formula) and explain why it
  makes regrowth capacity nonlinear rather than a simple fixed total.
- Use the model's monitors (forest stock %, average wealth, forester population) to identify an
  approximate population threshold, for a given `growth-rate-trees` and `harvest-rate`, above which
  the forest and population both decline rather than stabilize.
- Connect the model's self-regulating population dynamic to Malthusian population theory and to
  real-world carrying-capacity cases (fisheries, groundwater basins, grazing commons).
- Distinguish this model's causal lever (uniform behavior, varying population size) explicitly from
  Two Foresters' (individually authored rate) and Two Communities' (fixed-type composition).

**Key Concepts:** Density-dependence; carrying capacity; logistic growth; common-pool resources
(Ostrom 1990); feedback loops and self-regulation; Malthusian population dynamics; per-capita vs.
aggregate resource share.

**Activities:**
1. Hold `harvest-rate`, `living-cost`, and `growth-rate-trees` fixed; vary `number-foresters`
   systematically (e.g. 10, 50, 100, 200, 350) and graph forest-stock and forester-population
   outcomes against population size.
2. Use causal mapping to diagram the full population ↔ forest feedback loop explicitly, including the
   `death` mechanism — with no arrow from a "population controller" node, since the base model has
   none.
3. Compare this model directly against Two Foresters and Two Communities: what does each model hold
   fixed, and what does each model let the student vary, to isolate a different causal lever behind
   the same underlying dilemma?
4. Discuss real-world common-pool resources where population size/number of users, not individual
   greed, is the dominant pressure (ocean fisheries, shared aquifers, public grazing land).

**Assessment Indicators:** Explains the population-forest feedback loop in causal terms; distinguishes
density-dependent effects from individual-behavior-change explanations; reasons about the logistic
regrowth function's nonlinearity rather than assuming proportional effects; can compare this model's
isolated causal lever against Two Foresters' and Two Communities'.

### Teacher Education: Modeling Population-Resource Dynamics for Instruction

**Learning Objectives:**
- Evaluate this model as a case of decentralized, density-dependent, self-regulating dynamics with no
  designed feedback controller, and consider how to sequence it relative to Two Foresters and Two
  Communities in a unit on commons dilemmas.
- Design a systematic BehaviorSpace sweep across `number-foresters` (and, secondarily,
  `growth-rate-trees` or `harvest-rate`) to characterize the collapse/persistence population
  threshold quantitatively — none currently exists for this model, flagged as a gap for
  `netlogo-modeler`, not built here.
- Critically evaluate what the model does and does not represent: no forester ever changes their own
  harvest-rate or living-cost in response to scarcity (both are fixed global parameters for the
  entire population), no migration, and no forester agency beyond the fixed move-to-tallest-tree
  rule — a real limitation worth naming explicitly to students, not routed around.
- Connect to `theory:computational-models-as-theory-mediators` (TheoryBase): this model as a
  protected theoretical mediator isolating one causal variable (population size) cleanly, not a
  fitted-to-data forecast of any real forestry cooperative.

**Key Concepts:** Density-dependent regulation; BehaviorSpace experiment design; model assumptions
and limitations; sequencing a multi-model unit around a shared underlying dilemma with different
isolated causal levers.

**Activities:**
1. Design (and, once built, run) a BehaviorSpace experiment sweeping `number-foresters` against
   `growth-rate-trees` to map the collapse/persistence boundary.
2. Write a short unit-sequencing plan for teaching Two Foresters, Two Communities, and Population
   Size and Living Costs together, explicit about which causal lever each model isolates and in what
   order that scaffolds understanding most effectively.
3. Critically evaluate the model's fixed-behavior assumption (no forester adapts to scarcity) against
   real commons-governance literature (Ostrom 1990; Basurto & Ostrom 2009) and discuss what a richer
   model would need to add.

## International Curriculum Grounding

Real US and German curriculum data, distinct from the OpenEvo/ConceptBase competency alignment
below (which stays the internal alignment layer). Also closes a real gap this session found: this
model's own concept tags (`Common Pool Resource`, `Sustainable resource use` in `metadata.json`)
were already linked in the graph explorer's `assets/literature-links.json` to real LiteratureBase
records with no supporting text anywhere; citing them here connects the graph to actual strand
content. One tag, `Population dynamics`, has **no** LiteratureBase link at all yet in
`assets/literature-links.json` — a real, additional gap this strand surfaces, distinct from the
`Common Pool Resource`/`Sustainable resource use`/`Complex systems` gaps already flagged by
`two-foresters.md` and `two-communities.md`.

**US — NGSS (Next Generation Science Standards).** Real DCI/performance-expectation codes, picked
for what this specific model's interface lets a student manipulate and observe — this model is the
strongest NGSS match of the three commons-dilemma models, since population size is literally its
manipulated variable, not an incidental feature:

- **MS-ESS3-4** — "Construct an argument supported by evidence for how increases in human
  population and per-capita consumption of natural resources impact Earth's systems." As direct a
  match as a standard can be: `number-foresters` (population) and `harvest-rate`/`living-cost`
  (per-capita consumption pressure) are exactly this standard's two named variables, and the
  forest-stock/population plots are the evidence a student's argument would cite.
- **MS-ESS3-3** — "Apply scientific principles to design a method for monitoring and minimizing a
  human impact on the environment." Fits the Grades 6-8 band's activity of identifying a
  sustainable-vs-unsustainable population range.
- **HS-ESS3-3** — "Create a computational simulation to illustrate the relationships among
  management of natural resources, the sustainability of human populations, and biodiversity."
  Direct match, and notably the only one of the three commons-dilemma models whose core manipulated
  variable is literally "the sustainability of human populations" as the standard names it, not
  only "management of natural resources."
- **AP Environmental Science** — the College Board's course framework is well known to include a
  named "Tragedy of the Commons" topic within its resource-management content, and this model's
  Malthusian population-vs-resource dynamic is closely related territory (population growth models
  are also a well-known APES topic). This session could not confirm exact current unit/topic
  numbers against a primary CED source for either, so both are named here, not cited by code.
- **C3 Framework (Social Studies)** — checked directly: C3 is registered in `openevo-graph`'s
  standards crosswalk index but has zero loaded standards content (`standardsLoaded: false`), so no
  specific Dimension 2 (Economics) indicator code is cited. Its scarcity/resource-allocation inquiry
  structure is a real conceptual fit — noted by name only.

**Germany — Sachsen Gymnasium Gemeinschaftskunde/Rechtserziehung/Wirtschaft (G/R/W).** From a real
pilot in the sibling `deutsche_lp` repo
(`docs/2026-08-25-sachsen-grw-latent-connections-pilot.md`, 2026-08-25) — **candidate
latent-connection readings of real Lehrplan content, `status: candidate`, not official curriculum
equivalences.** The Lehrplan text quoted below is real and independently primary-sourced by that
pilot; the pedagogical argument connecting it to this model is a proposed reading layered on top,
not asserted as settled:

- **Strongest fit for this model — the subject's own foundational "didaktische Grundsätze"** (p.2,
  whole-subject framing): *"Macht, Herrschaft, Ideologie, Interesse, Konflikt, Konsens, Recht,
  Frieden, Staat, Institutionen, Verhandlung, Regelung sowie Bedürfnis, Knappheit, Nutzen oder
  Wettbewerb sind zentrale politische Kategorien."* **Knappheit (scarcity) is the single word in
  this list that most literally names this model's mechanism**: a fixed-capacity forest, a growing
  number of identical claimants on it, and a population that self-regulates through economic
  hardship (living costs exceeding harvest income) when scarcity binds. The pilot's own argument
  (self-scored "moderate" overall, "close to the literal core of the Governing the Commons anchor")
  is that human reliance on institutions for large-scale non-kin cooperation explains why a
  functioning society needs this vocabulary at all — this model is a clean minimal case of the
  underlying scarcity dynamic that vocabulary was built to manage, with the caveat (already in the
  Grade 6-8 band above) that the base model has no institution at all, only a shared, unregulated
  resource.
- **Weaker fit — Klassenstufe 10, Lernbereich 1, "Wirtschaft und Wirtschaftsordnung in der
  Bundesrepublik Deutschland"** (25 Ustd., p.14): *"Die Schüler erwerben Wissen über...
  idealtypische Vorstellungen des Wirtschaftens... die Bedeutung und Interdependenz zentraler
  ökonomischer Akteure vor dem Hintergrund ihrer Entscheidungsoptionen erfassen."* Scored "strong"
  by the pilot for Two Foresters' individual-decision framing; this model fits it more weakly still
  than Two Communities does, since **no forester in this model has an "Entscheidungsoption" at
  all** — harvest rate and living cost are both fixed, identical, global parameters. Useful mainly
  as a contrast case: this model isolates what happens when the idealtypische rational-actor
  question ("how should each actor decide?") is held fixed and only scale is allowed to vary.
- **Not confirmed**: no specific Klassenstufe/grade-band figure beyond what's quoted above should be
  treated as settled; the pilot itself flags the "didaktische Grundsätze" candidate as needing
  narrowing to a specific Lernbereich, not yet done.

**LiteratureBase.** Real, DOI-verified commons-dilemma records were added to LiteratureBase this
session and already linked to this model's `metadata.json` concept tags in the graph explorer's
`assets/literature-links.json` (`Common Pool Resource`, `Sustainable resource use`) — cited here to
close that loop:

- Ostrom, E. (1990). *Governing the Commons*. Cambridge University Press.
  (`OE-LITERATURE-ostrom-1990`) — the foundational commons-governance citation; this model's shared,
  unbounded, ungoverned forest is close to the pre-institutional baseline Ostrom's design principles
  (boundary rules, monitoring, sanctions — none of which this model implements) are meant to fix.
- Hardin, G. (1968). The Tragedy of the Commons. *Science*, 162(3859), 1243-1248.
  (`OE-LITERATURE-hardin-1968`) — arguably the single most literal model-to-paper match of the three
  commons-dilemma models: a population of self-interested resource users sharing one unregulated
  commons, with population growth itself (not just individual greed) driving depletion, is close to
  Hardin's own original argument. Cited with the same caveat its LiteratureBase record carries:
  widely critiqued since, including directly by Ostrom (see below), not an endorsement of Hardin's
  privatization/regulation prescription as the only fix.
- Basurto, X., & Ostrom, E. (2009). Beyond the tragedy of the Commons. *Economics and Policy of
  Energy and the Environment*, (1), 35-60. (`OE-LITERATURE-basurto-ostrom-2009`) — direct critique
  of Hardin, relevant to the Teacher-education band's activity evaluating the base model's
  fixed-behavior assumption against real self-governance evidence.
- Powers, R. B. (1986). The Commons Game: Teaching Students about Social Dilemmas. *The Journal of
  Environmental Education*, 17(2), 4-10. (`OE-LITERATURE-powers-1986`) — a published, evaluated
  classroom commons-dilemma simulation; the most direct precedent for *teaching* this model's
  dilemma, not just theorizing it.
- Wilson, D. S., Ostrom, E., & Cox, M. E. (2013). Generalizing the core design principles for the
  efficacy of groups. *Journal of Economic Behavior & Organization*, 90, S21-S32.
  (`OE-LITERATURE-wilson-ostrom-cox-2013`) — a weaker fit for this specific model than for Two
  Communities (no group-selection-relevant type/composition structure here), noted for completeness
  rather than as a primary citation.

## Content Anchor Alignment

**Primary:**
1. **Governing the Commons** — a common-pool resource with no institution, boundary, or governance
   mechanism at all — the closest of the three commons-dilemma models to Hardin's (1968) original,
   pre-institutional framing; individual vs. collective-interest tension driven by scale rather than
   individual choice or composition.
2. **Global Sustainability Goals** — population size vs. resource sustainability is this model's
   literal subject matter; direct transfer to real population-growth-and-resource-use questions
   (fisheries, water, land use).
3. **Computer Models** — the model itself, and the restructuration-theory claim above that
   manipulating population size directly (holding every agent's own behavior fixed) and observing
   the emergent, self-regulating population-resource dynamic is a distinct pedagogical act from being
   told "too many people deplete a resource" as a fact.

**Secondary:**
4. **Cooperation Games** — a weaker fit than for Two Foresters/Two Communities, worth stating
   explicitly rather than forcing: there is no heterogeneous strategy choice here (every forester
   behaves identically), so this is a uniform-strategy, n-player commons dilemma — still
   structurally a social dilemma (individual harvest benefits the individual; collective harvest
   depletes the shared resource), just without the strategic variation the other two models let
   students manipulate directly.
5. **Our Mind** — dispositional/individual-blame reasoning about population-driven decline (this
   strand's own assessment item `PSLC-001`); difficulty intuiting nonlinear (logistic), rather than
   linear, resource dynamics.

## Thinking Tool Integration

1. **Causal Mapping** — the strongest-fit tool for this model: diagram the full population ↔ forest
   feedback loop (population size → per-capita harvest share → forest depletion → reduced harvest
   income → living costs exceeding income → forester death → reduced population size), with no arrow
   from a "population controller" node, since the base model has none.
2. **The Noticing Tool** — before running the model at a high population, notice your own prediction
   for what will happen; after running it, notice whether the *population* plot's own decline
   surprised you as much as the forest plot's did.
3. **Analogies & Analogy Mapping** — map this model's population-size lever directly against Two
   Foresters' individual-choice lever and Two Communities' composition lever; also map to real-world
   Malthusian population-resource cases (fisheries, groundwater, grazing commons) and name explicitly
   where the model's assumptions (fixed behavior, no migration, no adaptation) depart from those
   real cases.
4. **Structure of Knowledge Diagrams** — Population size → per-capita resource share → carrying
   capacity → density-dependent regulation → common-pool-resource governance (Ostrom).
5. **Tinbergen's Questions** — a genuinely mixed fit, worth stating honestly rather than forcing an
   answer for every quadrant: Function (why does harvesting benefit an individual forester in the
   short run?) and Mechanism (how does population size interact with the logistic regrowth function?)
   apply directly; Development and Evolution are weak fits for this specific model, since no forester
   learns, adapts, or evolves (per the model's own fixed-rule documentation) — a real limitation to
   name, not route around.

## Competency Alignment

Verified against the real ConceptBase registry (direct inspection of
`conceptbase/registry/concept/*.json`, 2026-08-29):

- **OE-CONCEPT-oe-interdisciplinary-cooperation (Cooperation, OE-INTERDISCIPLINARY-v1.0.0)** — used
  with a different emphasis than either sibling strand: the individual-vs-collective tension persists
  even though every forester follows an identical strategy; performance indicator: explain how a
  shared resource can decline purely from population scale, with no change in any individual's
  behavior.
- **OE-SANDBOX-CONCEPT-000008 (Decentralized Causal Reasoning, OE-INTERDISCIPLINARY-v1.0.0)** —
  performance indicator: explains both the forest's decline *and* the forester population's own
  decline as emergent, feedback-driven outcomes of population size interacting with a fixed-capacity
  resource, with no designed controller regulating either.
- **OE-SANDBOX-CONCEPT-000009 (Agent-Based Modeling, OE-INTERDISCIPLINARY-v1.0.0)** — performance
  indicator: can describe the model as many identical-rule agents whose *number*, not their
  individual rule, produces an emergent collective and population-level pattern. Note: this
  concept's own `examples[]` field currently names only Two Foresters as its cooperation-domain
  instantiation; this model is a real third instantiation and a natural candidate to add to that
  list in a future ConceptBase pass — flagged as a finding, not silently edited here (the same
  finding `two-communities.md` already surfaces for itself).
- **OE-CONCEPT-oe-interdisciplinary-agency (Agency, OE-INTERDISCIPLINARY-v1.0.0)** — a genuinely
  weaker fit here than for either sibling strand, worth stating rather than forcing: no forester in
  this model has any individually-set behavioral parameter at all (harvest-rate and living-cost are
  both fixed, global, and identical for the whole population), so this concept applies mainly to
  distinguishing the *experimenter's* structural control (population size) from any individual
  forester's (minimal, fixed) agency — an even sharper version of the distinction `two-communities.md`
  already draws for its own fixed-type farmers.
- **Institutions (`OE-CONCEPT-oe-interdisciplinary-institutions`) deliberately not claimed here**,
  unlike `two-communities.md`: this model has no boundary, fence, or institutional mechanism of any
  kind — a single, unbounded, shared forest — which is itself a real pedagogical point (the
  pre-institutional baseline Ostrom's design principles respond to), not a gap to paper over with an
  unearned competency claim.
- Confirmed ConceptBase gaps (direct search of `registry/concept/*.json` found no match): **Population
  dynamics** (a new gap this pass surfaces — `OE-CONCEPT-bio-core-population` exists but defines
  population only in its biological/genetic sense, "a group of interbreeding organisms," not the
  demographic/carrying-capacity sense this model needs), **Common Pool Resource** and **Sustainable
  resource use** (already flagged as gaps by `two-communities.md`'s and `two-foresters.md`'s own
  passes) — none claimed as covered above.

Restructuration (`OE-SANDBOX-CONCEPT-000007`) deliberately **not** added here, for the same reason
`two-foresters.md` and `two-communities.md` omit it: this strand's theoretical-rationale section
argues the *mechanism* is restructuration theory, but the concept a learner is meant to come away
understanding is density-dependent causal reasoning about a shared resource, not restructuration
theory itself as content.

## Assessment

**Assessment file:** [assessments/population-size-living-costs.json](../assessments/population-size-living-costs.json)
(`OE-ASSESS-POPULATIONSIZELIVINGCOSTS-001`) — newly built this pass (2026-08-29), grade band 6-8, a
5-item integrated-causal-reasoning assessment following the same EvoFlex-derived pattern
`assessments/two-foresters.json` and `assessments/two-communities.json` use. Its vignette ("The
Growing Forestry Cooperative") is grounded directly in the model's own documented mechanics — the
logistic tree-regrowth formula and the harvest/living-cost/death procedures from `model-
card.json` — describing what those mechanics predict for a population scaled from 20 to 150
foresters under an unchanged harvest-rate/living-cost rule. **Honesty note**: this vignette was not
verified against an actually-executed BehaviorSpace run this session — it is a mechanics-derived
prediction, not a confirmed model output. A live parameter sweep (the Teacher-education band's own
first activity) is the natural next step to verify it, flagged here rather than silently assumed.
Item `PSLC-004` directly parallels `two-communities.json`'s `TC-004` item, asking students to compare
all three commons-dilemma models' distinct causal levers.

## Common Misconceptions

(Drawn from this strand's own new assessment's scoring taxonomy, `assessments/population-size-
living-costs.json`)

1. "The forest is declining because the new foresters are greedier" — individual-blame/dispositional
   framing that ignores population size as the actual varied lever (`PSLC-001`).
2. "The forester population is a value the experimenter directly controls throughout the run" —
   misses that population size changes only via the model's own `death` procedure, a real emergent,
   feedback-driven mechanism (`PSLC-002`).
3. "Just tell foresters to harvest less" (or "population size is the only thing that matters") —
   single-lever isolation that ignores how harvest-rate, population size, and growth-rate-trees
   interact (`PSLC-003`).
4. "This model is the same as Two Foresters/Two Communities, just with more agents" — ignores that
   each model isolates a genuinely different causal lever (`PSLC-004`).
5. "Doubling population and doubling growth rate should cancel out" — assumes linear/proportional
   effects where the model's logistic regrowth function is nonlinear (`PSLC-005`).

## Connections to Other Models

- **two-foresters** — the individual-authorship-driven case in the same commons-dilemma trilogy;
  compare directly via this strand's own Analogies & Analogy Mapping activity and assessment item
  `PSLC-004`.
- **two-communities** — the composition-driven case in the same trilogy; same comparison.
- **evolution-competition-forest-resources** — adds evolutionary dynamics to resource competition,
  a natural next step after this model's population-density focus.
- **wolves-sheep-grass** — compare density-dependent, self-regulating population dynamics in an
  ecological (rather than social-dilemma) predator-prey framing.

## References

Real, DOI-verified sources (LiteratureBase `OE-LITERATURE-` ids where applicable):

- Wilensky, U., & Papert, S. (2010). Restructurations: Reformulations of knowledge disciplines
  through new representational forms. Proceedings of the Constructionism 2010 Conference.
  (`OE-LITERATURE-wilensky-papert-2010`)
- Resnick, M. (1996). Beyond the centralized mindset. Journal of the Learning Sciences, 5(1), 1-22.
  (`OE-LITERATURE-resnick-1996`)
- Ostrom, E. (1990). *Governing the Commons*. Cambridge University Press.
  (`OE-LITERATURE-ostrom-1990`)
- Hardin, G. (1968). The Tragedy of the Commons. *Science*, 162(3859), 1243-1248.
  (`OE-LITERATURE-hardin-1968`)
- Basurto, X., & Ostrom, E. (2009). Beyond the tragedy of the Commons. *Economics and Policy of
  Energy and the Environment*, (1), 35-60. (`OE-LITERATURE-basurto-ostrom-2009`)
- Powers, R. B. (1986). The Commons Game: Teaching Students about Social Dilemmas. *The Journal of
  Environmental Education*, 17(2), 4-10. (`OE-LITERATURE-powers-1986`)
- Wilson, D. S., Ostrom, E., & Cox, M. E. (2013). Generalizing the core design principles for the
  efficacy of groups. *Journal of Economic Behavior & Organization*, 90, S21-S32.
  (`OE-LITERATURE-wilson-ostrom-cox-2013`)
- Hanisch, S. (2022). Use of a community resource (forest). OpenEvo NetLogo Models.
  https://openevo.eva.mpg.de/teachingbase/netlogo — the model's own author/source, per
  `model-card.json`'s own citation.

## Schema-Ready Contribution

**Not done.** A formal LPM contribution to ConceptBase, validated against its real `lpm.schema.yaml` (step 5 of
the 5-step process) is the natural next step, not claimed here — consistent with `two-foresters.md`'s
and `two-communities.md`'s own discipline on this point.

---

**Status:** In progress — full strand built out 2026-08-29 from its prior stub, as the third case in
the [two-foresters.md](two-foresters.md) / [two-communities.md](two-communities.md) commons-dilemma
trilogy, alongside a real International Curriculum Grounding pass across all three.
