# LPM Strand: Two Foresters

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment,
> competency alignment, and assessment are drafted below. Step 5 (a formal, schema-validated
> OECB LPM contribution against ConceptBase's real `lpm.schema.yaml`) is not done — flagged as
> the natural next step, not claimed as complete. See
> [lpm-strands/README.md](README.md) for the full 5-step process this strand follows.
>
> **Note on `two-foresters-complete.md`**: an earlier, unlinked draft (dated 2025-01-09) sat
> alongside this stub with substantially the same grade-band/content-anchor/competency content,
> independently verified accurate against the real ConceptBase registry. This strand incorporates
> and supersedes that draft's content rather than duplicating the effort, and adds the theoretical
> grounding (restructuration theory) that draft predates — the same pattern already applied to
> [bug-evolution.md](bug-evolution.md) on 2026-08-07. Unlike Bug Evolution's case,
> `metadata.json`'s `lpmStrand` pointer already correctly pointed at this file, not the orphaned
> `-complete.md` draft — one fewer broken link to fix here.

## Model
- [Run the model](../models/two-foresters/app.html)
- [Model metadata](../models/two-foresters/metadata.json)
- [Download .nlogo](../models/two-foresters/model.nlogo)

## Overview

This strand explores the fundamental social dilemma of cooperation through the simplest possible
setting: two foresters, each independently harvesting from a regrowing tree resource (shared or
split into private plots, by a switch), each controlling only their own harvest rate. Students
investigate how two independently-set individual decision rules — with no negotiated joint plan
built into the model — aggregate into a collective outcome, understanding the tension between
short-term individual benefit and long-term collective welfare.

## Theoretical Rationale: Restructuration Theory

This is this strand's central addition, parallel to [bug-evolution.md](bug-evolution.md)'s
restructuration-theory rationale (`lab_manager`, 2026-08-06/07 for that strand; this section
2026-08-26): a stated reason *why* this model should be expected to support **integrated** (not
dichotomized) causal reasoning about cooperation and social-dilemma outcomes specifically, not just
an assumption that "using a computer model helps."

Checked directly against this model's real mechanics (`models/two-foresters/model-card.json`), not
assumed: each forester's only controllable variable is their own harvest-rate parameter
(`Percent-cut1`, `Percent-cut2` — sliders, not authored low-level code, a real distinction from how
"authoring/manipulating agent rules directly" is sometimes framed for this ecosystem's more
code-forward models). The two foresters do not communicate, do not negotiate, and do not share a
joint plan anywhere in the base model's procedures (`setup`, `go`, `cut-trees`,
`harvest-private`/`harvest-commons`, `regrow`) — the order in which they harvest each iteration is
random, and the aggregate forest-stock trajectory (and each forester's accumulated wealth) is
nothing but the compounding result of two independently-set parameters interacting with a shared
logistic regrowth function. This is a genuinely decentralized, emergent system in the same
structural sense Resnick (1996) and `cross-domain-construct:decentralized-causal-reasoning-domain-
generality` (TheoryBase) name for ecological/evolutionary cases: no single controlling agent, no
built-in coordinator, decides the collective outcome.

Wilensky & Papert (2010)'s restructuration theory (`theory:restructuration-theory`, TheoryBase)
argues a representational infrastructure change can restructure what is learnable in a domain, not
merely make existing content easier to teach. Restated in curriculum-evolution Manual Ch.6/10's
hierarchical-Bayesian vocabulary: manipulating each forester's harvest-rate parameter directly and
observing the aggregate sustainability outcome emerge — rather than being told "cooperation is good"
or "the tragedy of the commons happens" as a stated fact — is hypothesized to revise a learner's
**hyperprior**-level belief about causal structure for social-dilemma outcomes specifically: from
centralized/single-controller (an implicit "the foresters agreed to over-harvest," or "one forester
is just greedy") toward decentralized/emergent-from-local-rules (two independent, non-communicating
harvest decisions, aggregated through a shared resource dynamic, producing an outcome neither
forester individually "decided").

This is a candidate mechanism, not a proven fact, and it is explicitly a **parallel, not identical**
claim to `learningdependency:abm-decentralized-reasoning-precedes-icr-natural-selection` (TheoryBase)
— that record's own mechanism is theory-relative to `theory:restructuration-theory` for natural
selection specifically; this strand does not assume the same sequencing claim transfers automatically
to the cooperation/social-dilemma domain without its own argument, which is why a separate
`oe:LearningDependency` record (`learningdependency:abm-decentralized-reasoning-precedes-icr-
cooperation-social-dilemma`) states it rather than silently reusing the natural-selection one. No
published study tests this specific claim for this specific model; this strand is itself a candidate
test case, not a validated result.

Grounded further in `cross-domain-construct:decentralized-causal-reasoning-domain-generality`
(TheoryBase), whose own "social (unexplored)" domain instantiation — "markets, norm emergence, and
other decentralized social coordination phenomena... named for completeness only" — this strand is
the first real, concrete attempt to develop, not merely name.

## Grade-Band Progression

### Grades 3-5: Introduction to Cooperation Dilemmas

**Learning Objectives:**
- Understand that individual choices can affect others
- Recognize the difference between sustainable and unsustainable harvesting
- Observe how cooperation and defection lead to different outcomes

**Key Concepts:** Cooperation vs. defection; sustainable vs. unsustainable resource use; short-term
vs. long-term outcomes; trust and agreements.

**Activities:**
1. Run the model with different harvest rates (`Percent-cut1`, `Percent-cut2`)
2. Observe what happens when both foresters harvest lightly
3. Observe what happens when one forester harvests heavily
4. Discuss: why is it hard to cooperate even when it helps both — and notice that neither forester's
   slider "knows about" the other's, yet the forest's fate depends on both together

**Assessment Indicators:** Can describe what happens with different harvest choices; recognizes that
choices affect both foresters; understands sustainable vs. unsustainable harvesting; can distinguish
what each forester's own parameter controls from what neither forester's parameter alone determines
(the shared forest's fate).

### Grades 6-8: Understanding Social Dilemmas

**Learning Objectives:**
- Explain the structure of social dilemmas
- Analyze how payoff structures affect cooperation
- Understand the role of trust and communication (and their absence in the base model)
- Explore conditions that make cooperation more or less likely

**Key Concepts:** Social dilemma structure; payoff matrices and costs/benefits; trust and reputation;
communication and agreements; temptation to defect.

**Activities:**
1. Create payoff matrices for different harvest-rate scenarios
2. Experiment with different regrowth rates (`Growth-Rate`) and the private-vs-shared forest switch
3. Discuss real-world examples of social dilemmas
4. Use causal mapping to diagram the dilemma structure — with no arrow from a "joint decision" node,
   since the base model has none

**Assessment Indicators:** Explains why cooperation is difficult in dilemmas; analyzes how payoffs
affect decisions; recognizes the role of trust and communication (and that this model's base version
has neither); can identify social dilemmas in real life.

### Grades 9-12: Mechanisms and Solutions

**Learning Objectives:**
- Analyze the mathematical structure of social dilemmas (the logistic regrowth function, `k` and `r`)
- Evaluate different solutions to dilemmas (punishment, communication, institutions) — none of which
  the base model implements, a deliberate design feature worth naming, not a limitation to route
  around silently
- Connect to game theory and evolutionary biology
- Apply understanding to real-world resource management problems

**Key Concepts:** Game theory (Prisoner's Dilemma, Public Goods Game); Nash equilibrium; evolution of
cooperation; institutional solutions; repeated interactions and reputation; common-pool resources
(Ostrom 1990).

**Activities:**
1. Analyze the model as a Prisoner's Dilemma
2. Explore how repeated interactions (multiple `go` iterations) change outcomes
3. Design institutional solutions (rules, monitoring, punishment) the base model doesn't have, and
   discuss what would need to be added to the model itself to represent them
4. Apply to climate change, fisheries, and other real-world dilemmas
5. Use Tinbergen's questions to analyze cooperation

**Assessment Indicators:** Analyzes dilemmas using game theory concepts; evaluates different solution
mechanisms; connects model to real-world problems; understands evolution of cooperation; can
articulate what the base model's absence of communication/negotiation/punishment mechanisms
demonstrates about minimal conditions for a social dilemma to arise.

## Content Anchor Alignment

**Primary:**
1. **Cooperation Games** — payoff matrices as representations of strategic interactions; Prisoner's
   Dilemma structure; evolution of cooperation in repeated interactions.
2. **Governing the Commons** — shared resource management; individual vs. collective interests;
   institutional solutions to dilemmas (Ostrom 1990).
3. **Computer Models** — the model itself, and the restructuration-theory claim above that
   manipulating each forester's harvest parameter directly and observing the emergent collective
   outcome is a distinct pedagogical act from being told the outcome.

**Secondary:**
4. **Global Sustainability Goals** — sustainable resource use; long-term vs. short-term thinking;
   intergenerational equity.
5. **Our Mind** — trust and social cognition; temptation and self-control; fairness and reciprocity;
   human tendencies toward centralized/intentional readings of an outcome that is, in this model,
   the aggregate of two non-communicating local decisions.

## Thinking Tool Integration

1. **Payoff Matrices** — students create and analyze payoff matrices for different harvest scenarios;
   activity: matrices for sustainable vs. unsustainable scenarios.
2. **Causal Mapping** — map individual harvest decisions → collective forest-stock outcome, with no
   arrow from a "joint plan" or "agreement" node, since the base model has neither.
3. **Tinbergen's Questions** — Function (how does harvesting help each forester?); Mechanism (how do
   harvest decisions affect the shared/private forest?); Development (how do children learn to
   cooperate?); Evolution (how did cooperation evolve in humans?).
4. **The Noticing Tool** — what patterns do you notice in sustainable vs. unsustainable outcomes?
   What surprises you? What questions does this raise about real-world dilemmas?
5. **Analogies & Analogy Mapping** — compare to climate change agreements, fishery management, public
   goods (clean air, parks).
6. **Structure of Knowledge Diagrams** — Social dilemmas → Game theory → Cooperation → Resource
   management.

## Competency Alignment

Verified against the real ConceptBase registry (`conceptbase_search`, 2026-08-26):

- **OE-CONCEPT-oe-interdisciplinary-cooperation (Cooperation, OE-INTERDISCIPLINARY-v1.0.0)** — model
  shows the tension between individual and collective benefits; performance indicators: explain why
  cooperation is difficult in dilemmas, analyze conditions that favor cooperation, evaluate solutions
  to cooperation problems.
- **OE-CONCEPT-oe-interdisciplinary-agency (Agency, OE-INTERDISCIPLINARY-v1.0.0)** — foresters make
  strategic choices (their own harvest-rate parameter) that affect outcomes; performance indicators:
  recognize forester decision-making, understand how individual choices aggregate into collective
  outcomes, analyze the role of agency in a dilemma with no built-in coordination mechanism.
- **OE-SANDBOX-CONCEPT-000008 (Decentralized Causal Reasoning, OE-INTERDISCIPLINARY-v1.0.0)** — new
  this pass: performance indicator: explains the forest's fate as the aggregate of two independent,
  non-communicating harvest decisions, with no negotiated joint plan, leader, or coordinator.
- **OE-SANDBOX-CONCEPT-000009 (Agent-Based Modeling, OE-INTERDISCIPLINARY-v1.0.0)** — new this pass:
  performance indicator: can describe the model as two independent parameter-driven agents producing
  an emergent collective pattern, and name that as the model's own pedagogical mechanism.
- Two concepts named in `metadata.json`'s free-text `concepts[]` (`Complex systems`, `Sustainable
  resource use`) remain real, confirmed ConceptBase gaps (Vikunja #42, closed 2026-08-26) — not
  claimed as covered by the above; `Social dilemma` is covered via Cooperation Games/Governing the
  Commons above, not a standalone concept.

Restructuration (`OE-SANDBOX-CONCEPT-000007`) deliberately **not** added here: this strand's own
theoretical-rationale section argues the *mechanism* is restructuration theory, but the concept a
learner is meant to come away understanding is decentralized causal reasoning about cooperation, not
restructuration theory itself as content — the same distinction `bug-evolution.md` draws by listing
000007 there (where "articulating why authoring the model is a different kind of learning
experience" is itself one of that strand's stated performance indicators, which this strand does not
claim).

## Assessment

**Assessment file:** [assessments/two-foresters.json](../assessments/two-foresters.json) — a real,
already-built 5-item integrated-causal-reasoning assessment, diagnosing integrated vs. dichotomized
reasoning about social dilemmas (individual blame, moral reasoning in place of analysis, technological
optimism, determinism). No changes needed — already schema-consistent and directly usable; this
strand supplies the theoretical rationale for why its "integrated" answer key should be the one this
specific model's instruction produces.

## Common Misconceptions

1. "Cooperation is always good" — explore when cooperation can be harmful
2. "People cooperate because they're nice" — understand structural bases of cooperation
3. "More cooperation is always better" — examine costs and trade-offs
4. "Cooperation requires conscious intention" — the base model has no communication or negotiation
   mechanism, yet produces a real collective outcome — learn about emergent cooperation/defection
5. "Once trust is broken, it can't be rebuilt" — study conditions for rebuilding trust

## Connections to Other Models

- **bug-evolution** — the parallel restructuration-theory case for natural selection; compare the two
  strands' `oe:LearningDependency` claims directly (natural-selection-specific vs.
  cooperation-specific — deliberately not asserted as the same claim).
- **two-communities** — compare individual vs. group-level cooperation.
- **population-size-living-costs** — explore effects of more agents.
- **evolution-competition-forest-resources** — add evolutionary dynamics.

### Thematic Connections
- **evolution-ethnocentrism** — compare cooperation with in-group favoritism.
- **evolution-resource-use-social-behavior** — explore punishment mechanisms this base model lacks.
- **wolves-sheep-grass** — compare cooperation vs. predation.

## References

Real, DOI-verified sources (LiteratureBase `OE-LITERATURE-` ids where applicable):

- Wilensky, U., & Papert, S. (2010). Restructurations: Reformulations of knowledge disciplines
  through new representational forms. Proceedings of the Constructionism 2010 Conference.
  (`OE-LITERATURE-wilensky-papert-2010`)
- Resnick, M. (1996). Beyond the centralized mindset. Journal of the Learning Sciences, 5(1), 1-22.
  (`OE-LITERATURE-resnick-1996`)
- Ostrom, E. (1990). *Governing the Commons*. Cambridge University Press.
- Axelrod, R. (1984). *The Evolution of Cooperation*. Basic Books.
- Hardin, G. (1968). The tragedy of the commons. *Science*, 162(3859), 1243-1248.
- Hanisch, S. (2022). Two foresters. OpenEvo NetLogo Models.
  https://openevo.eva.mpg.de/teachingbase/netlogo/ — the model's own author/source.

## Schema-Ready Contribution

**Not done.** A formal OECB LPM contribution against ConceptBase's real `lpm.schema.yaml` (step 5 of
the 5-step process) is the natural next step, not claimed here.

---

**Status:** In progress — companion to [bug-evolution.md](bug-evolution.md)'s restructuration-theory
work, 2026-08-26.
