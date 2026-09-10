# LPM Strand: BeeSmart Hive Finding

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment,
> competency alignment (ConceptBase concepts **and** the newer CompetencyBase competency records),
> a light International Curriculum Grounding note, and a new 5-item assessment item bank are
> drafted below (2026-09-01, this pass builds the strand from scratch — the model itself was only
> just ported into this repo). Step 5 (a formal, schema-validated ConceptBase strand/subStrand
> contribution) is not done — flagged as the natural next step, not claimed as complete.

> **Why this strand exists — a real cross-repo connection, not a generic topic match.** This model
> was ported into the `netlogo` repo specifically because it fills a gap the sibling `bee-k12`
> repo's own mature six-strand K-12 bee curriculum had already identified for itself:
> - [`bee-k12/lpm/strands/strand-a.yaml`](../../bee-k12/lpm/strands/strand-a.yaml)'s subStrand
>   `OE-STRAND-000615` ("How the Message Gets Around," ~12-14 / Kl. 7-8) currently asks students to
>   "model, with a simple diagram, how competing scout dances and a quorum threshold let a swarm
>   choose a single nest site without central control." This model is a runnable version of exactly
>   that diagram.
> - [`bee-k12/lpm/strands/strand-d.yaml`](../../bee-k12/lpm/strands/strand-d.yaml)'s subStrand
>   `OE-STRAND-000647` ("From Foraging Behavior to Algorithm," ~16-19 / Kl. 11-13) centers on the
>   Artificial Bee Colony (ABC) optimization algorithm, using `bee-k12`'s own
>   `computational-agent-based-models` thinking tool (`bee-k12/lpm/thinking-tools.yaml`, still
>   `status: draft` there pending formal OpenEvo review — **not changed by this strand or this
>   pass**).
> - `bee-k12`'s own vocabulary already names this exact model: `OE-CONCEPT-bee-k12-swarm-decision-
>   making`'s `examples[]` field (added 2026-09-01, `bee-k12/lpm/vocabulary/BEE-K12-v0.1.0.yaml`)
>   calls it "a strong candidate to eventually replace or supplement Strand A's `OE-STRAND-000615`
>   'simple diagram' performance indicator with a real interactive model," and
>   `OE-CONCEPT-bee-k12-computational-foraging-models`'s `examples[]` explicitly distinguishes ABC
>   (a bio-inspired **metaphor** for optimization, not real bee biology) from two genuine families
>   of **descriptive** agent-based bee-colony models: this classroom-scale NetLogo model, and the
>   research/policy-scale BEEHAVE family. **This strand follows that same distinction deliberately**
>   — BeeSmart belongs with BEEHAVE in the descriptive-ABM category, not with ABC's optimization-
>   metaheuristic category, and this strand's own framing below does not blur the two.
>
> `bee-k12` is a **separate LPM** (different repo, its own bilingual EN/DE Waldorf-pilot age-band
> convention). This strand does **not** try to merge the two LPMs or adopt `bee-k12`'s framing —
> it stays general/standards-neutral the way this repo's other "in progress" strands already are.
> But its grade-band progression, concept alignment, and essential questions are informed by, and
> cross-reference, the real gap `bee-k12` already identified. See this strand's own "Connection
> back to `bee-k12`" note near the end for what should flow the other direction once this model is
> verified working.

## Model
- [Run the model](../models/beesmart-hive-finding/app.html) — **not yet click-through tested in a
  live browser**; see the model's own README.md and `metadata.json` generation notes. Treat as
  unverified until someone confirms it loads and runs correctly.
- [Model metadata](../models/beesmart-hive-finding/metadata.json)
- [Model card (structural decomposition)](../models/beesmart-hive-finding/model-card.json)
- [Agent manifest (control surface)](../models/beesmart-hive-finding/agent-manifest.json)
- [Download .nlogo](../models/beesmart-hive-finding/model.nlogo)
- **License note**: this model keeps its own original **CC BY-NC-SA 3.0** license (Guo & Wilensky
  2014, Northwestern CCL), not the CC BY-SA license covering the rest of this collection — read
  the model's own README.md before reusing it commercially. This strand's own text and the new
  assessment item bank below inherit that same license, for the same reason.

## Overview

A swarm of 100 scout bees (`hive-number` candidate sites, `initial-percentage` of scouts exploring
first, up to `initial-explore-time` ticks) searches for a new nest site. A scout that discovers a
site inspects it, then advertises it back at the swarm through a waggle dance whose length and
"enthusiasm" scale with the site's quality — better sites get longer, more persuasive dances, which
recruit more idle scouts to go inspect that site themselves. Interest in a site declines a little on
each repeat visit, so a site that looked good on a scout's first visit gradually gets a weaker
recommendation on later visits, letting lower-quality sites be abandoned even after an early lead.
Once enough scouts are gathered at one site to cross the `quorum` threshold, those scouts start to
"pipe" — a signal that spreads through the swarm — and once every bee is piping, the whole swarm
commits to that site and the model stops. **No single bee, and no external controller, ever
compares all the candidate sites or decides which one wins** — the choice is an emergent property of
many local, quality-weighted waggle-dance interactions (models/beesmart-hive-finding/README.md,
grounded in Seeley 2010, *Honeybee Democracy*).

The model deliberately simplifies the real biology in one stated way worth naming to students
directly: only the ~3-5% of the colony that are scouts are modeled at all (`README.md`); the much
larger non-scout population is left out because, in the real system, they simply follow the scouts
to wherever the decision lands rather than taking part in the decision themselves.

**Two real model-interface gaps, flagged rather than written around** (per this workflow's own
discipline of handing genuine interface gaps back to `netlogo-modeler` instead of describing
capabilities the model doesn't actually expose):
1. Two of the model's four plots — `on-site` and `committed` — have zero pens wired up
   (`model-card.json`'s `outputs[]`), unlike `piping-scouts` and `watching v.s. working`. This
   means a student cannot currently plot per-site scout counts over time (which site is pulling
   ahead, and when) or see which site the swarm actually committed to as a plotted output — both
   would directly strengthen the Undergraduate band's quorum-dynamics activities below.
2. `agent-manifest.json`'s `available_reporters` is empty — nothing is exposed for programmatic
   inspection of a run's outcome (e.g. no reporter for "which site won" or "final tick count"),
   which limits BehaviorSpace-style automated analysis (see the Undergraduate band's flagged-but-
   not-built experiment design below).

## Grade-Band Progression

*(`metadata.json` targets only **9-12** and **Undergraduate** for this model — per the source
model's own stated audience, "high school and university students" — not inflated to a wider K-12
span. This is a real, deliberate difference from `bee-k12`'s own Strand A, which treats the same
underlying phenomenon narratively, without a runnable model, starting as early as ~10-12 (Kl. 5-6);
see the cross-repo note below for what this gap means.)*

### Grades 9-12: Observing Decentralized, Quorum-Based Decision-Making

**Learning Objectives:**
- Describe the model's mechanism end to end: discovery → quality-linked waggle dance → recruitment
  → declining interest on repeat visits → quorum reached at one site → piping → swarm commitment.
- Explain why the swarm's choice is not made by any single bee, "lead" scout, or external
  vote-counter — it emerges from many local, quality-weighted recruitment events.
- Distinguish "the site with the most scouts early in the run" from "the site the swarm eventually
  commits to," and explain concretely why these can differ (quality-linked dance strength +
  declining interest per revisit).
- Avoid the "leader bee decides" and "bees vote democratically" misconceptions — the mechanism is
  neither centralized control nor a literal one-bee-one-vote tally.

**Key Concepts:** Waggle dance communication; quorum sensing; declining interest; decentralized/
emergent decision-making; collective intelligence; scouts as a decision-making subpopulation.

**Activities:**
1. Run Setup + Go at default settings (`hive-number` 10, `initial-percentage` 12,
   `initial-explore-time` 200, `quorum` 33) several times; record which site wins each run and
   discuss why the outcome varies between identical-setting runs (stochastic site placement and
   initial-scout allocation).
2. Use the Show/Hide Dance Path button to watch the waggle dance's figure-eight geometry directly,
   and connect what's visually different between a strong and a weak dance to the underlying
   `quality` variable.
3. Watch the `piping-scouts` and `watching v.s. working` plots during a run and discuss what each
   rising/falling line represents in terms of individual bee behavior (task-string transitions).
4. Use **Causal Mapping** to diagram: discover → inspect → dance (strength ∝ quality) → recruit →
   re-visit (interest declines) → quorum reached → pipe → commit — explicitly checking there is no
   arrow into that diagram from a "leader" or "vote-counter" node.

**Assessment Indicators:** Explains why an early-popular but lower-quality site can still lose;
explains piping/quorum commitment without invoking a leader or external vote-counter; distinguishes
the scouts-only modeled subpopulation from the full colony; avoids majority-count/first-mover
framing of the outcome.

### Undergraduate: Quorum Sensing, Collective Intelligence, and Model Evaluation

**Learning Objectives:**
- State Seeley's (2010) argument for what makes real swarm decision-making both fast and accurate:
  a unified goal, distributed search, honest advertising (dance strength tied to quality), and —
  in the real biological system, but **not implemented in this simplified model** — active
  cross-inhibition ("stop signals") between scouts advertising rival sites.
- Evaluate explicitly what this model does and doesn't implement: quality-linked recruitment,
  declining interest, and quorum-triggered piping are all real model mechanics; direct
  cross-inhibition between competing sites (the biological "stop signal" — see Neubauer et al.
  2023 below) is not modeled at all. Declining interest is a simplified stand-in for that
  mechanism, not the same thing.
- Analyze the quorum-threshold speed-accuracy trade-off: vary `quorum` and discuss what a lower
  threshold trades away (robustness against a mediocre site winning by early chance recruitment)
  for what it gains (a faster decision) — directly using the model's own `quorum` slider as the
  manipulated variable.
- Critically evaluate this model's stated limitations (scouts-only population; no reporters exposed
  for programmatic inspection; the `on-site`/`committed` plots' missing pens noted above) rather
  than routing around them.
- Explicitly distinguish this model's category — a genuine descriptive agent-based model of real
  bee behavior — from the Artificial Bee Colony (ABC) optimization algorithm's category — a
  bio-inspired *metaphor* applied to unrelated search/optimization problems — per `bee-k12`'s own
  `OE-CONCEPT-bee-k12-computational-foraging-models` distinction (see the cross-repo note above).
  Naming this difference correctly is itself a learning objective here, not an aside.

**Key Concepts:** Quorum sensing; honest signaling; distributed search and information pooling;
speed-accuracy trade-off in collective decision-making; descriptive vs. metaphorical/optimization
agent-based models; restructuration (authoring/observing agent-level rules directly vs. being told
the aggregate finding as a fact).

**Activities:**
1. Design (not yet built — a real gap, flagged for `netlogo-modeler`, not built here, since this
   model currently has zero BehaviorSpace `<experiments>` per `model-card.json`) a BehaviorSpace
   sweep across `quorum` × `initial-percentage` × `hive-number`, characterizing how often the swarm
   converges on the objectively best-quality site vs. a runner-up, and how many ticks it takes.
2. Read Seeley (2010)'s account of swarm decision-making alongside the model and identify which of
   his design features the model implements directly (honest quality-linked advertising, quorum
   threshold), which it simplifies (declining interest as a stand-in for active cross-inhibition),
   and which it omits entirely (explicit stop-signal cross-inhibition).
3. Write a short evaluation distinguishing this model from the Artificial Bee Colony algorithm as
   two different categories of "bee-inspired computation," using `bee-k12`'s own
   `OE-CONCEPT-bee-k12-computational-foraging-models` framing as a starting point.
4. Connect the model directly to CompetencyBase's `OE-COMPETENCY-openevo-core-competencies-dcr-comp`
   (Decentralized Causal Reasoning: Computational Systems) 9-12 developmental band, whose own text
   names "a scripted path vs. a swarm/ant-colony-optimization approach" as exactly the comparison
   Activity 3 makes (see Competency Alignment below).

**Assessment Indicators:** States Seeley's design-features argument for fast, accurate swarm
decisions; correctly identifies what the model omits (active cross-inhibition) vs. implements
(quality-linked recruitment, declining interest, quorum); reasons about the quorum speed-accuracy
trade-off; distinguishes descriptive vs. metaphorical/optimization agent-based-model categories
without conflating them.

## Theoretical Rationale: Restructuration Theory

Parallel to [bug-evolution.md](bug-evolution.md)'s and
[population-size-living-costs.md](population-size-living-costs.md)'s own restructuration-theory
rationale — a stated reason *why* this model should be expected to support **integrated** (not
dichotomized) causal reasoning about collective decision-making specifically, not just an assumption
that "using a computer model helps."

Wilensky & Papert (2010)'s restructuration theory (`OE-THEORY-restructuration-theory`, TheoryBase)
argues a representational infrastructure change can restructure what is learnable in a domain, not
merely make existing content easier to teach. Watching the swarm's choice emerge from many local
waggle-dance interactions — with no arrow in the causal map pointing to a "leader" or "vote-counter"
node — is hypothesized to revise a learner's **hyperprior**-level belief about causal structure for
group decision-making specifically: from centralized/single-controller (assuming a lead bee, or a
literal vote tally, must be doing the deciding) toward decentralized/emergent-from-local-rules (a
shared choice as the aggregate, feedback-driven consequence of many quality-weighted local
interactions). This is the same "beyond the centralized mindset" shift Resnick (1996) documents for
StarLogo ecological cases (flocking, traffic jams), applied here to a genuine real-time **collective
choice** rather than a population-level statistical pattern — a meaningfully different case than
either `bug-evolution.md`'s natural-selection instance or `island-world.md`'s multilevel-selection
instance, since here the "outcome" is a single, discrete decision the group converges on, not a
trait frequency.

**A real, concrete finding this pass surfaces**: TheoryBase's own
`OE-CROSSDOMAINCONSTRUCT-decentralized-causal-reasoning-domain-generality` record currently lists
only two domains — `ecological-evolutionary` and `cognitive-self` — with a `social (unexplored,
deliberately not listed)` instantiation noted in prose. It does **not** name a `computational`
domain at all, despite CompetencyBase's own `OE-COMPETENCY-openevo-core-competencies-dcr-comp`
(Decentralized Causal Reasoning: Computational Systems — see Competency Alignment below) already
existing as exactly that instantiation, citing Resnick (1996) directly. This model is a strong
candidate concrete instantiation for a `computational` domain entry in that TheoryBase record,
alongside `bug-evolution`/`island-world`'s `ecological-evolutionary` instantiation — flagged here as
a finding for a future TheoryBase contribution, not built here (out of scope for this pass, and this
record lives in `theorybase`, not `netlogo`).

This is a candidate mechanism, not a proven fact — see `OE-PROPOSITION-restructuration-grounds-icr-
transfer` (TheoryBase) for what it does and doesn't establish. No `ccs-graph` relation record
specific to this model exists yet (the closest is the model-agnostic
`rel:agent-based-modeling-netlogo--integrated-causal-reasoning--meso--001`, which grounds
`bug-evolution.md`'s own rationale) — a candidate for a future, model-specific `ccs-graph` record,
not built here.

## Content Anchor Alignment

**Primary:**
1. **Computer Models** — the model itself, and the restructuration-theory claim above that watching
   a group decision emerge tick-by-tick from local rules is a distinct pedagogical act from being
   told "bees use quorum sensing" as a textbook sentence.
2. **Cross-Species Comparisons** — the swarm's decentralized, quorum-triggered convergence on a
   single shared choice, compared explicitly to how a human group (a class, a jury, a company
   board) reaches a shared decision — the same comparison `bee-k12` Strand A's own worked essential
   question already asks for this exact phenomenon.

**Secondary:**
3. **Our Mind** — the intuitive pull toward looking for "which bee decided," and what that reflex
   reveals about how a human mind expects decisions to work by default (Resnick 1996's "centralized
   mindset"), including where that same reflex might mislead a person analyzing a *human* group
   decision.

**Deliberately not claimed**: Governing the Commons and Cooperation Games were both considered and
set aside rather than forced — the model has no resource-scarcity, free-rider, or strategic-choice
structure (every scout follows the identical behavioral rule; there is no cost/benefit decision a
scout makes, and the nest site is a one-time collective choice, not an ongoing managed resource).
Forcing either anchor here would misrepresent what this specific model actually lets a student
investigate.

**Essential Questions** (OpenEvo's broad-then-worked pattern):

> **Computer Models** — *What can we learn from computer models about human evolution, behavior,
> and sustainability?* Worked: A NetLogo model shows a swarm of scout bees converge on the single
> best nest site with no leader ever comparing the options. What does watching this decision emerge,
> tick by tick, teach you that being told "bees use quorum sensing" as a sentence in a textbook
> doesn't?

> **Cross-Species Comparisons** — *What are the similarities and differences between humans and
> other species, and why do these exist?* Worked: A honeybee swarm reaches a single shared decision
> through competing waggle dances and a quorum threshold, with no vote-counter and no leader. How is
> this similar to, and different from, how your class, a jury, or a company board reaches a shared
> decision?

> **Our Mind** — *What can we learn from our own thoughts and intuitions about human evolution,
> behavior, and sustainability?* Worked: When you first watch the swarm converge on one site, do you
> catch yourself looking for "which bee decided"? What does that reflex tell you about how your own
> mind expects decisions to work — and where might the same reflex mislead you when you look at a
> real human group decision?

## Thinking Tool Integration

1. **Causal Mapping** (primary) — diagram the full loop: discover → inspect → dance (strength ∝
   quality) → recruit → re-visit (interest declines) → quorum reached at one site → pipe → swarm
   commits — with no arrow from a "leader" or "vote-counter" node, since the model implements none.
   This is the executable version of exactly the "simple diagram" `bee-k12`'s Strand A currently
   asks students to draw by hand.
2. **Analogies & Analogy Mapping** (primary) — map the bee mechanism explicitly against one human
   group decision process (a class vote, a jury, a hiring committee): what corresponds (decentralized
   convergence via locally-weighted recruitment, a threshold for commitment) and what doesn't
   (no verbal argument, no discussion or persuasion between individuals, no unequal social
   influence) — the same worked essential question above, turned into a structured comparison.
3. **Structure of Knowledge Diagrams** (secondary, Undergraduate band) — facts (individual scout
   discover/dance/re-visit behaviors) → concepts (waggle-dance encoding, declining interest, quorum
   sensing) → principles (decentralized/emergent collective decision-making, speed-accuracy
   trade-offs in collective intelligence).

## International Curriculum Grounding

A lighter pass than the real, dataset-grounded NGSS + Sachsen Gymnasium Biologie crosswalk the
2026-08-29 passes ran for the collection's 11 evolution/commons-dilemma models (that pass drew on a
real FWU MEM SPARQL-sourced dataset scoped to evolution and commons-dilemma content specifically —
this model's phenomenon, quorum-based collective decision-making, falls outside that dataset's
scope, so this pass does not claim the same depth of verification):

- **US — NGSS.** **HS-LS2-8** (LS2.D, Social Interactions and Group Behavior) — "Evaluate the
  evidence for the role of group behavior on individual and species' chances to survive and
  reproduce." A real, direct match: honeybee swarm nest-site selection is a canonical example of
  group behavior with direct survival consequences (a colony without adequate shelter before winter
  does not survive) — not independently re-verified against a primary NGSS source this pass, named
  with reasonable confidence rather than cited as fully checked.
- **Germany — Sachsen Gymnasium Biologie.** Not checked this pass. The real, staged FWU MEM dataset
  (`EvoMentor/importers/fwu_sn_fine_grained_candidates.json`) that grounded the other 11 strands'
  German-side matches is scoped to evolution content; quorum-sensing/complex-systems content was not
  searched in it for this pass. Flagged as a genuine gap, not silently skipped.

## Competency Alignment

Two real, distinct sources exist in this ecosystem — both checked directly this pass, not assumed:

**ConceptBase concepts** (verified against `conceptbase/registry/concept/*.json` directly,
2026-09-01 — the same alignment layer the other 11 "in progress" strands use):

- **`OE-SANDBOX-CONCEPT-000008` (Decentralized Causal Reasoning, `OE-INTERDISCIPLINARY-v1.0.0`)** —
  an unusually precise match: this concept's own `nonExamples[]` field already names "attributing a
  flock's coordinated turn to a 'leader bird' signaling the others" as the exact misconception this
  model's own mechanism directly contradicts. Performance indicator: explains the swarm's site
  choice as the aggregate result of many local, quality-weighted waggle-dance interactions, with no
  leader or vote-counter.
- **`OE-SANDBOX-CONCEPT-000009` (Agent-Based Modeling, `OE-INTERDISCIPLINARY-v1.0.0`)** —
  performance indicator: describes the model as agent-level rules (discover/dance/re-visit/pipe)
  producing an emergent, population-level collective choice, and names that as the model's own
  pedagogical mechanism. Note: this concept's `examples[]` currently names only a bug-evolution
  instance (natural selection) and a Two Foresters instance (cooperation); this model is a real
  third instantiation (real-time collective decision-making) and a candidate to add to that list in
  a future ConceptBase pass — flagged as a finding, not silently edited here.
- **`OE-CONCEPT-oe-interdisciplinary-collective-intelligence` (`OE-INTERDISCIPLINARY-v1.0.0`,
  status `stable`)** — direct match by definition ("problem-solving... capability that emerges from
  the coordinated activity of many individuals... exceeding what any one could achieve alone");
  performance indicator: explains why no single scout could locate and evaluate all candidate sites
  the way the swarm collectively does.
- **`OE-CONCEPT-oe-interdisciplinary-communication` (`OE-INTERDISCIPLINARY-v1.0.0`, status
  `stable`)** — the waggle dance as the model's literal communication channel; performance
  indicator: explains how dance length/enthusiasm encodes site quality for other scouts.
- **`OE-CONCEPT-oe-interdisciplinary-distributed-cognition` (`OE-INTERDISCIPLINARY-v1.0.0`, status
  `stable`)** — a weaker, secondary fit: the swarm's "assessment" of which site is best is
  distributed across many scouts' individual, partial assessments rather than held by any one bee;
  worth naming but not the strand's central concept.

**CompetencyBase competencies** (verified against `competencybase/records/*.yaml` directly,
2026-09-01 — a real, newer, more precise home for competencies than ConceptBase concepts,
per `conceptbase/proposals/0015-competencybase-relocation.md`; the other 11 "in progress" strands
predate this relocation and cite ConceptBase concepts only, so this is genuinely new grounding for
this strand, not a duplicate of an existing pattern):

- **`OE-COMPETENCY-openevo-core-competencies-dcr-comp` (Decentralized Causal Reasoning:
  Computational Systems, `DCR.COMP`)** — this pass's single strongest competency match in the whole
  collection: the record's statement is written around exactly this model's mechanism ("explaining
  an emergent, system-level computational pattern... as the result of many simultaneous local-agent
  rules or processes, with no single agent or process directly controlling the outcome"), and its
  own 9-12 developmental band names "a scripted path vs. a swarm/ant-colony-optimization approach"
  as a worked comparison — directly usable as this strand's Undergraduate Activity 4. Its 13-16 band
  ("critically evaluating claims of transfer between computational decentralized-systems reasoning
  and decentralized reasoning in other domains... recognizing that structural similarity across
  domains does not by itself establish that the same underlying causal structure is at work") is
  also a direct fit for this strand's Analogies & Analogy Mapping activity's explicit
  breakdown-naming requirement.
- **`OE-COMPETENCY-openevo-core-competencies-dcr` (Decentralized Causal Reasoning, parent, `DCR`)**
  — the broader competency `dcr-comp` sits under; performance indicator: distinguishes decentralized/
  aggregate explanations (this model's actual mechanism) from agent-centered explanations (a "leader
  bee"), recognizing which one this specific case actually supports.
- **`OE-COMPETENCY-openevo-core-competencies-systems` (Systems Thinking, `SYSTEMS`)** — its 9-12 band
  ("modelling complex adaptive systems... analysing leverage points for intervention") fits the
  Causal Mapping activity directly; performance indicator: identifies the quorum threshold as the
  model's own leverage point (Undergraduate Activity 4's speed-accuracy trade-off).
- **`OE-COMPETENCY-openevo-foundational-competencies-cooperation` (Cooperation Competencies, `COOP`)**
  — a genuinely weaker fit than for this collection's commons-dilemma models, worth stating rather
  than forcing: its statement does name "collective decision-making" directly, but its
  developmentalProgression is built around negotiation, turn-taking, and institutional
  cooperation-under-conflict — none of which this model implements (scouts don't negotiate; there is
  no individual cost/benefit choice). Noted for completeness, not claimed as a primary alignment.

**Cross-reference to `bee-k12`'s own vocabulary** (real, already-existing records in
`bee-k12/lpm/vocabulary/BEE-K12-v0.1.0.yaml`, a separate LPM's vocabulary, cited here for context
only, not imported into this repo's own alignment): `OE-CONCEPT-bee-k12-swarm-decision-making` and
`OE-CONCEPT-bee-k12-waggle-dance-communication` already name this exact model in their `examples[]`
fields (added 2026-09-01, the same research pass that led to this port), and
`OE-CONCEPT-bee-k12-computational-foraging-models` is the source of this strand's ABC-vs-descriptive-
ABM distinction (see the header note above).

## Assessment

**Assessment file:** [assessments/beesmart-hive-finding.json](../assessments/beesmart-hive-finding.json)
(`OE-ASSESS-BEESMARTHIVEFINDING-001`) — newly built this pass, grade band 9-12/Undergraduate, a
5-item integrated-causal-reasoning assessment following the EvoFlex-derived pattern this
collection's other assessment files use. Its vignette ("Two Candidate Nest Sites") is grounded
directly in the model's own documented mechanics (`README.md`'s "How it works," `model-card.json`'s
breed/procedure structure: quality-linked dance strength, declining interest per revisit,
quorum-triggered piping and commitment, and the scouts-only population simplification).

**Honesty note, stated twice because it matters twice over**: (1) this vignette was **not** verified
against an actually-executed run of the model — it is a mechanics-derived illustration, not a
confirmed observed output; (2) per the model's own README, `app.html` has not yet been click-through
tested in a live browser at all, since no local NetLogo/`tools/netlogo-mcp` session was available
when either the model or this assessment was built. Both should be verified — ideally together, by
actually running the vignette's described configuration — before this assessment is used with
students. This item bank targets misconceptions distinct from this collection's evolution-themed
assessments: majority-count/first-mover framing, "leader bee" centralized-mindset framing, quorum-
as-universal-agreement, scouts-as-whole-colony, and false-equivalence/false-uniqueness bias in the
bee-to-human-decision analogy — see `assessments/beesmart-hive-finding.json`'s `teachingNotes` for
the full taxonomy.

**License note**: this assessment file is released CC BY-NC-SA 3.0 to match the model it's
grounded in, not this repo's usual CC BY-SA 4.0 (see the file's own `metadata.license` field).

## Common Misconceptions

(Drawn from this strand's own new assessment's scoring taxonomy,
`assessments/beesmart-hive-finding.json`)

1. "Whichever site gets the most scouts first is the site the swarm will pick" — majority-count/
   first-mover framing that ignores quality-linked dance strength and declining interest per revisit
   (`BSHF-001`).
2. "A lead or especially experienced scout must be comparing the sites and directing the others" —
   the centralized-mindset misconception this model's mechanism directly contradicts; no procedure
   in the model implements a comparing/leading role (`BSHF-002`).
3. "Reaching quorum means all 100 scouts agree" or "quorum count proves objective quality" —
   confuses the local quorum threshold with universal inspection or a quality guarantee (`BSHF-003`).
4. "This model shows the whole colony voting" — misreads the model's own stated scouts-only
   simplification as either full-colony representation or a mere performance shortcut (`BSHF-004`).
5. False equivalence ("the bees are just voting, exactly like a human show-of-hands") or false
   uniqueness bias ("bees have nothing in common with human decisions") when analogizing to human
   group decisions, rather than naming both what transfers and what doesn't (`BSHF-005`).

## Connections to Other Models

- **swarming** — a pure leaderless-emergence model (flocking, no decision/choice content); the
  natural companion model in this collection for decentralized-self/collective-behavior content,
  already flagged as such by `bug-evolution.md`'s own Connections section (as a candidate for the
  restructuration-theory-ecosystem-enrichment plan's "Decentralized Self" thread). This model adds
  what `swarming` doesn't have: a discrete, quorum-triggered collective **choice** among options,
  not just continuous coordinated movement.
- **bug-evolution** / **island-world** — same core `OE-SANDBOX-CONCEPT-000008` (Decentralized
  Causal Reasoning) competency target, applied to population-level natural/multilevel selection
  rather than a real-time collective decision; a useful three-way comparison of what "decentralized"
  means across different timescales and mechanisms (generational selection vs. one-shot consensus).

## Connection back to `bee-k12` (flagged, not acted on here)

Per this workflow's own scope, this is a finding to surface, not a change to make in `bee-k12`'s
files:

- `bee-k12/lpm/strands/strand-a.yaml`'s `OE-STRAND-000615` currently targets ~12-14 (Kl. 7-8) with a
  diagram-only performance indicator, while this model's own stated audience (and this strand's
  grade-band progression above) is 9-12/Undergraduate — a real band mismatch, not a seamless
  substitution. Once this model is verified actually running (see the two "not yet click-through
  tested" flags above), `bee-k12` would need a deliberate decision, not an automatic one: keep
  `OE-STRAND-000615`'s younger diagram-only indicator as is and treat this model as a *later*,
  currently-unmodeled deepening band in `bee-k12`'s own progression, rather than a direct
  same-band replacement.
- `bee-k12/lpm/strands/strand-d.yaml`'s `computational-agent-based-models` thinking tool
  (`bee-k12/lpm/thinking-tools.yaml`) is still `status: draft` pending formal OpenEvo review. This
  strand's own grounding (a real, runnable, structurally-decomposed model, now with a competency
  match as precise as `OE-COMPETENCY-openevo-core-competencies-dcr-comp`) is additional real-world
  evidence for that tool, worth surfacing to whoever runs that review — not itself sufficient to
  change the draft status unilaterally.
- `bee-k12/resources/computational-bee-models.yaml`'s `netlogo-beesmart-hive-finding` entry states
  the port as a still-open question at the time it was written; this pass confirms the port and this
  strand both now exist. That resource entry could be updated to reflect that once someone
  double-checks it against this pass — flagged, not edited here (`bee-k12` is read-only reference
  for this pass, per this task's own scope).

## References

Real, checked sources — DOI-verified where a DOI exists, LiteratureBase `OE-LITERATURE-` ids given
where a record already exists:

- Guo, Y., & Wilensky, U. (2014). NetLogo BeeSmart Hive Finding model.
  http://ccl.northwestern.edu/netlogo/models/BeeSmartHiveFinding. Center for Connected Learning and
  Computer-Based Modeling, Northwestern University, Evanston, IL. **Not yet a LiteratureBase
  record** — a real gap, flagged rather than assigned an invented id.
- Seeley, T. D. (2010). *Honeybee Democracy*. Princeton University Press. The model's own stated
  scientific basis. **Not yet a LiteratureBase record** — same gap.
- Resnick, M. (1996). Beyond the centralized mindset. *Journal of the Learning Sciences*, 5(1),
  1-22. https://doi.org/10.1207/s15327809jls0501_1 (`OE-LITERATURE-resnick-1996`).
- Wilensky, U., & Papert, S. (2010). Restructurations: Reformulations of knowledge disciplines
  through new representational forms. *Proceedings of the Constructionism 2010 Conference*.
  (`OE-LITERATURE-wilensky-papert-2010`).
- von Frisch, K. — decoded the waggle dance's encoding of direction and distance (1973 Nobel Prize
  in Physiology or Medicine, shared with Lorenz and Tinbergen), per `bee-k12`'s own
  `OE-CONCEPT-bee-k12-waggle-dance-communication`; cited here via that concept's own definition
  rather than independently re-verified against a primary von Frisch source this pass.
- Neubauer, A. C., Davidson, J. D., Wild, B., Dormagen, D. M., Landgraf, T., Couzin, I. D., &
  Smith, M. L. (2023). Honey bee drones are synchronously hyperactive inside the nest. *Animal
  Behaviour*. https://doi.org/10.1016/j.anbehav.2023.05.018 — cited here for the real biological
  "stop signal" cross-inhibition research this model's simplified declining-interest mechanic
  stands in for (Undergraduate band), via `bee-k12`'s own `strand-d.yaml` header note and
  `OE-CONCEPT-bee-k12-swarm-decision-making`'s `examples[]`, not independently re-verified against
  the primary source this pass. **Not yet a LiteratureBase record.**

## Schema-Ready Contribution

**Not done.** A formal strand/subStrand contribution to ConceptBase, validated against its real
`strand.schema.yaml` (the same schema shape `bee-k12`'s own strand files use — step 5 of the 5-step
process) is the natural next step, not claimed here — consistent with the discipline the other 11
"in progress" strands already apply to this same step.

---

**Status:** In progress — full strand built 2026-09-01, the first pass at this model's LPM strand,
grounded explicitly in the real cross-repo gap `bee-k12` had already identified for its own Strand A
and Strand D. Grade-band progression, content-anchor/thinking-tool alignment, a light International
Curriculum Grounding note, competency alignment (both ConceptBase concepts and CompetencyBase
competency records), and a new assessment item bank are drafted; schema contribution (step 5)
pending. The model itself remains unverified as actually running in a browser — flagged repeatedly
above, not glossed over.
