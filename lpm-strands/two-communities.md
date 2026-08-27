# LPM Strand: Two Communities

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment,
> competency alignment, and assessment are drafted below. Step 5 (a formal, schema-validated
> OECB LPM contribution against ConceptBase's real `lpm.schema.yaml`) is not done — flagged as
> the natural next step, not claimed as complete. See
> [lpm-strands/README.md](README.md) for the full 5-step process this strand follows.
>
> **Companion to [two-foresters.md](two-foresters.md)**: this is the group-scale pair to that
> strand's individual-scale case, cross-referenced there under "Connections to Other Models" as
> the private- vs. commons-resource framing contrast. Written 2026-08-27 ahead of a conference
> demo centered on Two Foresters, so a visitor who wants to go deeper has somewhere real to click.
>
> **Note on the existing assessment file**: [assessments/two-communities.json](../assessments/two-communities.json)
> (`OE-ASSESS-TWOCOMMUNITIES-001`, dated 2025-01-09) already existed as a real, schema-consistent
> 5-item assessment before this strand was written — the same pre-existing-draft pattern
> `bug-evolution.md` and `two-foresters.md` found for their own models. This strand verifies and
> incorporates it rather than duplicating the effort.

## Model
- [Run the model](../models/two-communities/app.html)
- [Model metadata](../models/two-communities/metadata.json)
- [Download .nlogo](../models/two-communities/model.nlogo)

## Overview

This strand explores the same social dilemma as [Two Foresters](two-foresters.md) — the tension
between individual and collective interest in harvesting a regrowing resource — but scaled up from
two individuals to two 25-farmer communities, and with a different causal lever entirely. In Two
Foresters, each of two agents directly sets their own harvest-rate parameter. In Two Communities, no
individual farmer's harvest behavior is set by the student at all: every farmer is one of two fixed
types ("sustainable" or "greedy"), and *both* types' harvest rates (`Harvest-rate-sustainables`,
`Harvest-rate-greedy`) are single global values shared identically by both communities. What the
student actually controls is **population composition** — how many of each community's 25 farmers
are which type (`Sustainables-Comm1`, `Sustainables-Comm2`) — and the **scale/boundary of the shared
resource** itself, via a `Community-forest?` switch that either fences the world into two separate
25-farmer common-pool resources or leaves all 50 farmers sharing one undivided forest. Students
investigate how a community's collective fate can differ dramatically from an otherwise-identical
community's, purely as a function of composition, while every individual farmer's own behavior rule
stays exactly the same.

## Theoretical Rationale: Restructuration Theory

Parallel to [bug-evolution.md](bug-evolution.md)'s and [two-foresters.md](two-foresters.md)'s
restructuration-theory rationale — a stated reason *why* this specific model should be expected to
support **integrated** (not dichotomized) causal reasoning about cooperation and common-pool-resource
outcomes, not just an assumption that "using a computer model helps."

Checked directly against this model's real mechanics (`models/two-communities/model-card.json` and
its `info_sections`), not assumed: each farmer's harvest behavior is **not** individually authored or
chosen — it is fixed by the farmer's type at `setup`, and the harvest rate for a given type
(`Harvest-rate-sustainables`, `Harvest-rate-greedy`) is a single global parameter applied identically
to every farmer of that type in *both* communities. The two communities can only differ from each
other in two ways: how many farmers of each type they were assigned (`Sustainables-Comm1`,
`Sustainables-Comm2`), and, via `Community-forest?`, whether their 25-farmer forest is a separately
bounded common-pool resource or part of one 50-farmer shared resource. Per the model's own "Learning
and Adaptation" and "Randomness" documentation (`info_sections.Concepts and Principles`): farmers do
not learn, do not adapt, do not communicate, and the order in which they move and harvest each tick is
random. This makes Two Communities a *sharper* instance of the decentralized-causal-structure case
than Two Foresters, not merely a scaled-up copy of it: where Two Foresters lets a student author an
individual agent's own rule and watch an aggregate outcome emerge, Two Communities removes individual
authorship from the picture almost entirely — no single farmer's decision, and no single farmer's
"badness" or "goodness," drives the community's fate. The only thing that does is a purely structural,
population-level parameter (composition) that no farmer in the model itself controls or is even aware
of.

