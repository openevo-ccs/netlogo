# LPM Strand: Bug Evolution

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment,
> competency alignment, and assessment are drafted below. Step 5 (a formal, schema-validated
> LPM contribution to ConceptBase, validated against its real `lpm.schema.yaml`) is not done — flagged as
> the natural next step, not claimed as complete. See
> [lpm-strands/README.md](README.md) for the full 5-step process this strand follows.
>
> **2026-08-29 pass**: added a real International Curriculum Grounding section (US NGSS +
> Sachsen Gymnasium Biologie, see below) alongside the existing OpenEvo/ConceptBase competency
> alignment, and verified a competency gap against the real, unmerged `conceptbase`
> `extend-bio-core-evolution-mechanisms` branch. This does not change the status above — it adds
> external grounding on top of still-unvalidated AI synthesis.
>
> **Note on `bug-evolution-complete.md`**: an earlier, unlinked draft (dated 2025-01-09,
> `metadata.json`'s `lpmStrand` pointer never updated to point at it) sat alongside this stub with
> substantially the same grade-band/content-anchor/competency content, independently verified
> accurate against the real ConceptBase registry. This strand incorporates and supersedes that
> draft's content rather than duplicating the effort, and adds the theoretical grounding
> (restructuration theory) that draft predates.

## Model
- [Run the model](../models/bug-evolution/app.html)
- [Model metadata](../models/bug-evolution/metadata.json)
- [Download .nlogo](../models/bug-evolution/model.nlogo)

## Overview

This strand explores natural selection through a simple, intuitive model: beetles evolving running
speed to escape bird predators. Students investigate how variation, differential survival, and
inheritance lead to evolutionary change — authoring or manipulating the model's agent-level rules
directly, rather than only being told the population-level outcome.

## Theoretical Rationale: Restructuration Theory

This is this strand's central addition, from the restructuration-theory-ecosystem-enrichment plan
(`lab_manager`, 2026-08-06/07): a stated reason *why* a NetLogo agent-based model should be expected
to support **integrated** (not dichotomized) causal reasoning about natural selection, not just an
assumption that "using a computer model helps."

Wilensky & Papert (2010)'s restructuration theory (`theory:restructuration-theory`, TheoryBase)
argues a representational infrastructure change can restructure what is learnable in a domain, not
merely make existing content easier to teach. Restated in curriculum-evolution Manual Ch.6/10's
hierarchical-Bayesian vocabulary: authoring or manipulating this model's individual beetle/predator
rules directly, and observing population-level speed change emerge across generations, is
hypothesized to revise a learner's **hyperprior**-level belief about causal structure — from
centralized/single-controller ("beetles evolved to be fast") toward decentralized/emergent-from-
local-rules (differential survival and reproduction, aggregated across many individual beetles, with
no designer) — rather than only adding a new domain-specific fact.

This is a candidate mechanism, not proven fact: `proposition:restructuration-grounds-icr-transfer`
(TheoryBase) states explicitly what it does and doesn't establish. Goldstone & Wilensky (2008) and
Tullis & Goldstone (2017) find real transfer of complex-systems causal reasoning following agent-
based-modeling instruction; Aslan & Wilensky (2016) apply the same restructuration approach directly
to an evolution-education misconception (anisogamy) — the closest published precedent to what this
strand attempts for natural selection specifically. None of these studies tests transfer into
evolutionary reasoning from this exact model, so this strand is itself a candidate test case for
`question:computational-representation-of-lpm-moderator-space` and
`question:ct-transfer-to-evolutionary-reasoning` (QuestionBase), not a validated result.

Grounded further in `cross-domain-construct:selection-as-hierarchical-bayesian-updating`
(TheoryBase): natural selection (the model's phenomenon), individual conceptual change (a student
revising their own causal model while using it), and restructuration (the representational
infrastructure change itself) are three grains of the same underlying selection-over-a-hypothesis-
space process — genetic evolution updates gene-frequency parameters across generations, the model
lets a student directly manipulate the mechanism generating that update, and using the model at all
is a restructuration event for how the student's own reasoning is structured.

See the corresponding ccs-graph relation record,
`rel:agent-based-modeling-netlogo--integrated-causal-reasoning--meso--001`, for the full
computational/theoretical/methodological/question cross-linking this rationale draws on.

## Grade-Band Progression

### Grades 6-8: Introduction to Natural Selection

**Learning Objectives:**
- Understand that traits vary in a population
- Observe how some traits lead to higher survival
- Recognize that traits can change over generations
- Avoid teleological thinking ("evolved to")

**Key Concepts:** Trait variation, differential survival, inheritance, natural selection, adaptation

**Activities:**
1. Run the model with different predation pressures
2. Observe how speed changes over generations
3. Record observations about which beetles survive
4. Discuss: why do faster beetles become more common — and notice that no single beetle, predator,
   or the model itself "decided" this outcome; it emerged from many individual survival/reproduction
   events

**Assessment Indicators:** Can describe how natural selection works; recognizes traits vary and
change over time; avoids "evolved to" language; understands not all beetles survive; can distinguish
what the model's designer set up (the rules) from what the model's designer did not directly set
(the population-level outcome).

### Grades 9-12: Mechanisms of Natural Selection

**Learning Objectives:**
- Explain the four components of natural selection (variation, differential survival, inheritance,
  time)
- Analyze how trade-offs affect evolution
- Understand context-dependence of adaptation
- Avoid genetic determinism and teleological thinking

**Key Concepts:** Variation, differential survival, inheritance, time; trade-offs (speed vs. energy
cost); context-dependence; fitness and reproductive success; population-level vs. individual-level
change.

**Activities:**
1. Systematically explore predation pressure and energy cost
2. Compare outcomes with different food availability
3. Use Tinbergen's questions to analyze beetle speed
4. Discuss real-world examples of natural selection

**Assessment Indicators:** Explains natural selection using proper terminology; recognizes trade-offs
and context-dependence; avoids teleological and genetic-determinist thinking; distinguishes
individual vs. population-level change.

### Undergraduate: Advanced Analysis

**Learning Objectives:**
- Design and test hypotheses about natural selection
- Analyze model behavior using quantitative methods
- Connect model findings to empirical research
- Evaluate model assumptions and limitations, including what kind of thing a computational model
  *is* (see `theory:computational-models-as-theory-mediators`, TheoryBase — a model as a protected
  theoretical mediator, not a fitted-to-data artifact judged by outcome match alone)

**Key Concepts:** Evolutionary game theory; quantitative analysis of selection; model validation and
limitations; applications to medicine, agriculture, conservation.

**Activities:**
1. Design original BehaviorSpace experiments (see `experiments/bug-evolution-predation-speed.xml`)
2. Analyze model data statistically
3. Compare model predictions with empirical studies (antibiotic resistance, pesticide resistance)
4. Write research reports connecting model findings to the restructuration-theory rationale above

## International Curriculum Grounding

Added this pass (2026-08-29) — real US and German curriculum data, distinct from the OpenEvo/
ConceptBase competency alignment below (which stays the internal alignment layer).

**US — NGSS (Next Generation Science Standards).** Real DCI/performance-expectation codes,
picked for what this specific model's interface lets a student manipulate and observe (not a
generic "evolution unit" match):

