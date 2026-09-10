# LPM Strand: Evolution of Resource Use and Social Behavior (Monitoring and Punishment)

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment
> (including a new International Curriculum Grounding section, US NGSS + Sachsen Gymnasium
> Biologie), competency alignment, and assessment status are drafted below (2026-08-29). Step 5
> (a formal, schema-validated ConceptBase LPM contribution) is not done. This model already has real
> teaching materials in preparation per `metadata.json` — this strand builds the LPM layer, not a
> replacement for those.

## Model
- [Run the model](../models/evolution-resource-use-social-behavior/app.html)
- [Model metadata](../models/evolution-resource-use-social-behavior/metadata.json)
- [Download .nlogo](../models/evolution-resource-use-social-behavior/model.nlogo)

## Overview

This model layers a **second evolving trait** on top of the familiar sustainable/greedy harvest
trait: whether an agent is a **punisher** — able to perceive greedy neighbors (`Perception-accuracy`)
and impose a cost on them (`Punishment`: kill / suspend harvest once / pay a shared fine). Both
perceiving and punishing cost the punisher energy (`Costs-perception`, `Costs-punishment`), so
punishing is itself an **altruistic** trait: it benefits the group (by suppressing greedy
harvesting) at a direct cost to the individual punisher. The model's own `info_sections` text
names the mechanism explicitly: *"Concepts like kin selection, frequency-dependent selection,
multi-level selection play a role in the outcomes that are observed."* Because agents place
offspring on neighboring patches and rarely move unless local resources are gone, clusters of
related agents form — this spatial clustering is what lets altruistic punishment persist against
the individual cost of paying it (the same positive-assortment logic as `island-world`, via a
completely different mechanism: direct sanctioning rather than spatial isolation).

## Grade-Band Progression

### Grades 9-12: Monitoring, Punishment, and the Evolution of Altruism

**Learning Objectives:**
- Identify the two independently evolving traits (harvest preference, punisher ability) and
  explain why the model tracks four combined types (sustainable-punisher, sustainable-non-punisher,
  greedy-punisher, greedy-non-punisher) rather than just two.
- Explain why punishing is a genuinely costly (altruistic) behavior in this model, using the actual
  parameters (`Costs-perception`, `Costs-punishment`) — not just asserting "punishment is good for
  the group" without the cost side.
- Analyze how `Minimum-punishers` (the coordination threshold before punishers will act) changes
  outcomes — this is the model's built-in test of whether punishment needs to be coordinated to be
  viable.
- Connect the persistence of altruistic punishment to spatial clustering (offspring placed on
  neighboring patches), and compare this mechanism to `island-world`'s founder-effect/isolation
  route to the same kind of outcome.

**Key Concepts:** Altruism; monitoring and sanctioning; kin selection; multilevel selection;
frequency-dependent selection; common-pool resource governance (Ostrom-style institutions, made
concrete and manipulable).

**Activities:**
1. Run the model with `Percent-Punishers` at 0% (no punishment possible) vs. 20% and compare final
   trait frequencies and forest-stock-equivalent (resource) outcomes.
2. Vary `Punishment` between "kill," "suspend harvest once," and "pay fine" holding other
   parameters fixed, and compare how harsh vs. mild sanctions change the population's evolved
   composition.
3. Vary `Minimum-punishers` from 1 to 9 and observe whether coordinated punishment (higher
   threshold) changes outcomes compared to unilateral punishment (threshold of 1).
4. Use Payoff Matrices to lay out, for a single interaction, the energy cost/benefit to a punisher
   who does vs. doesn't act on a detected greedy neighbor.

**Assessment Indicators:** Correctly names all four evolving type-combinations and explains why
punishing is costly using the model's actual cost parameters; connects `Minimum-punishers` to
coordination requirements for altruism to persist; distinguishes this model's clustering-based
mechanism from island-world's isolation-based one.

### Undergraduate: Multilevel Selection Theory Applied to Institutional Design

**Learning Objectives:**
- State formally how kin selection, frequency-dependent selection, and multilevel selection each
  contribute to this model's outcome, using the model's own stated mechanism as a starting text.
- Evaluate the three punishment types (kill, suspend, fine) as different institutional designs
  with different real-world analogues (exclusion, temporary suspension of rights, monetary
  sanction) and discuss real-world common-pool-resource governance systems (Ostrom's design
  principles) that use analogous mechanisms.