Wilensky & Papert (2010)'s restructuration theory (`theory:restructuration-theory`, TheoryBase) argues
a representational infrastructure change can restructure what is learnable in a domain, not merely
make existing content easier to teach. Manipulating `Sustainables-Comm1`/`Sustainables-Comm2` directly
and watching two structurally identical communities diverge — one thriving, one collapsing — while
every individual farmer's own harvest rule is held constant, is hypothesized to revise a learner's
**hyperprior**-level belief about causal structure for group-level social-dilemma outcomes
specifically: from dispositional/individual-blame ("Blue Hill just has worse people," the exact
misconception this model's own assessment item `TC-001` targets) toward compositional/emergent
(a community's fate as an aggregate, frequency-dependent consequence of *how many* of each fixed type
happen to make it up). This is the cooperation-domain analogue of the "centralized mindset" Resnick
(1996) names for ecological/evolutionary cases, applied here to a case where there is not even an
individual decision to mistakenly centralize onto — only a population parameter, which arguably makes
the dispositional misattribution *more* tempting, not less, since a learner has to resist explaining a
group outcome by imagining individual choices that the model's own mechanics don't actually grant any
farmer.

This is a candidate mechanism, not a proven fact, and it is a **parallel, not identical**, claim to
`learningdependency:abm-decentralized-reasoning-precedes-icr-cooperation-social-dilemma` (TheoryBase,
`OE-LEARNINGDEPENDENCY-abm-decentralized-reasoning-precedes-icr-cooperation-social-dilemma`) — that
record's own worked example is Two Foresters specifically ("each forester's own harvest-rate
parameter, with no communication, negotiation, or joint-plan mechanism"), a case of individually
*authored* rules producing an emergent aggregate. This strand's claim is related but distinct: here
the aggregate emerges from *population composition* over fixed, non-authored individual rules, which
is a different (and arguably harder) instance of the same decentralized-causal-structure hyperprior
shift. Writing a dedicated Two-Communities-specific `learningdependency` record that states this
distinction formally, rather than silently reusing the Two Foresters record's `precedesConcept`, would
be the correct next TheoryBase contribution — flagged here as a finding, not built as part of this
pass (the same discipline this strand's own step-5 status note applies to a formal OECB contribution).

Grounded further in `cross-domain-construct:decentralized-causal-reasoning-domain-generality`
(TheoryBase, `OE-CROSSDOMAINCONSTRUCT-decentralized-causal-reasoning-domain-generality`), whose
`domains[]` field formally lists only `ecological-evolutionary` and `cognitive-self` — the "social
(unexplored, deliberately not listed in `domains[]`)" instantiation remains, per that record's own
2026-08-26 audit note, a named-but-undeveloped candidate direction, not an accepted domain. Two
Foresters was this ecosystem's first concrete attempt to develop it; this strand is a second, and
different, concrete attempt (composition-driven rather than individual-authorship-driven) — neither
strand changes that record's formal `domains[]` status, which stays out of scope for this pass.

## Grade-Band Progression

*(`metadata.json` targets 6-8, 9-12, and Undergraduate for this model — no 3-5 band, unlike Two
Foresters.)*

### Grades 6-8: Introduction to Group Composition and Common-Pool Resources

**Learning Objectives:**
- Observe that a community's forest outcome depends on how many of its farmers are "sustainable" vs.
  "greedy" — even when each type's harvesting behavior is exactly the same in every community.
- Distinguish what one farmer does from what the whole community's forest does.
- Recognize "that community just has worse people" as one possible explanation for a depleted commons,
  and test whether it holds up against what the model actually varies.
- Compare a single shared forest (`Community-forest?` off) to two separately bounded community
  forests (`Community-forest?` on).

**Key Concepts:** Common-pool resource; population composition; group-level vs. individual-level
outcome; institutions/boundaries (the fence); sustainable vs. unsustainable harvesting.

**Activities:**
1. Run with the model's defaults (Community 1: 23 sustainable / 2 greedy farmers; Community 2: 2
   sustainable / 23 greedy) and compare the two communities' Forest Stock plots.
2. Adjust `Sustainables-Comm1`/`Sustainables-Comm2` while leaving `Harvest-rate-sustainables` and
   `Harvest-rate-greedy` untouched — notice the harvesting *rule* itself never changes, only the mix
   of who's using which rule.
3. Toggle `Community-forest?` on and off and compare a single 50-farmer shared forest to two
   separately fenced 25-farmer forests.
4. Discuss: is a struggling community's forest depleted because its people are worse, or because of
   something about the group as a whole?

**Assessment Indicators:** Can describe how forest outcomes differ between two communities with
different compositions; distinguishes a farmer's own harvest-type rule from the community's aggregate
forest outcome; can explain, in their own words, why "the people are worse" is not the strongest
explanation when the harvesting rule for each type is identical across both communities.

### Grades 9-12: Mechanisms — Composition, Stability, and the Common-Pool Resource

**Learning Objectives:**
- Explain how the frequency (proportion) of a fixed behavior type in a population changes a shared
  resource's trajectory, holding the behavior itself constant.
- Analyze the `Community-forest?` switch as a change in the resource's scale/boundary — one shared
  common-pool resource for 50 farmers vs. two separate common-pool resources for 25 each — and
  connect to Ostrom's boundary-rules design principle.
- Evaluate whether a mostly-sustainable composition is *stable*, by comparing individual sustainable
  vs. greedy farmers' own accumulated wealth (not just the community average) within one run.
- Use the model's wealth monitors (Sustainables / Greedy / Community / Total average, per community)
  to compare individual-type outcomes to community-level outcomes.

**Key Concepts:** Common-pool resources (Ostrom 1990); frequency-dependence; collective-action
problem; boundary rules/institutions; individual payoff vs. group payoff; carrying capacity and
logistic regrowth (`k`, `r` — `Max-Tree-Height`, `Growth-Rate`).

**Activities:**
1. Hold `Harvest-rate-sustainables`/`Harvest-rate-greedy` fixed; vary `Sustainables-Comm1`/
   `Sustainables-Comm2` systematically (e.g. 0, 5, 12, 20, 25) and graph forest-stock outcome against
   composition.
2. Compare the Sustainables vs. Greedy wealth monitors within one run — do sustainable farmers ever
   out-earn greedy farmers *individually*, even in a community whose forest is healthier overall?
3. Toggle `Community-forest?` and discuss what a fence (an institution/boundary) changes about a
   collective-action problem, versus leaving the same 50 farmers on one shared resource.
4. Use causal mapping to diagram how composition, not any single farmer's decision, drives the
   community-level outcome — with an explicit feedback loop from forest depletion back onto every
   farmer's future harvest, sustainable and greedy alike.

**Assessment Indicators:** Explains outcome differences as a function of population composition, not
individual character; recognizes that a fence/boundary changes which farmers share which resource, not
any farmer's own behavior; can evaluate whether a mostly-sustainable composition is stable given
individual (not just collective) payoffs; connects the model to the common-pool-resource concept.

### Undergraduate: Quantitative Analysis and Governance

**Learning Objectives:**
- Connect the composition-dependent outcome to frequency-dependent selection / evolutionary game
  theory — a fixed-strategy population game, not an individually-strategic one.
- Evaluate Ostrom's institutional design principles (especially boundary rules and graduated
  sanctions) against what this base model does and does not implement: a fence exists; monitoring,
  sanctioning, and communication do not.
