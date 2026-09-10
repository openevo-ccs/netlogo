# LPM Strand: Island World

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> Status: **In progress** — grade-band progression, content-anchor/thinking-tool alignment
> (including a new International Curriculum Grounding section, US NGSS + Sachsen Gymnasium
> Biologie), competency alignment, and assessment status are drafted below (2026-08-29). Step 5
> (a formal, schema-validated ConceptBase LPM contribution) is not done.

## Model
- [Run the model](../models/island-world/app.html)
- [Model metadata](../models/island-world/metadata.json)
- [Download .nlogo](../models/island-world/model.nlogo)

## Overview

Foragers move between spatially separated resource areas ("islands" of food-rich patches
surrounded by empty space), harvest, reproduce, and die. Offspring inherit a harvest-type trait
(sustainable/green vs. greedy/red) with a chance of mutation (`Mutation-rate`). Because agents can
only sense resources within a 2-patch radius and migrate when their local area is depleted, the
population splits into semi-isolated subgroups whose trait frequencies can diverge — this is
**multilevel selection** made observable: greedy agents out-compete sustainable ones *within* a
subgroup, but subgroups of exclusively sustainable agents persist longer and can recolonize
depleted areas, so the *between-group* selection pressure runs the opposite direction from the
*within-group* one. `Distance-Resource-Areas` and `Size-Resource-Areas` directly control how
isolated the islands are, letting students manipulate the isolation variable rather than just be
told what isolation does.

## Grade-Band Progression

### Grades 9-12: Migration, Isolation, and Multilevel Selection

**Learning Objectives:**
- Describe how spatial structure (separate resource "islands") changes which individuals compete
  with which others.
- Distinguish within-group selection (greedy beats sustainable locally) from between-group
  selection (sustainable subgroups persist, greedy subgroups can deplete their area and collapse).
- Explain founder effects: a new island colonized by a small group can end up with a different
  trait frequency than the source population, by chance alone.
- Avoid the misconception that isolation always leads to "better adapted" or "improved" traits —
  it leads to *divergence*, not improvement.

**Key Concepts:** Trait variation, differential survival, migration, founder effect, isolation,
multilevel/group selection, carrying capacity.

**Activities:**
1. Run the model with `Distance-Resource-Areas` low (islands close together, high migration) vs.
   high (islands far apart, low migration) and compare how much trait frequencies diverge between
   islands over time.
2. Set `Percent-Sustainables` low (e.g. 10%) and run multiple times — observe that some runs the
   sustainable trait dies out everywhere, others it survives on one island by chance. This is the
   founder-effect/stochasticity lesson, not a deterministic outcome.
3. Use the "Trait frequencies (global, %)" and "Average Energy of Agents" plots to distinguish
   what's happening *within* the population from what the *aggregate* looks like.
4. Discuss: why does a locally-disadvantageous trait (sustainable harvesting: 50% harvest vs.
   greedy's 99%) ever spread in the *total* population? (Because greedy sub-populations can
   deplete their island and go extinct locally, while sustainable sub-populations don't.)

**Assessment Indicators:** Distinguishes within-group from between-group selection; explains
founder effects as chance-driven, not merit-driven; connects `Distance-Resource-Areas` to observed
divergence; avoids "isolation makes organisms better" framing.

### Undergraduate: Multilevel Selection Theory and Its Applications

**Learning Objectives:**
- State multilevel selection theory formally: selection can act at multiple levels of
  organization (individual, subgroup, population) simultaneously and in different directions.
- Analyze the model's own explanation (`info_sections["Concepts and Principles"]`) of how
  altruistic/cooperative traits (like sustainable harvesting) can spread despite an individual
  fitness cost, and connect this to Pepper & Smuts (2001, 2002) — the model's cited source.
- Evaluate the model's assumptions: no active dispersal strategy, no kin recognition, migration is
  reactive (only when local resources are depleted) rather than anticipatory.
- Connect to human evolutionary history (population structure, migration, and isolation in human
  dispersal out of Africa) and to pathogen virulence evolution (both named in the model's own
  `metadata.json` description) — without overclaiming this abstract resource model as a literal
  simulation of either.

**Key Concepts:** Multilevel selection theory; positive assortment; group extinction/
recolonization; model validation and scope limits.

**Activities:**
1. Design a BehaviorSpace experiment varying `Distance-Resource-Areas` × `Percent-Sustainables` ×
   `Mutation-rate` and test whether global sustainable-trait frequency is predictable from
   isolation distance alone, or whether stochastic founder effects dominate at low sample sizes.
2. Read Pepper & Smuts (2001, 2002) alongside the model and identify which of the paper's
   mechanisms the model implements vs. simplifies away.
3. Write a short evaluation of what this model can and cannot tell us about human migration
   history or virulence evolution, given what it actually simulates (resource competition with
   two discrete harvest types) vs. what those real phenomena involve.

**Assessment Indicators:** States multilevel selection formally and correctly; connects model
mechanics to Pepper & Smuts; identifies specific model simplifications rather than treating the
model as a literal proxy for human history or virulence evolution.

## Content Anchor Alignment

**Primary:**
1. **Computer Models** — the model's own text explicitly names multilevel selection as an
   emergent property of its spatial structure; manipulating `Distance-Resource-Areas` lets a
   student control the isolation variable directly rather than being told what isolation does.
2. **Cross-Species Comparisons** — island biogeography classics (Darwin's finches, Hawaiian
   honeycreepers) as real-world analogues of the model's isolated-subpopulation dynamic.

**Secondary:**
3. **Ancient Ancestors** — the model's own description explicitly extends to human evolutionary
   history (migration, founder effects in human dispersal); use carefully — the model is an
   abstraction, not a simulation of any specific human migration event.
4. **Global Sustainability Goals** — the model's central finding (sustainable resource use can
   persist at the population level even when it's locally disadvantageous, via group-level
   extinction/recolonization) is a real conservation-biology and commons-management insight.