- Critically evaluate the model's assumptions: perception is imperfect but not strategic
  (punishers don't choose whom to punish based on relatedness, only on detected behavior);
  punishment costs are shared among punishers but not adjusted for free-riding among punishers
  themselves (a second-order cooperation problem the model does not model explicitly).

**Key Concepts:** Multilevel selection theory; Ostrom's commons-governance design principles;
second-order free-riding (the problem of who punishes the non-punishers); model scope and limits.

**Activities:**
1. Design a BehaviorSpace experiment varying `Percent-Punishers` × `Minimum-punishers` and test
   whether there's a minimum coordination threshold below which altruistic punishment cannot
   invade a greedy-dominated population.
2. Read a short summary of Ostrom's design principles for commons governance and map each of this
   model's mechanisms (harvest limits, monitoring, graduated sanctions) onto the corresponding
   principle.
3. Discuss the second-order free-rider problem explicitly: this model doesn't let agents evolve a
   trait for "punish non-punishers" — what would need to be added, and would you predict it
   changes the outcome?

**Assessment Indicators:** Uses kin selection / frequency-dependent selection / multilevel
selection correctly and distinctly (not as interchangeable synonyms); maps model mechanisms to
real institutional-design principles with specific correspondences; identifies the second-order
free-rider gap as a genuine model limitation, not a flaw to paper over.

## Content Anchor Alignment

**Primary:**
1. **Governing the Commons** — this is the most direct, Ostrom-style commons-governance model in
   the entire evolution set: monitoring, sanctioning, and coordination thresholds are all
   literally the interface's sliders.
2. **Cooperation Games** — altruistic punishment is a canonical second-order cooperation problem;
   the model's cost/benefit structure is directly payoff-matrix-analyzable.

**Secondary:**
3. **Computer Models** — manipulating punishment type and coordination threshold directly.
4. **Global Sustainability Goals** — monitoring and sanctioning as real sustainable-resource-
   governance mechanisms (SDG 16 institutions, SDG 15 life on land).

## Thinking Tool Integration

1. **Payoff Matrices** — the model's own cost parameters (`Costs-perception`, `Costs-punishment`,
   `Fine`) give real numbers for a payoff matrix of punisher vs. non-punisher, greedy vs.
   sustainable; name the structural type (this is close to a second-order public-goods game, not a
   simple prisoner's dilemma).
2. **Causal Mapping** — map: greedy harvesting → detection (at `Perception-accuracy`) → punishment
   (at `Minimum-punishers` threshold) → reduced greedy fitness → trait-frequency shift; separately
   map the punisher's own cost loop (perception cost + punishment cost → reduced punisher energy).
3. **Structure of Knowledge Diagrams** — facts (a punisher loses energy for perceiving and
   punishing) → concepts (altruism, kin selection, multilevel selection) → principle (altruistic
   traits can be favored by selection when interaction is non-random, e.g. spatially clustered
   relatives) — this is the strand where the model's own documentation text can be used almost
   directly as the SoK's top layer.

## International Curriculum Grounding

Real, citation-grounded — distinct from the OpenEvo/ConceptBase competency alignment below.

**US — NGSS.**
- **HS-LS2-8** (LS2.D, Social Interactions and Group Behavior) — "evaluate the evidence for the
  role of group behavior on individual and species' chances to survive and reproduce." This is the
  single best-fitting NGSS performance expectation across this entire eight-model set: punishing
  and being punished are literally group-behavior mechanisms whose fitness consequences the model
  makes directly observable.
- **HS-LS4-2** (LS4.B, Natural Selection) — the underlying four-factor selection account, applied
  here to a two-trait (harvest + punisher) system.
- **HS-LS2-1** (LS2.A) — carrying capacity / resource-population dynamics, as in the sibling
  resource models.

**Germany — Sachsen Gymnasium Biologie** (from `EvoMentor/importers/fwu_sn_fine_grained_candidates.json`;
coverage status `fine-grained-content-staged-untagged` — **grade band unspecified in the current
staged data**):

- *"Zusammenwirken von Mutation, Rekombination, Selektion und Isolation..."* —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-7649-1` (also `-7649-2`).
- Supplementary real entries from the same Gymnasium Biologie document, found via a broader term
  search (not the "evolution" label filter): *"Kennen von Methoden und Bedeutung der
  Verhaltensbiologie"* (knowing the methods and significance of behavioral biology) —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-8099-1` (also `-7838-1`, `-8099-2`);
  *"Kennen proximater Ursachen des Verhaltens als Folge des Zusammenwirkens von Genen und
  Umweltfaktoren"* (knowing proximate causes of behavior as an interaction of genes and
  environment) — `-7839-1`; *"Kennen ultimater Ursachen des Verhaltens"* (knowing ultimate causes
  of behavior) — `-7845-1`. The proximate/ultimate distinction maps directly onto this model's two
  levels of explanation: the proximate mechanism (perception accuracy, punishment type) and the
  ultimate/evolutionary explanation (why altruistic punishment can be favored by selection at all).
  *"Tierstaat als sozialer Verband am Beispiel der Honigbiene"* (the animal state as a social
  union, using the honeybee as an example) — `-7256-1`/`-7256-2` — a real, if imperfect, analogue
  for this model's cost-sharing, group-benefiting altruistic behavior (eusociality is a much
  stronger form of the same underlying logic).