- Design a systematic sweep of `Sustainables-Comm1`/`Sustainables-Comm2` against `Harvest-rate-greedy`
  to characterize the composition threshold at which a community's forest stock collapses vs.
  persists (a BehaviorSpace-style experiment; none currently exists for this model — flagged as a gap
  for `netlogo-modeler`, not built here).
- Critically evaluate what the model does and doesn't represent — no learning or adaptation among
  farmers, no reproduction/replicator dynamics, fixed types — and connect to
  `theory:computational-models-as-theory-mediators` (TheoryBase): a model as a protected theoretical
  mediator, not a fitted-to-data artifact judged by outcome match alone.

**Key Concepts:** Frequency-dependent selection; evolutionary game theory; common-pool resource
governance (Ostrom's design principles); institutional boundary rules; population-composition effects
vs. individual-strategy effects.

**Activities:**
1. Design and (once built) run a BehaviorSpace experiment sweeping composition and harvest-rate
   parameters; analyze the resulting collapse/persistence boundary quantitatively.
2. Compare this model's fixed-type, composition-driven dynamic against a genuinely evolutionary
   (replicator-dynamic) model where type frequency itself changes based on differential wealth —
   note explicitly that Two Communities does *not* implement this, a real extension point rather than
   something to describe as already present.
3. Write a short analysis connecting the model's Ostrom-relevant design gaps (no monitoring, no
   sanctioning, no communication) to what would need to be added to represent a fuller common-pool-
   resource governance scenario.

