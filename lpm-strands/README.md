# LPM strands for the NetLogo model collection

> **⚠️ DRAFT CONCEPT — every strand in this folder.** These strands are synthesized by an LLM
> across the NetLogo and OpenEvo CCS ecosystem's existing materials (ConceptBase, model-card.json
> structural data, prior human-authored drafts). **They have not been validated by expert review
> or empirical classroom testing.** Treat them as a starting point for research and
> policy-development discussion — not as vetted curriculum ready for classroom deployment. This
> applies to every strand file here, current and future, regardless of its own "in progress" /
> "complete" status label, which describes how developed the draft is, not whether it's been
> validated.

This folder is the working space for developing **Learning Progression Map (LPM) strands** tied
to each model in [`models/`](../models/) — the sequences of learning objectives, across grade
bands, that use a given NetLogo model as its computational anchor.

Each model has a placeholder strand file (`<model-slug>.md`) linked from its
`models/<slug>/README.md` and `metadata.json`. Right now these are stubs. Turning one into a real
strand means answering, for that model:

1. **Grade-band progression** — what does understanding the model's core phenomenon look like at
   each grade band it targets, and what's the throughline between them?
2. **Content anchor + thinking tool alignment** — which of OpenEvo's nine content anchors and six
   thinking tools does the strand draw on (see the `content-anchor-mapper` and `thinking-tools-kit`
   skills)?
3. **Competency alignment** — which ConceptBase competencies does the strand build toward?
4. **Assessment** — does an integrated-causal-reasoning assessment item bank exist or need building
   for this model's phenomenon (see the `integrated-causal-reasoning-assessment` skill)?
