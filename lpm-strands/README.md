# LPM strands for the NetLogo model collection

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
3. **Competency alignment** — which OECB competencies does the strand build toward (see
   ConceptBase)?
4. **Assessment** — does an integrated-causal-reasoning assessment item bank exist or need building
   for this model's phenomenon (see the `integrated-causal-reasoning-assessment` skill)?
5. **Schema-ready contribution** — once a strand is solid, it should be authored against the real
   OECB LPM schema (see the `oecb-schema-authoring` skill) so it can be proposed back to
   [ConceptBase](https://github.com/openevo-ccs/conceptbase) as an actual LPMR contribution rather
   than living only as prose here.

This 5-step process is now operationalized end to end by the
`netlogo-lpm-integrator` agent (and its underlying
`skills/netlogo-lpm-integration`) in the sibling
[`curriculum-agents`](https://github.com/openevo-ccs/curriculum-agents)
repo — it looks up real competencies against ConceptBase, hands off to
`content-anchor-mapper`/`thinking-tools-kit` for step 2, and produces a
schema-ready contribution via `oecb-schema-authoring` for step 5, rather
than each strand being written from scratch. It hasn't yet been run
against any of the strands below — the status table is still accurate.

## Status

| Model | Strand status |
|---|---|
| [Two Foresters](../models/two-foresters/) | not started — [stub](two-foresters.md) |
| [Two Communities](../models/two-communities/) | not started — [stub](two-communities.md) |
| [Population Size and Living Costs](../models/population-size-living-costs/) | not started — [stub](population-size-living-costs.md) |
| [Evolution and Competition for Forest Resources](../models/evolution-competition-forest-resources/) | not started — [stub](evolution-competition-forest-resources.md) |
| [Evolution and Competition for Resources (Abstract)](../models/evolution-competition-resources-abstract/) | not started — [stub](evolution-competition-resources-abstract.md) |
| [Evolution of Resource Use with Harvest Efficiency](../models/evolution-resource-use-harvest-efficiency/) | not started — [stub](evolution-resource-use-harvest-efficiency.md) |
| [Evolution of Resource Use and Social Behavior](../models/evolution-resource-use-social-behavior/) | not started — [stub](evolution-resource-use-social-behavior.md) |
| [Evolution of Resource Use Through Behavior Imitation](../models/evolution-resource-use-behavior-imitation/) | not started — [stub](evolution-resource-use-behavior-imitation.md) |
| [Island World](../models/island-world/) | not started — [stub](island-world.md) |
| [Evolution of Ethnocentrism](../models/evolution-ethnocentrism/) | not started — [stub](evolution-ethnocentrism.md) |
| [Bug Evolution](../models/bug-evolution/) | not started — [stub](bug-evolution.md) |
| [Swarming](../models/swarming/) | not started — [stub](swarming.md) |
| [Virus Epidemic](../models/virus-epidemic/) | not started — [stub](virus-epidemic.md) |
| [Wolves-Sheep-Grass](../models/wolves-sheep-grass/) | not started — [stub](wolves-sheep-grass.md) |

## Extended learning

This is also the place for **extended-learning material** that goes beyond a single model: cross-
model comparisons (e.g. contrasting *Two Foresters* vs. *Two Communities* as private vs. commons
resource framings), multi-model unit sequences, or bridges to the standard NetLogo Models Library.
Add new `.md` files here as that work starts — there's no fixed schema yet for extended-learning
docs, so use judgment and cross-link to the models involved.
