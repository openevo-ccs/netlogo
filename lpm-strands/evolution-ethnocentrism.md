# LPM Strand: Evolution of Ethnocentrism

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment
> (including a new International Curriculum Grounding section, US NGSS + Sachsen Gymnasium
> Biologie), competency alignment, and assessment status are drafted below (2026-08-29). Step 5
> (a formal, schema-validated ConceptBase LPM contribution) is not done.
>
> **Note on `evolution-ethnocentrism-complete.md`**: an earlier, unlinked draft (dated 2025-01-09,
> `metadata.json`'s `lpmStrand` pointer never pointed at it) sat alongside this stub with
> substantially developed grade-band/content-anchor/competency content. Its competency citations
> were re-verified this pass against the real ConceptBase registry and are accurate. This strand
> incorporates and supersedes that draft's content rather than duplicating the effort, and adds
> this pass's international curriculum grounding (NGSS + Sachsen), which that draft predates.

## Model
- [Run the model](../models/evolution-ethnocentrism/app.html)
- [Model metadata](../models/evolution-ethnocentrism/metadata.json)
- [Download .nlogo](../models/evolution-ethnocentrism/model.nlogo)

## Overview

Agents carry an ethnicity marker (one of `Number-ethnicities` shapes) plus two independent
cooperation traits — `cooperate-with-same?` and `cooperate-with-different?` — whose four
combinations produce four named strategies: altruist (cooperates with everyone), ethnocentrist
(cooperates only with own ethnicity), cosmopolitan (cooperates only with other ethnicities), and
selfish (cooperates with no one). Interactions use a fully student-editable payoff matrix (inputs
`A`, `B`, `C`, `D`), and `interaction`/`offspring-placement` choosers switch between local
(neighbor-only) and global (anywhere) versions of both processes. Based directly on Axelrod &
Hammond's (2003, 2006) published ethnocentrism model, the model's own documentation states its
core finding plainly: local interaction and local offspring placement are what let ethnocentric
strategies outcompete both purely selfish and purely altruistic ones, because they create the
positive assortment (kin selection, frequency-dependent selection) that lets a costly cooperative
strategy defend itself from exploitation by selfish agents without incurring the same cost against
strangers.

## Grade-Band Progression

### Grades 9-12: Cooperation Strategies and Positive Assortment

**Learning Objectives:**
- Correctly name and distinguish the four emergent strategies (altruist, ethnocentrist,
  cosmopolitan, selfish) from their two underlying binary traits.
- Explain, using the model's own payoff matrix inputs, why the local/local (`interaction` = local,
  `offspring-placement` = local) setting favors ethnocentrism over the global/global setting.
- Recognize ethnocentrism as an evolved *strategy*, not a fixed biological destiny or a moral
  choice made by individual agents in the model.
- Avoid genetic-determinist and teleological framings ("ethnocentrism evolved because it's good
  for the group") in favor of a differential-fitness account tied to the model's actual mechanism.

**Key Concepts:** Positive assortment; kin selection; frequency-dependent selection; payoff
matrices; local vs. global interaction/reproduction; natural selection.

**Activities:**
1. Run the model at `interaction` = local / `offspring-placement` = local, then at anywhere/
   anywhere, holding the payoff matrix and `Number-ethnicities` fixed — compare which strategy
   dominates in each case.
2. Systematically vary the payoff matrix (`A`, `B`, `C`, `D`) and map out under which payoff
   structures ethnocentrism, cosmopolitanism, altruism, or selfishness each wins — build this as an
   explicit Payoff Matrix analysis, not just observation.
3. Vary `Number-ethnicities` from 1 (no ethnic distinction possible) up to 6 and discuss what
   changes about the dynamic as more distinguishable groups are added.
4. Apply Tinbergen's Questions to ethnocentrism: Function (what fitness advantage does
   in-group-only cooperation provide?), Mechanism (positive assortment via local
   interaction/reproduction), Development (not modeled here — flag as a real limitation),
   Phylogeny (why might this strategy have been favored across many social species' history?).

**Assessment Indicators:** Names all four strategies correctly from their trait combinations;
explains the local-vs-global outcome difference using positive assortment, not vague appeals to
"tribalism"; avoids teleological and genetic-determinist framing; can read a payoff matrix and
predict qualitative outcome direction.

### Undergraduate: Multilevel Selection Theory and Human Applications

**Learning Objectives:**
- State kin selection, frequency-dependent selection, and multilevel selection formally and
  distinctly, and identify which is doing the explanatory work under which of the model's
  settings.
- Read Axelrod & Hammond (2003, 2006) — the model's direct source — and identify what the model
  implements faithfully vs. simplifies.
- Critically and carefully evaluate what this model can and cannot tell us about real human
  intergroup dynamics: it has no learning, no reputation, no communication, no institutions, and
  models "ethnicity" as an arbitrary, costless-to-detect marker rather than anything socially or
  historically constructed — a significant simplification that should be named explicitly before
  any real-world application is drawn.
- Distinguish descriptive claims (ethnocentrism can be evolutionarily favored under these
  conditions) from normative ones (therefore ethnocentrism is good, or inevitable, or excusable) —
  the naturalistic-fallacy distinction, made concrete with this specific model.

**Key Concepts:** Multilevel selection theory; evolutionary game theory; model validation and
scope limits; the naturalistic fallacy; applications to human social psychology (with explicit
caution about overreach).

**Activities:**
1. Read Axelrod & Hammond (2003, 2006) alongside the model and write a short comparison of what
   the paper's model adds or omits relative to this NetLogo implementation.
2. Design a BehaviorSpace experiment testing whether ethnocentrism's advantage over cosmopolitanism
   shrinks as `Number-ethnicities` increases (more possible ethnic categories) or as `interaction`
   moves toward "anywhere."
3. Write a short argument distinguishing what this model shows (a strategy can be evolutionarily
   favored under specific structural conditions) from what it doesn't show (that the strategy is
   therefore justified, fixed, or unchangeable in humans) — explicitly naming the naturalistic
   fallacy.