- **MS-LS4-4** — "Construct an explanation based on evidence that describes how genetic
  variations of traits in a population increase some individuals' probability of surviving and
  reproducing in a specific environment." Direct match: the model's predation-pressure slider is
  exactly this "specific environment" variable, and the speed-frequency plot is the evidence.
- **MS-LS4-6** — "Use mathematical representations to support explanations of how natural
  selection may lead to increases and decreases of specific traits in populations over time."
  Direct match: the model's own trait-frequency-over-time output.
- **HS-LS4-2** — "...evolution primarily results from four factors: (1) the potential for a
  species to increase in number, (2) heritable genetic variation..., (3) competition for limited
  resources, and (4) the proliferation of those organisms that are better able to survive and
  reproduce..." All four factors are literally the model's mechanism (reproduction, mutation,
  predation-driven differential survival).
- **HS-LS4-3** — "Apply concepts of statistics and probability to support explanations that
  organisms with an advantageous heritable trait tend to increase in proportion to organisms
  lacking this trait." Matches the Undergraduate band's BehaviorSpace/statistical-analysis
  activities directly.
- **LS2.A (Interdependent Relationships in Ecosystems), HS-LS2-1** — predator-prey population
  dynamics as an ecosystem-scale carrying-capacity question, for the predator-species-choice
  (bird vs. spider) angle specifically.

**Germany — Sachsen Gymnasium Biologie** (from `EvoMentor/importers/fwu_sn_fine_grained_candidates.json`,
real FWU MEM SPARQL-sourced Lernziel/Kompetenz entries; coverage status is
`fine-grained-content-staged-untagged` per `deutsche_lp/land/sachsen/lp/records/crosswalk.yaml` —
**grade band unspecified in the current staged data**, so no Klassenstufe is claimed below):