## Thinking Tool Integration

1. **Causal Mapping** — map the loop: local resource depletion → agent migration → new island
   colonized → local trait frequency (founder effect) → within-island selection → possible local
   extinction → repopulation of empty islands. Look explicitly for the loop where a subgroup's own
   overharvesting causes its own local extinction (a delayed negative feedback).
2. **Structure of Knowledge Diagrams** — facts (individual harvest choice) → concepts (trait
   frequency, carrying capacity) → principles (multilevel selection, migration-selection balance).
3. **Analogies & Analogy Mapping** — map island-world's food patches ↔ real islands, migration ↔
   dispersal, founder effect ↔ real colonization events (Darwin's finches); explicitly name where
   it breaks down (real islands have far richer environmental variation than this model's
   resource-area/no-resource-area binary).

## International Curriculum Grounding

Real, citation-grounded — distinct from the OpenEvo/ConceptBase competency alignment below.

**US — NGSS.**
- **HS-LS4-2** — evolution results from population growth potential, heritable variation,
  competition for limited resources, and differential survival/reproduction. All four factors are
  explicit model mechanics (`Reproduction?`, `Mutation-rate`, shared food patches, differential
  energy accumulation).
- **HS-LS4-5** (LS4.C, Adaptation) — "changes in environmental conditions may result in..."
  changes in species distribution. Direct match: `Distance-Resource-Areas` and
  `Size-Resource-Areas` are exactly the environmental-condition variables the model lets a student
  change and observe consequences of.
- **HS-LS2-1** (LS2.A, Interdependent Relationships in Ecosystems) — "mathematical and/or
  computational representations to support explanations of factors that affect carrying capacity
  of ecosystems at different scales" — "different scales" maps directly onto this model's
  within-island vs. total-population scales.
- **HS-LS4-6** (LS4.D, Biodiversity and Humans) — "create or revise a simulation to test a
  solution to mitigate adverse effects of human activity on biodiversity" — this model itself is
  such a simulation (of sustainable vs. unsustainable resource use), making it a candidate
  vehicle for this specific performance expectation, not just an evolution-content model.

**Germany — Sachsen Gymnasium Biologie** (from `EvoMentor/importers/fwu_sn_fine_grained_candidates.json`;
coverage status `fine-grained-content-staged-untagged` per
`deutsche_lp/land/sachsen/lp/records/crosswalk.yaml` — **grade band unspecified in the current
staged data**):

- *"Zusammenwirken von Mutation, Rekombination, Selektion und Isolation als ausgewählte Faktoren
  der Synthetischen Evolutionstheorie"* —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-7649-1` (also `-7649-2`). This is this
  model's single strongest curriculum match of the whole eight-model set: **Isolation** is named
  explicitly alongside mutation and selection as a factor of the Synthetic Theory, and isolation
  is exactly what `Distance-Resource-Areas` and `Size-Resource-Areas` let a student manipulate.
- *"Kennen von Prinzipien der Evolution von Organismen"* —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-7646-1` (also `-7646-2`).
- Supplementary (same Gymnasium Biologie document, real entries, found via a broader term search
  this pass — not the "evolution"-label filter, but the same staged dataset): *"Parameter und
  Wachstum einer Population"* (parameters and growth of a population) —
  `https://lp-sachsen.org/resource/lernziel-lerninhalt-7970-1` (also `-7970-2`) — matches the
  model's logistic carrying-capacity mechanic; *"Artbegriff, Populationsbegriff"* (species/
  population concept) — `-7648-1`/`-7648-2`.

**Gap flagged**: this strand's central concept — **multilevel selection** — and **founder
effect** are both named explicitly in the model's own `info_sections` text, but neither exists as
a concept in ConceptBase main. Both exist as *proposed, unmerged* entries in the
`extend-bio-core-evolution-mechanisms` branch of the `conceptbase` repo (no PR opened as of this
pass): `OE-CONCEPT-000125` (Multilevel Selection) and `OE-CONCEPT-000124` (Founder Effect), both
`BIO-CORE-v1.2.0`. Treat these as pending, not as citable ConceptBase concepts, until that branch
merges.