**Assessment Indicators:** Distinguishes the three selection mechanisms with correct, specific
attribution to model settings; identifies concrete model simplifications when evaluating
real-world relevance; explicitly separates descriptive evolutionary claims from normative ones.

## Content Anchor Alignment

**Primary:**
1. **Cooperation Games** — the model's payoff matrix (`A`, `B`, `C`, `D`) is directly, literally a
   cooperation-game structure; this is the strongest, least-forced anchor match in this set.
2. **Cultural Diversity** — ethnicity markers and cross-group cooperation variation are the
   model's central subject.

**Secondary:**
3. **Our Mind** — in-group/out-group categorization as a well-documented human cognitive bias,
   distinct from (but potentially related to) the evolutionary strategy the model simulates.
4. **Cross-Species Comparisons** — in-group favoritism as a pattern observed across social species,
   not unique to humans.

## Thinking Tool Integration

1. **Payoff Matrices** — the model's `A`/`B`/`C`/`D` inputs are already a literal payoff matrix;
   have students derive, by hand, which strategy is favored under a few different A/B/C/D
   combinations before running the model to check.
2. **Tinbergen's Questions** — apply directly to ethnocentrism as a behavior (see 9-12 activities
   above); useful specifically because the model can answer Function and Mechanism but not
   Development, making the limitation itself pedagogically visible.
3. **Structure of Knowledge Diagrams** — facts (local interaction favors the ethnocentrist
   strategy under these payoffs) → concepts (positive assortment, kin selection,
   frequency-dependent selection) → principle (multilevel selection: traits costly at the
   individual level can be favored when population structure creates non-random interaction).

## International Curriculum Grounding

Real, citation-grounded — distinct from the OpenEvo/ConceptBase competency alignment below.

**US — NGSS.**
- **HS-LS2-8** (LS2.D, Social Interactions and Group Behavior) — "evaluate the evidence for the
  role of group behavior on individual and species' chances to survive and reproduce." Direct
  match: the four cooperation strategies and their differential fitness under local vs. global
  interaction are exactly this performance expectation's subject matter.
- **HS-LS4-2** (LS4.B, Natural Selection) — the four-factor account of evolution, here applied to a
  behavioral/strategic trait rather than a physical one.
- **HS-LS4-3** — "apply concepts of statistics and probability to support explanations that
  organisms with an advantageous heritable trait tend to increase in proportion" — direct match
  for the payoff-matrix-sweep activity.
- Note on scope: NGSS's LS4 strand is about biological evolution generally and does not name
  "ethnocentrism" or "intergroup cooperation" specifically — the fit above is at the level of the
  underlying selection/group-behavior mechanism, which is real and direct, not a claim that NGSS
  addresses this specific social-science topic.