## Content Anchor Alignment

**Primary:**
1. **Governing the Commons** — the model's most literal anchor: a common-pool resource, a fence as a
   literal boundary/institution, and the collective-action tension between individual and group
   interest (Ostrom 1990).
2. **Cooperation Games** — structurally a frequency-dependent population game: "sustainable" and
   "greedy" function as fixed strategies whose *prevalence*, not any individual instance of them,
   determines the outcome.
3. **Computer Models** — the model itself, and the restructuration-theory claim above that
   manipulating population composition (not any individual agent's rule) and observing the emergent
   collective divergence is a distinct pedagogical act from being told "greedy people ruin the
   commons."

**Secondary:**
4. **Our Mind** — the model's own assessment item bank targets dispositionism/individual-blame
   directly (`TC-001`'s "Green Valley has better people" misconception); a strong entry point for
   noticing this bias in one's own first-reaction explanation before running the model.
5. **Global Sustainability Goals** — sustainable resource use at community/group scale; real-world
   transfer to fisheries, groundwater basins, and other bounded or unbounded shared resources.

**Essential Questions:**

> **What are the causes and consequences of the way a group manages a shared resource?**
> *Example: Why does one community's shared forest survive while an otherwise-identical community's
> forest collapses? Is it what the individuals in each community are like, or how many of each kind of
> individual there are?*

> **What can we do, as individuals, in the school, or as a community, given what we've learned?**
> *Example: If your class were split into two groups sharing a limited resource (class supplies, time
> on a shared computer), how would the proportion of "sustainable" vs. "greedy" behavior among your
> classmates change the outcome for everyone — and what could a boundary or rule, like the model's
> fence, change about that?*

## Thinking Tool Integration

1. **Payoff Matrices** — build a matrix not for two individuals, but for a sustainable farmer's
   average payoff vs. a greedy farmer's average payoff, computed under different community
   compositions (mostly-sustainable vs. mostly-greedy) using the model's own wealth monitors — showing
   that the payoff to a given *type* is frequency-dependent, not fixed.
2. **Causal Mapping** — map population composition → community forest-stock trajectory → individual-
   type accumulated wealth, with an explicit feedback loop (forest depletion reduces every farmer's
   future harvestable tree height, sustainable and greedy alike) and no arrow from a "punishing
   institution" or "communication" node, since the base model has neither.
3. **Analogies & Analogy Mapping** — the natural exercise given the assessment's own item `TC-004`:
   map Two Communities' composition-lever directly against Two Foresters' individual-choice-lever
   (harvest-rate sliders ↔ composition-count sliders; forester ↔ farmer-type; private/shared switch ↔
   `Community-forest?` fence), and explicitly name where the analogy breaks down — Two Foresters' rate
   is individually authored per forester; Two Communities' rate is fixed per type and shared globally,
   with only composition varying.
4. **Tinbergen's Questions** — Function (why might a greedy strategy pay off individually in the short
   run?); Mechanism (how does a farmer's move-to-tallest-tree rule interact with type-based harvest
   %?); Evolution (if types had differential reproduction based on accumulated wealth, the population
   mix itself would evolve — the base model does *not* implement this, worth naming as an honest
   limitation, not routed around); Development — a genuinely weak fit for this specific model, since
   farmers do not learn or adapt (`info_sections.Concepts and Principles`), worth stating explicitly
   rather than forcing an answer.
5. **The Noticing Tool** — before running the model, notice your own first-reach explanation for why
   one community might do worse than another; after running it, notice whether that explanation
   still holds once you've seen the harvesting rule held constant.
6. **Structure of Knowledge Diagrams** — Population composition → frequency-dependent outcome →
   common-pool resource dynamics → institutional design (Ostrom).

## Competency Alignment

Verified against the real ConceptBase registry (direct inspection of
`conceptbase/registry/concept/*.json`, 2026-08-27):

- **OE-CONCEPT-oe-interdisciplinary-cooperation (Cooperation, OE-INTERDISCIPLINARY-v1.0.0)** — model
  shows the tension between individual and collective benefit at group scale; performance indicators:
  explain why a shared resource can fail even when every individual's behavior rule is fixed and
  identical across communities, analyze how composition changes the collective outcome.
- **OE-CONCEPT-oe-interdisciplinary-institutions (Institutions, OE-INTERDISCIPLINARY-v1.0.0)** — new
  this pass, not used by `two-foresters.md`: the model's `Community-forest?` fence is a literal,
  concrete instance of "stable, socially recognized structures... that organize and constrain
  collective behavior" (the concept's own definition); performance indicator: explain what changes,
  and what doesn't, when a boundary/institution divides one shared resource into two.
- **OE-CONCEPT-oe-interdisciplinary-agency (Agency, OE-INTERDISCIPLINARY-v1.0.0)** — used with a
  different emphasis than `two-foresters.md`: no individual farmer in this model chooses or authors
  their own harvest rule (it is fixed by type), so the performance indicator here is distinguishing
  the *experimenter's* structural control (population composition) from any individual farmer's own
  (minimal, fixed) agency — a nuance this model makes available that Two Foresters, where each
  forester's own rate *is* individually authored, does not.
- **OE-SANDBOX-CONCEPT-000008 (Decentralized Causal Reasoning, OE-INTERDISCIPLINARY-v1.0.0)** —
  performance indicator: explains a community's forest fate as the aggregate, frequency-dependent
  result of population composition, with no individual farmer's decision, and no farmer's "character,"
  driving the outcome.
- **OE-SANDBOX-CONCEPT-000009 (Agent-Based Modeling, OE-INTERDISCIPLINARY-v1.0.0)** — performance
  indicator: can describe the model as many fixed-rule agents whose *proportions*, not their
  individual rules, produce an emergent collective pattern. Note: this concept's own `examples[]`
  field currently names only Two Foresters as its cooperation-domain instantiation
  ("a real cooperation-and-agency-domain instantiation of this concept, not a natural-selection one");
  Two Communities is a real second instantiation and a natural candidate to add to that list in a
  future ConceptBase pass — flagged as a finding, not silently edited here.
- Three concepts named in `metadata.json`'s free-text `concepts[]` remain confirmed ConceptBase gaps
  (direct search of `registry/concept/*.json` found no match for any): `Common Pool Resource` (a new
  gap this pass surfaces), and `Sustainable resource use` / `Complex systems` (already flagged as gaps
  by `two-foresters.md`'s equivalent pass, Vikunja #42) — none claimed as covered above.
  `Social dilemma` is covered via Cooperation Games/Governing the Commons, not a standalone concept,
  the same judgment `two-foresters.md` made for its own `metadata.json` concepts.

Restructuration (`OE-SANDBOX-CONCEPT-000007`) deliberately **not** added here, for the same reason
`two-foresters.md` omits it: this strand's theoretical-rationale section argues the *mechanism* is
restructuration theory, but the concept a learner is meant to come away understanding is decentralized/
compositional causal reasoning about a shared resource, not restructuration theory itself as content.

## Assessment

**Assessment file:** [assessments/two-communities.json](../assessments/two-communities.json)
(`OE-ASSESS-TWOCOMMUNITIES-001`) — a real, already-built 5-item integrated-causal-reasoning
assessment, grade band 6-8, diagnosing integrated vs. dichotomized reasoning about group composition
and collective outcomes. Its vignette ("The Two Villages," Green Valley vs. Blue Hill) is a real
configuration this model can reproduce directly: two 20-family (in the model, 25-farmer) villages
sharing forests, differing only in composition, with Green Valley's forest healthy and Blue Hill's
depleted — matching the model's default `Sustainables-Comm1`/`Sustainables-Comm2` asymmetry (23/2 vs.
2/23) closely enough to run live as the stimulus rather than only describe it. Item `TC-004` already
asks students to compare this model directly against Two Foresters, which this strand's theoretical-
rationale section now supplies the grounded answer for (group-composition effects vs. individual-
authorship effects, not "more agents = more realistic"). No changes needed to the assessment itself —
already schema-consistent and directly usable; this strand supplies the theoretical rationale for why
its "integrated" answer key is the one this specific model's instruction should produce.

## Common Misconceptions

(Drawn directly from the existing assessment's own scoring taxonomy, `assessments/two-communities.json`)

1. "That community just has worse people" — individual-blame/dispositional framing that ignores
   composition effects and systemic structure (`TC-001`).
2. "Punish the greedy families more severely" / "educate them" — solutions that target individuals
   without addressing composition or structural incentives (`TC-002`).
3. "Even all-modest families would eventually become greedy because of human nature" — genetic-
   determinist framing that treats behavior type as fixed destiny rather than a modeled parameter
   (`TC-003`).
4. "More agents means more realistic, so there's no real conceptual difference from Two Foresters" —
   ignores that the two models isolate genuinely different causal levers (`TC-004`).
5. "We can't predict anything without knowing the individual families" — over-individualized thinking
   that ignores the predictive power of composition alone (`TC-005`).

## Connections to Other Models

- **two-foresters** — the individual-scale pair to this strand's group-scale case; compare individual-
  authorship-driven outcomes (Two Foresters) to composition-driven outcomes (Two Communities) directly,
  per this strand's own Analogies & Analogy Mapping activity and the assessment's `TC-004` item.
- **evolution-ethnocentrism** — explore how group identity, not just group composition, affects
  cooperation.
- **population-size-living-costs** — explore effects of scaling the number of agents further.

## References

Real, DOI-verified sources (LiteratureBase `OE-LITERATURE-` ids where applicable):

- Wilensky, U., & Papert, S. (2010). Restructurations: Reformulations of knowledge disciplines
  through new representational forms. Proceedings of the Constructionism 2010 Conference.
  (`OE-LITERATURE-wilensky-papert-2010`)
- Resnick, M. (1996). Beyond the centralized mindset. Journal of the Learning Sciences, 5(1), 1-22.
  (`OE-LITERATURE-resnick-1996`)
- Hanisch, S., Eirdosh, D., González Galli, L., Hartelt, T., Pérez, G., & Cupo, B. (2025).
  Understanding agency in evolutionary explanations: an assessment tool for biology education.
  Journal of Biological Education, 60(3), 341-370. (`OE-LITERATURE-hanisch-2025` — the canonical,
  Crossref-verified record; the assessment pattern `assessments/two-communities.json` is based on.)
- Ostrom, E. (1990). *Governing the Commons*. Cambridge University Press. (not yet a LiteratureBase
  record — cited as `two-foresters.md` also cites it, bare.)
- Hardin, G. (1968). The tragedy of the commons. *Science*, 162(3859), 1243-1248. (not yet a
  LiteratureBase record.)
- Hanisch, S. (2022). Two forest communities. OpenEvo NetLogo Models.
  https://openevo.eva.mpg.de/teachingbase/netlogo/ — the model's own author/source.

## Schema-Ready Contribution

**Not done.** A formal OECB LPM contribution against ConceptBase's real `lpm.schema.yaml` (step 5 of
the 5-step process) is the natural next step, not claimed here — consistent with `two-foresters.md`'s
and `bug-evolution.md`'s own discipline on this point.

---

**Status:** In progress — companion to [two-foresters.md](two-foresters.md)'s theoretical-rationale
work, written 2026-08-27 ahead of the India conference demo.