**Gap flagged, and directly relevant here**: this model's own documentation names "kin selection,"
"multi-level selection," and "frequency-dependent selection" as the mechanisms behind its
outcomes — but **none of the three** exist as concepts in ConceptBase main. All three exist as
*proposed, unmerged* entries in the `extend-bio-core-evolution-mechanisms` branch of the
`conceptbase` repo (verified this pass; no PR opened): `OE-CONCEPT-000126` (Kin Selection),
`OE-CONCEPT-000125` (Multilevel Selection), `OE-CONCEPT-000121` (Frequency-Dependent Selection),
all `BIO-CORE-v1.2.0`. This is the strand in this set where that gap matters most, since the model
literally cannot be fully competency-tagged against ConceptBase main without them.

## Competency Alignment

Verified against the real ConceptBase registry (`d:/dev/openevo-ccs-lab/conceptbase/registry/concept/`,
2026-08-29):

- **OE-CONCEPT-oe-interdisciplinary-cooperation (Cooperation, OE-INTERDISCIPLINARY-v1.0.0)** —
  performance indicator: explain how a costly individual behavior (punishing) can produce a group
  benefit (sustainable resource use).
- **OE-CONCEPT-bio-core-natural-selection (Natural Selection, BIO-CORE-v1.0.0)**.
- **OE-CONCEPT-bio-core-fitness (Fitness, BIO-CORE-v1.0.0)** — energy cost of perception/punishment
  as a direct fitness cost.
- **OE-CONCEPT-oe-interdisciplinary-institutions (Institutions, OE-INTERDISCIPLINARY-v1.0.0)** —
  the punishment mechanism itself as an evolving informal institution; performance indicator: map
  `Punishment` chooser values to real institutional-sanction types.
- **OE-CONCEPT-oe-interdisciplinary-norms (Norms, OE-INTERDISCIPLINARY-v1.0.0)** — sustainable
  harvesting as an enforced behavioral norm once punishers are common enough.

**Not yet in ConceptBase**: Kin Selection, Multilevel Selection, Frequency-Dependent Selection —
all named directly by this model's own documentation (see gap note above).

## Assessment

**No assessment file exists yet** for this model. Needs building.

**Vignette sketch, grounded in the actual model**: "You ran the model with `Percent-Punishers` at
20%, `Punishment` set to 'suspend harvest once,' and `Minimum-punishers` at 1 (unilateral
punishment allowed). Sustainable-punisher agents spread to dominate the population by tick 800. You
then reran with everything the same except `Minimum-punishers` at 5 (punishers must coordinate),
and greedy agents dominated instead. A classmate says 'punishment either works or it doesn't — the
second run just shows punishment doesn't work.' Using the model's actual mechanism, explain what
`Minimum-punishers` controls and why raising it could flip the outcome." — targets the
misconception that a mechanism's *effectiveness* is a fixed yes/no property rather than something
that depends on a specific coordination parameter.

## Common Misconceptions

1. "Punishment is automatically good for the group, so it should always spread" — punishing is
   individually costly; whether it spreads depends on spatial clustering, coordination threshold,
   and punishment type, not on the group-benefit alone.
2. "Kin selection, multilevel selection, and frequency-dependent selection are the same thing" —
   they are related but distinct mechanisms; this model's documentation invokes all three
   together, but a careful analysis should be able to say which is doing what work under which
   parameter settings.
3. "Agents choose to punish because it's the right thing to do" — punisher status is an inherited,
   mutating trait, not a moral choice made within the model.
4. "A model with no punishers proves punishment doesn't matter" — compare directly to the
   `Percent-Punishers = 0` control run rather than assuming.

## Connections to Other Models

- **island-world** — a completely different route (spatial isolation/founder effects, not direct
  sanctioning) to the same kind of altruism-can-persist outcome; both models' own documentation
  names multilevel selection explicitly. The strongest same-mechanism-different-route comparison
  in this set.
- **evolution-competition-forest-resources** — the same commons dilemma with the punishment/
  monitoring mechanism entirely absent; the direct "what does adding an institution change"
  A/B comparison.
- **evolution-ethnocentrism** — also invokes kin selection and frequency-dependent selection
  explicitly in its own documentation, via a different mechanism (ethnic-marker-based assortment
  rather than resource-monitoring); useful cross-model comparison of routes to positive assortment.
- **two-communities** (out of scope for this pass, already an "in progress" strand) — commons
  cooperation without the evolutionary/reproduction mechanism.

## References

- Hanisch, S. (2022). Evolution, resources, monitoring and punishment. OpenEvo NetLogo Models.
  https://openevo.eva.mpg.de/teachingbase/netlogo/
- Ostrom, E. (1990). *Governing the Commons: The Evolution of Institutions for Collective Action*.
  Cambridge University Press. (real, well-known source for the design-principles activity; not
  yet a LiteratureBase `lit:` record as far as this pass checked)

## Schema-Ready Contribution

**Not done.** A formal LPM contribution to ConceptBase, validated against its real `lpm.schema.yaml`, is the
natural next step for this strand, not claimed here.

---

**Status:** In progress — grade-band/content-anchor/international-grounding/competency drafted
2026-08-29; assessment item bank and schema contribution (steps 4-5) still pending.