**Germany — Sachsen Gymnasium Biologie** (from `EvoMentor/importers/fwu_sn_fine_grained_candidates.json`;
coverage status `fine-grained-content-staged-untagged` — **grade band unspecified in the current
staged data**):

- *"Zusammenwirken von Mutation, Rekombination, Selektion und Isolation..."* —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-7649-1` (also `-7649-2`).
- **Directly relevant, per the task's own framing guidance**: *"Übertragen evolutionsbiologischer
  Kenntnisse auf die Stammesentwicklung des Menschen"* (transferring evolutionary-biology
  knowledge to human phylogeny) —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-8134-1` (also `-8134-2`). Used carefully:
  this Lernziel is about human *phylogenetic* history, not directly about the evolution of a
  behavioral strategy like ethnocentrism — the honest connection is that this model's Undergraduate
  band explicitly discusses applying evolutionary reasoning to human social behavior, which is the
  same general move (applying evolutionary-biology knowledge to human-specific questions) this
  Lernziel names, not a literal common-descent content match.
- Supplementary real entries from the same Gymnasium Biologie document, found via a broader term
  search (not the "evolution" label filter): *"Sozialverhalten des Menschen"* (human social
  behavior) — `https://lp-sachsen.org/resource/lernziel-lerninhalt-7676-1` (also `-7676-2`) — a
  direct, strong match for this model's real-world application layer. *"Kennen proximater
  Ursachen des Verhaltens..."* / *"Kennen ultimater Ursachen des Verhaltens"* (proximate/ultimate
  causes of behavior) — `-7839-1`, `-7845-1` — maps directly onto this strand's Mechanism-vs-
  Function distinction in the Tinbergen's Questions activity above.

**Gap flagged, and directly relevant here**: exactly as with `evolution-resource-use-social-
behavior`, this model's own documentation names **kin selection, multilevel selection, and
frequency-dependent selection** as the mechanisms behind its outcomes, and **none of the three**
exist as concepts in ConceptBase main. All three exist as *proposed, unmerged* entries in the
`extend-bio-core-evolution-mechanisms` branch of the `conceptbase` repo (verified this pass; no PR
opened): `OE-CONCEPT-000126` (Kin Selection), `OE-CONCEPT-000125` (Multilevel Selection),
`OE-CONCEPT-000121` (Frequency-Dependent Selection), all `BIO-CORE-v1.2.0`. There is also no
ConceptBase concept for "ethnocentrism" or "in-group/out-group bias" specifically, in either main
or the pending branch.

## Competency Alignment

Verified against the real ConceptBase registry (`d:/dev/openevo-ccs-lab/conceptbase/registry/concept/`,
2026-08-29) — the competency IDs below were carried over from `evolution-ethnocentrism-complete.md`
and independently re-checked this pass; all four resolve to real, current registry entries:

- **OE-CONCEPT-oe-interdisciplinary-cooperation (Cooperation, OE-INTERDISCIPLINARY-v1.0.0)** —
  performance indicator: explain the conditions (payoff structure, population structure) that favor
  cooperation over defection in this model.
- **OE-CONCEPT-oe-interdisciplinary-agency (Agency, OE-INTERDISCIPLINARY-v1.0.0)** — performance
  indicator: distinguish the model's agent-level rule ("cooperate with same/different ethnicity
  yes/no") from population-level strategy-frequency outcomes; avoid treating the trait as a
  conscious choice.
- **OE-CONCEPT-bio-core-natural-selection (Natural Selection, BIO-CORE-v1.0.0)** — performance
  indicator: identify variation, differential fitness (energy from payoffs), and inheritance of
  strategy in the model.
- **OE-CONCEPT-bio-core-adaptation (Adaptation, BIO-CORE-v1.0.0)** — performance indicator: explain
  why ethnocentrism can be adaptive under specific structural conditions without asserting it's
  adaptive universally or that "adaptive" means "good."

**Not yet in ConceptBase**: Kin Selection, Multilevel Selection, Frequency-Dependent Selection
(see gap note above, shared with `evolution-resource-use-social-behavior`); no concept for
ethnocentrism/in-group bias specifically.

## Assessment

**Assessment file:** [assessments/evolution-ethnocentrism.json](../assessments/evolution-ethnocentrism.json) —
`OE-ASSESS-ETHNOCENTRISM-001`, a real, already-built integrated-causal-reasoning assessment using
a "Two Communities of River Valley" vignette (Red/Blue ethnic groups, differing cooperation
traditions, a town-council policy change), scored against verified real competencies
(`OE-CONCEPT-oe-interdisciplinary-cooperation`, `OE-CONCEPT-oe-interdisciplinary-agency`,
`OE-CONCEPT-bio-core-natural-selection`) — the same three competencies re-verified above.