5. **Schema-ready contribution** — once a strand is solid, it should be authored against
   ConceptBase's real LPM schema (see the `oecb-schema-authoring` skill) so it can be proposed back to
   [ConceptBase](https://github.com/openevo-ccs/conceptbase) as an actual LPMR contribution rather
   than living only as prose here.

This 5-step process is now operationalized end to end by the
`netlogo-lpm-integrator` agent (and its underlying
`skills/netlogo-lpm-integration`) in the sibling
`curriculum-agents` repo (private, not publicly linkable)
— it looks up real competencies against ConceptBase, hands off to
`content-anchor-mapper`/`thinking-tools-kit` for step 2, and produces a
schema-ready contribution via `oecb-schema-authoring` for step 5, rather
than each strand being written from scratch.

**2026-08-29 pass**: run against the 8 evolution-themed models below (bug-evolution,
island-world, evolution-competition-forest-resources, evolution-competition-resources-abstract,
evolution-resource-use-harvest-efficiency, evolution-resource-use-social-behavior,
evolution-resource-use-behavior-imitation, evolution-ethnocentrism), adding step 2/3 real
**international curriculum grounding** — US NGSS Disciplinary Core Ideas/performance expectations
and real Sachsen (Saxony, Germany) Gymnasium Biologie Lernziel/Kompetenz entries (from
`EvoMentor/importers/fwu_sn_fine_grained_candidates.json`, a genuine FWU MEM SPARQL-sourced
dataset never previously used to ground any strand) — alongside the existing internal
OpenEvo/ConceptBase competency alignment, which stays separate. Step 5 (schema-ready contribution)
remains not done for all 8. The other 6 models (two-foresters, two-communities,
population-size-living-costs, swarming, virus-epidemic, wolves-sheep-grass) were out of scope for
this pass and are unchanged.

**2026-08-29 pass (commons-dilemma models)**: a second pass the same day, run against the 3
commons-dilemma models (two-foresters, two-communities, population-size-living-costs), following
the same International Curriculum Grounding pattern as the pass above but with different real
sources: US NGSS Earth/Human-Activity DCIs (HS-ESS3-3/4, MS-ESS3-3/4) and a candidate reading of
real Sachsen Gymnasium Gemeinschaftskunde/Rechtserziehung/Wirtschaft (G/R/W) Lehrplan content from
the sibling `deutsche_lp` repo's `docs/2026-08-25-sachsen-grw-latent-connections-pilot.md` — a
`latent-connection-record` pilot whose `status: candidate` connections are explicitly flagged as a
proposed pedagogical reading of real curriculum content, not an official curriculum equivalence
(a genuinely weaker evidentiary claim than the first pass's Sachsen Biologie Lernziele, which are
directly-stated curriculum content). This pass also closed a real LiteratureBase gap: 5 new
DOI-verified commons-dilemma records (Hardin 1968, Ostrom 1990, Basurto & Ostrom 2009, Wilson,
Ostrom & Cox 2013, Powers 1986) were added and are now cited directly in all 3 strands, closing the
loop with the graph explorer's `assets/literature-links.json`, which already linked them to these
models' concept tags with no supporting strand text. `population-size-living-costs.md` was also
built out fully from its prior stub this pass — grade-band progression, content-anchor/thinking-
tool alignment, competency alignment, and a brand-new 5-item assessment item bank
(`assessments/population-size-living-costs.json`), grounded in the model's own documented
mechanics rather than an executed run (flagged honestly in that strand's Assessment section). Step
5 (schema-ready contribution) remains not done for all 3.

**2026-09-01 pass (BeeSmart Hive Finding, the 15th model)**: this model was ported into the
collection specifically because it fills a gap the sibling `bee-k12` repo's own six-strand K-12 bee
curriculum had already identified in its own Strand A (`OE-STRAND-000615`, "How the Message Gets
Around," currently a diagram-only performance indicator this model runs for real) and Strand D
(`OE-STRAND-000647`, whose `computational-agent-based-models` thinking tool is still `status: draft`
there). This pass builds `beesmart-hive-finding.md` from scratch — grade-band progression (9-12/
Undergraduate only, per the model's own stated audience), content-anchor/thinking-tool alignment, a
light International Curriculum Grounding note (real NGSS HS-LS2-8 match; the Sachsen FWU MEM dataset
that grounded the two passes above is scoped to evolution/commons content and wasn't searched for
this model's quorum-sensing phenomenon, flagged as a gap rather than skipped silently), and a new
5-item assessment item bank (`assessments/beesmart-hive-finding.json`). Competency alignment draws on
two real sources: ConceptBase concepts (the pattern the other 11 strands use) **and**, newly, real
CompetencyBase competency records (`competencybase/records/*.yaml`) — `OE-COMPETENCY-openevo-core-
competencies-dcr-comp` (Decentralized Causal Reasoning: Computational Systems) is an unusually
precise match, its own 9-12 developmental band naming "a scripted path vs. a swarm/ant-colony-
optimization approach" as a worked comparison. A real TheoryBase gap was also surfaced (not fixed):
`OE-CROSSDOMAINCONSTRUCT-decentralized-causal-reasoning-domain-generality` currently names only
`ecological-evolutionary` and `cognitive-self` domains, with no `computational` domain despite
CompetencyBase's `dcr-comp` record already instantiating exactly that. The model itself has **not**
been click-through tested in a live browser (no `tools/netlogo-mcp` install was available when it
was ported or when this strand was built) — flagged repeatedly in the strand rather than glossed
over. Step 5 (schema-ready contribution) is not done.

## Status

| Model | Strand status |
|---|---|
| [Two Foresters](../models/two-foresters/) | in progress — grade-band/content-anchor/international-grounding/competency/assessment drafted, schema contribution pending — [strand](two-foresters.md) |
| [Two Communities](../models/two-communities/) | in progress — grade-band/content-anchor/international-grounding/competency/assessment drafted, schema contribution pending — [strand](two-communities.md) |
| [Population Size and Living Costs](../models/population-size-living-costs/) | in progress — grade-band/content-anchor/international-grounding/competency/assessment (new item bank) drafted, schema contribution pending — [strand](population-size-living-costs.md) |
| [Evolution and Competition for Forest Resources](../models/evolution-competition-forest-resources/) | in progress — grade-band/content-anchor/international-grounding/competency drafted, assessment item bank + schema contribution pending — [strand](evolution-competition-forest-resources.md) |
| [Evolution and Competition for Resources (Abstract)](../models/evolution-competition-resources-abstract/) | in progress — grade-band/content-anchor/international-grounding/competency drafted, assessment item bank + schema contribution pending — [strand](evolution-competition-resources-abstract.md) |
| [Evolution of Resource Use with Harvest Efficiency](../models/evolution-resource-use-harvest-efficiency/) | in progress — grade-band/content-anchor/international-grounding/competency drafted, assessment item bank + schema contribution pending — [strand](evolution-resource-use-harvest-efficiency.md) |
| [Evolution of Resource Use and Social Behavior](../models/evolution-resource-use-social-behavior/) | in progress — grade-band/content-anchor/international-grounding/competency drafted, assessment item bank + schema contribution pending — [strand](evolution-resource-use-social-behavior.md) |
| [Evolution of Resource Use Through Behavior Imitation](../models/evolution-resource-use-behavior-imitation/) | in progress — grade-band/content-anchor/international-grounding/competency drafted, assessment item bank + schema contribution pending — [strand](evolution-resource-use-behavior-imitation.md) |
| [Island World](../models/island-world/) | in progress — grade-band/content-anchor/international-grounding/competency/assessment (existing item bank) drafted, schema contribution pending — [strand](island-world.md) |
| [Evolution of Ethnocentrism](../models/evolution-ethnocentrism/) | in progress — grade-band/content-anchor/international-grounding/competency/assessment (existing item bank) drafted, schema contribution pending — [strand](evolution-ethnocentrism.md) |
| [Bug Evolution](../models/bug-evolution/) | in progress — grade-band/content-anchor/international-grounding/competency/assessment drafted, schema contribution pending — [strand](bug-evolution.md) |
| [BeeSmart Hive Finding](../models/beesmart-hive-finding/) | in progress — grade-band/content-anchor/competency (ConceptBase + CompetencyBase)/assessment (new item bank) drafted, light international grounding, schema contribution pending; model itself not yet click-through tested — [strand](beesmart-hive-finding.md) |
| [Swarming](../models/swarming/) | not started — [stub](swarming.md) |
| [Virus Epidemic](../models/virus-epidemic/) | not started — [stub](virus-epidemic.md) |
| [Wolves-Sheep-Grass](../models/wolves-sheep-grass/) | not started — [stub](wolves-sheep-grass.md) |

## The evolution/commons-dilemma split isn't as real as it looks

The two 2026-08-29 passes above treated "evolution-themed" and "commons-dilemma-themed" as two
separate clusters of models. They aren't, structurally — `evolution-resource-use-social-behavior`
carries concept tags from both (`Common pool resources`, `Multilevel selection`), and
Wilson, Ostrom & Cox (2013) got cited independently by both passes as secondary support, without
either pass noticing the other's use of it. A real network-theory test of this (modularity +
betweenness centrality on this collection's own concept/literature graph, computed 2026-08-29) 
confirms it quantitatively: partitioning the 14 models by the two disciplinary labels above
explains less of the graph's actual structure (Q=0.26) than an unsupervised read of the same graph
does (Q=0.49), and the two partitions disagree about which models belong together. See
[`ccs-graph`'s `rel:modularity--netlogo-lpm-coherence--meso--001`](https://github.com/openevo-ccs/ccs-graph/blob/main/edges/modularity--netlogo-lpm-coherence--meso--001.yaml)
for the full worked finding, including a controlled comparison against the `bio-core-k12`/
`oe-interdisciplinary-k12` synthetic pair (a genuinely surprising result there, reported honestly
rather than smoothed over — see that record's own "extended" description).

## Extended learning

This is also the place for **extended-learning material** that goes beyond a single model: cross-
model comparisons (e.g. contrasting *Two Foresters* vs. *Two Communities* as private vs. commons
resource framings), multi-model unit sequences, or bridges to the standard NetLogo Models Library.
Add new `.md` files here as that work starts — there's no fixed schema yet for extended-learning
docs, so use judgment and cross-link to the models involved.