## Competency Alignment

Verified against the real ConceptBase registry (`d:/dev/openevo-ccs-lab/conceptbase/registry/concept/`,
2026-08-29):

- **OE-CONCEPT-bio-core-natural-selection (Natural Selection, BIO-CORE-v1.0.0)** — within-island
  selection of greedy over sustainable agents; performance indicator: explain why a trait can be
  favored locally while disfavored globally.
- **OE-CONCEPT-bio-core-population (Population, BIO-CORE-v1.0.0)** — the model's subgroup
  structure; performance indicator: distinguish a subpopulation (one island) from the total
  population.
- **OE-CONCEPT-bio-core-adaptation (Adaptation, BIO-CORE-v1.0.0)** — sustainable harvesting as
  context-dependent adaptation; performance indicator: explain why the "better" trait depends on
  whether you're looking within or between islands.
- **OE-CONCEPT-oe-interdisciplinary-selection (Selection, OE-INTERDISCIPLINARY-v1.0.0)** — this
  concept's own definition set spans biology and culture; performance indicator: articulate
  selection as differential persistence of variants generally, not only a biology-specific idea.
- **OE-SANDBOX-CONCEPT-000009 (Agent-Based Modeling, OE-INTERDISCIPLINARY-v1.0.0)** — performance
  indicator: describe how a spatial/agent-level rule set (limited sensing radius, reactive
  migration) produces the emergent population-level pattern of trait divergence.

**Not yet in ConceptBase**: Multilevel Selection, Founder Effect, Isolation-as-evolutionary-factor
(see International Curriculum Grounding gap note above).

## Assessment

**Assessment file:** [assessments/island-world.json](../assessments/island-world.json) —
`OE-ASSESS-ISLANDWORLD-001`, a real, already-built 5-item integrated-causal-reasoning assessment
using an "Archipelago" vignette (island mammals, migration, founder effects), scored against
verified real competencies (`OE-CONCEPT-bio-core-natural-selection`,
`OE-CONCEPT-bio-core-adaptation`, `OE-CONCEPT-oe-interdisciplinary-agency`).

**Noted gap, not fixed this pass**: the assessment's vignette is a generic archipelago scenario,
not grounded in an actual run/configuration of *this* model (e.g. "you set
`Distance-Resource-Areas` to 8 and `Percent-Sustainables` to 10%, and after 500 ticks the
sustainable trait had died out on two of three islands but reached 90% on the third — why might
that have happened on that specific island and not the others?"). Strengthening the vignette this
way is flagged as a next step, consistent with the integrated-causal-reasoning-assessment skill's
guidance to ground vignettes in actual model runs, not left undone silently.

## Common Misconceptions

1. "Isolated populations evolve to be better" — isolation causes divergence, not improvement.
2. "A trait that's locally disadvantageous can't spread in the total population" — ignores
   between-group selection and group extinction/recolonization.
3. "Founder effects always predict the outcome" — founder effects are stochastic; the same
   starting conditions can produce different outcomes across runs.
4. "Migration always homogenizes populations" — ignores the balance between migration rate and
   local selection strength (see also the existing `assessments/island-world.json` item IW-004,
   which targets exactly this misconception).

## Connections to Other Models

- **bug-evolution** — compare simple single-population selection to island-world's spatially
  structured, multilevel version.
- **evolution-resource-use-social-behavior** — both invoke multilevel/kin selection explicitly in
  their own model-card text; compare a spatial-isolation mechanism (island-world) to a
  direct-monitoring/punishment mechanism (social-behavior) as two different routes to the same
  cooperation-can-spread outcome.
- **evolution-competition-forest-resources** / **evolution-competition-resources-abstract** — same
  sustainable-vs-greedy harvest-type trait, without the spatial-isolation structure; useful A/B
  comparison for isolating what isolation itself contributes.

## References

- Pepper, J. W., & Smuts, B. (2001). Agent-based modeling of multilevel selection: The evolution
  of feeding restraint as a case study. *Natural Resources and Environmental Issues*, 8, 57-68.
  (cited directly in the model's own `model-card.json`)
- Pepper, J. W., & Smuts, B. B. (2002). A mechanism for the evolution of altruism among nonkin:
  Positive assortment through environmental feedback. *American Naturalist*, 160(2), 205-213.
  https://doi.org/10.1086/341018
- Hanisch, S. (2022). Evolution island world. OpenEvo NetLogo Models.
  https://openevo.eva.mpg.de/teachingbase/netlogo/

## Schema-Ready Contribution

**Not done.** A formal LPM contribution to ConceptBase, validated against its real `lpm.schema.yaml`, is the
natural next step for this strand, not claimed here.

---

**Status:** In progress — grade-band/content-anchor/international-grounding/competency/assessment
drafted 2026-08-29; schema contribution (step 5) pending.