- *"Zusammenwirken von Mutation, Rekombination, Selektion und Isolation als ausgewählte Faktoren
  der Synthetischen Evolutionstheorie"* (the interaction of mutation, recombination, selection,
  and isolation as factors of the Synthetic Theory of Evolution) —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-7649-1` (also `-7649-2`). Direct match:
  mutation and selection are literally this model's two evolutionary mechanisms.
- *"Kennen von Prinzipien der Evolution von Organismen"* (knowing principles of the evolution of
  organisms) — `https://lp-sachsen.org/resource/lernziel-lerninhalt-7646-1` (also `-7646-2`).
- *"Koevolution"* (coevolution) —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-126030-1` and `-126103-1`. This is a
  stronger-than-generic match: the model is explicitly a predator-prey system (beetle speed vs.
  bird/spider predation pressure), i.e. a coevolutionary dynamic, not just single-species
  selection — a framing the current strand text above doesn't yet name explicitly. Worth
  surfacing to students directly: ask what would happen to predator speed/strategy if predators
  also evolved in the model (they don't, currently — a good discussion/extension prompt, and a
  candidate for `netlogo-modeler` if a future revision adds evolving predators).
- *"Kennen von Belegen für die Evolution"* / *"...der Organismen"* (knowing evidence for
  evolution) — `-7660-1`/`-7660-2`, `-7854-1`/`-7854-2` — general evidentiary grounding for the
  Undergraduate band's real-world-comparison activities (antibiotic/pesticide resistance).

**Gap flagged, not papered over**: this model's core mechanism is predator-driven differential
survival, but there is no "Coevolution" or "Predator-Prey Coevolution" concept in ConceptBase
main or in the pending `extend-bio-core-evolution-mechanisms` branch (see Competency Alignment
below) — only the German Sachsen data names it. If OpenEvo wants an internal competency for this,
it doesn't exist yet.

## Content Anchor Alignment

**Primary:**
1. **Computer Models** — the model itself, and the restructuration-theory claim that authoring/
   manipulating it is a distinct pedagogical act from being told its outcome.
2. **Cross-Species Comparisons** — natural selection across species; comparative examples (beetles,
   bacteria, humans).
3. **Ancient Ancestors** — evolution as a historical, generational process.

**Secondary:**
4. **Our Mind** — human tendencies toward teleological/centralized-mindset thinking, and how a
   decentralized representational infrastructure might restructure that tendency.
5. **Global Sustainability Goals** — antibiotic/pesticide resistance as real-world natural selection.

## Thinking Tool Integration

1. **Tinbergen's Questions** — Function (how does speed help beetles survive?); Mechanism (how does
   speed affect escape?); Development (how do beetles develop running ability?); Evolution (how did
   running speed evolve, across generations, not within one beetle's lifetime?).
2. **Causal Mapping** — diagram: predation pressure → survival → reproduction → speed frequency,
   with no arrow pointing from a "goal" or "designer" node.
3. **The Noticing Tool** — what patterns do you notice in speed changes? What surprises you? What
   questions does this raise about evolution?
4. **Analogies & Analogy Mapping** — compare to antibiotic resistance in bacteria, pesticide
   resistance in insects, human adaptations to high altitude.
5. **Payoff Matrices** — trade-offs between speed and energy cost.
6. **Structure of Knowledge Diagrams** — Variation → Selection → Adaptation → Evolution.

## Competency Alignment

Verified against the real ConceptBase registry (`conceptbase_search`, 2026-08-07):

- **OE-CONCEPT-bio-core-natural-selection (Natural Selection, BIO-CORE-v1.0.0)** — model shows all four components of
  natural selection; performance indicators: explain using proper terminology, identify variation/
  differential-survival/inheritance/time, predict how selection pressures affect trait frequencies.
- **OE-CONCEPT-bio-core-adaptation (Adaptation, BIO-CORE-v1.0.0)** — speed can be adaptive in high-predation
  environments; performance indicators: explain why speed might be adaptive, recognize context-
  dependence, avoid assuming adaptations are "good" or "progressive."
- **OE-CONCEPT-oe-interdisciplinary-agency (Agency, OE-INTERDISCIPLINARY-v1.0.0)** — beetles don't "choose" to evolve;
  performance indicators: distinguish individual agency from population-level evolution, avoid
  anthropomorphizing beetles, understand evolution has no goals.
- **OE-SANDBOX-CONCEPT-000007 (Restructuration, OE-INTERDISCIPLINARY-v1.0.0)** — new this pass:
  performance indicator: can articulate why authoring/running the model's agent rules is a different
  kind of learning experience than reading the aggregate outcome in a textbook.
- **OE-SANDBOX-CONCEPT-000008 (Decentralized Causal Reasoning, OE-INTERDISCIPLINARY-v1.0.0)** — new
  this pass: performance indicator: explains the population-level speed change as an aggregate of
  many local survival/reproduction events, with no leader/designer/goal.
- **OE-SANDBOX-CONCEPT-000009 (Agent-Based Modeling, OE-INTERDISCIPLINARY-v1.0.0)** — new this pass:
  performance indicator: can describe the model as agent-level rules producing an emergent
  population-level pattern, and name that as the model's own pedagogical mechanism.

**Gap, not yet in ConceptBase main**: verified this pass (2026-08-29) against the
`conceptbase-wt-bio-core-evolution-extension` worktree — a real, un-merged, no-PR-yet branch
(`extend-bio-core-evolution-mechanisms`) proposes a BIO-CORE-v1.2.0 vocabulary extending 16 to 43
concepts, including **Trade-offs** (`OE-CONCEPT-000128`) and **Coevolution** is not among them
either (checked directly; absent from both main and the pending branch). Trade-offs would be a
direct match for this strand's speed-vs-energy-cost Payoff Matrices activity once/if that branch
merges — cite as pending, not as an existing ConceptBase concept.

## Assessment

**Assessment file:** [assessments/bug-evolution.json](../assessments/bug-evolution.json) — a real,
already-built 5-item integrated-causal-reasoning assessment (`OE-ASSESS-BUGEVOLUTION-001`), based on
the EvoFlex assessment pattern (Hanisch, Eirdosh, González Galli, Hartelt, Pérez & Cupo, 2026),
diagnosing integrated vs. dichotomized reasoning about teleology, Lamarckism, progressionism,
individual- vs. population-level thinking, and trade-offs/context-dependence. No changes needed —
already schema-consistent and directly usable; this strand supplies the theoretical rationale for why
its "integrated" answer key should be the one this specific model's instruction produces.

## Common Misconceptions

1. "Beetles evolved to be fast" — teleological language
2. "Beetles choose to be fast" — evolution is population-level, not individual choice
3. "Faster is always better" — ignores trade-offs and context-dependence
4. "Evolution has a goal" — no direction or purpose
5. "Individual beetles evolve" — evolution happens to populations, not individuals

## Connections to Other Models

- **swarming** — pure leaderless-emergence model (no evolution content); the natural second candidate
  for the Decentralized Self thread specifically (flagged, not built, in the restructuration-theory-
  ecosystem-enrichment plan's Phase 5).
- **island-world** — compare selection in different environments.
- **evolution-competition-forest-resources** — add resource competition.
- **wolves-sheep-grass** — compare predator-prey dynamics.

## References

Real, DOI-verified sources (LiteratureBase `lit:` ids where applicable) — no citation of either
unpublished OpenEvo teachingbase page that motivated the search for this literature:

- Wilensky, U., & Papert, S. (2010). Restructurations: Reformulations of knowledge disciplines
  through new representational forms. Proceedings of the Constructionism 2010 Conference.
  (`OE-LITERATURE-wilensky-papert-2010`)
- Goldstone, R. L., & Wilensky, U. (2008). Promoting transfer by grounding complex systems
  principles. Journal of the Learning Sciences, 17(4), 465-516. (`OE-LITERATURE-goldstone-wilensky-2008`)
- Aslan, Ü., & Wilensky, U. (2016). Restructuration in practice: Challenging a pop-culture
  evolutionary theory through agent based modeling. Proceedings of Constructionism 2016, 230-238.
  (`OE-LITERATURE-aslan-wilensky-2016`)
- Hanisch, S., Eirdosh, D., González Galli, L., Hartelt, T., Pérez, G., & Cupo, B. (2026).
  Understanding agency in evolutionary explanations: an assessment tool for biology education.
  Journal of Biological Education, 60(3), 341-370. (`OE-LITERATURE-hanisch-2026`) — the
  assessment pattern `assessments/bug-evolution.json` is based on.
- Darwin, C. (1859). On the Origin of Species. (`OE-LITERATURE-darwin-1859`)

## Schema-Ready Contribution

**Not done.** A formal LPM contribution to ConceptBase, validated against its real `lpm.schema.yaml` (step 5 of
the 5-step process) is the natural next step, not claimed here — consistent with this plan's own
discipline of stating what a pass does and doesn't establish.

---

**Status:** In progress — Phase 5 of the restructuration-theory-ecosystem-enrichment plan
(`lab_manager`, 2026-08-06/07).