**Noted gap, not fixed this pass**: like `island-world.json`, this vignette is a realistic
narrative scenario rather than one grounded in an actual run/configuration of *this* model (e.g.
"you set the payoff matrix to A=3, B=5, C=0, D=1 with local interaction and local offspring
placement, and ethnocentrists reached 78% of the population by tick 1000; when you switched to
anywhere/anywhere with the same payoffs, selfish agents reached 82% instead — why did the same
payoff structure produce such different outcomes?"). Flagged as a next step for strengthening this
existing assessment, not a missing item bank.

## Common Misconceptions

1. "Ethnocentrism is genetic and can't be changed" — the model shows strategy frequencies shift
   with structural conditions (payoffs, interaction locality), not that the trait is immutable;
   real human ethnocentrism additionally involves cultural transmission this model doesn't model
   at all (contrast with `evolution-resource-use-behavior-imitation`, which does model cultural
   transmission, for a different trait).
2. "Ethnocentrism evolved to help groups survive" — teleological framing; the accurate account is
   that ethnocentrist strategies had higher fitness than the alternatives under specific local-
   interaction conditions, not that evolution "aimed" at group survival.
3. "If a trait evolved, it must be good, or at least excusable" — the naturalistic fallacy;
   explicitly separate descriptive (what the model shows can evolve) from normative (what humans
   ought to do) claims.
4. "The model shows ethnocentrism is universal to social species" — the model shows ethnocentrism
   *can* be favored under specific structural conditions this model implements; it doesn't show
   this is the only possible or universally realized outcome.
5. "Individual agents are choosing to be ethnocentric" — trait is inherited/mutated, not chosen
   within an agent's lifetime (this model has no imitation or learning mechanism at all).

## Connections to Other Models

- **evolution-resource-use-social-behavior** — the strongest same-mechanism comparison in this
  entire set: both models' own documentation names kin selection, multilevel selection, and
  frequency-dependent selection explicitly, via two different concrete mechanisms (ethnic-marker-
  based assortment here; resource-monitoring/punishment there).
- **island-world** — a third route to positive assortment (spatial isolation/founder effects rather
  than ethnic marking or direct sanctioning); useful three-way comparison across this set.
- **evolution-resource-use-behavior-imitation** — adds the cultural-transmission mechanism this
  model explicitly lacks; useful for the Common Misconceptions #1 discussion above.
- **two-communities** (out of scope for this pass, already an "in progress" strand) — literal
  "communities" framing without ethnicity markers or an evolutionary mechanism; a direct
  cross-model comparison worth writing up as extended-learning material per this folder's README.

## References

- Axelrod, R., & Hammond, R. A. (2003). The evolution of ethnocentric behavior. *Midwest Political
  Science Convention*, April 3-6, 2003, Chicago, USA.
- Hammond, R. A., & Axelrod, R. (2006). The evolution of ethnocentrism. *Journal of Conflict
  Resolution*, 50(6), 926-936. https://doi.org/10.1177/0022002706293470
- Hamilton, W. D. (1964). The genetical evolution of social behaviour. *Journal of Theoretical
  Biology*, 7(1), 1-16. (kin-selection foundation; not yet a LiteratureBase `lit:` record as far as
  this pass checked)
- Wilson, D. S., & Wilson, E. O. (2007). Rethinking the theoretical foundation of sociobiology.
  *The Quarterly Review of Biology*, 82(4), 327-348. (multilevel-selection foundation; not yet a
  LiteratureBase `lit:` record as far as this pass checked)
- Hanisch, S. (2022). Ethnocentrism with customizable payoff matrix. OpenEvo NetLogo Models.
  https://openevo.eva.mpg.de/teachingbase/netlogo/, adapted from Wilensky, U. (2003). NetLogo
  Ethnocentrism model. http://ccl.northwestern.edu/netlogo/models/Ethnocentrism.

## Schema-Ready Contribution

**Not done.** A formal LPM contribution to ConceptBase, validated against its real `lpm.schema.yaml`, is the
natural next step for this strand, not claimed here.

---

**Status:** In progress — grade-band/content-anchor/international-grounding/competency/assessment
drafted 2026-08-29; schema contribution (step 5) pending.
