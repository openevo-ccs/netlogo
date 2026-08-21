# NetLogo Models — OpenEvo CCS Lab

A structured, self-contained collection of the [OpenEvo](https://openevo.eva.mpg.de/) NetLogo
agent-based models — used for teaching evolution, cooperation, and sustainability through
computational modeling — plus a working space for developing **Learning Progression Map (LPM)
strands** and extended learning materials around them.

**Explore the models live:** https://openevo-ccs.github.io/netlogo/

Source content (models, descriptions, teaching-material links) is redistributed from the
[OpenEvo TeachingBase NetLogo collection](https://openevo.eva.mpg.de/teachingbase/netlogo/)
under CC BY-SA — see [LICENSE](LICENSE).

## What's here

```
netlogo/
├── index.html               # GitHub Pages explorer app (model browser + LPM links)
├── assets/                  # explorer app's JS/CSS + generated models.json index
├── models/
│   └── <model-slug>/
│       ├── app.html               # self-contained NetLogo Web HTML export — runs in any browser
│       ├── model.nlogo            # the model's source, extracted from the HTML export —
│       │                          #   open with desktop NetLogo (https://ccl.northwestern.edu/netlogo/)
│       ├── <model-slug>.nlogox    # NetLogo 7 XML export, converted from model.nlogo
│       ├── model-card.json        # full structural decomposition (globals, breeds, procedures +
│       │                          #   call graph, parameters, outputs, controls, info sections)
│       ├── agent-manifest.json    # AI-agent control-surface manifest (sliders/switches/buttons,
│       │                          #   available monitor reporters) — see netlogo-agent-toolkit/
│       ├── metadata.json          # structured metadata: concepts, subjects, grades, links
│       └── README.md
├── netlogo-agent-toolkit/   # generates the three machine-readable files above, for every model
│                            #   (see netlogo-agent-toolkit/README.md)
└── lpm-strands/
    ├── README.md             # what an LPM strand needs, and the extended-learning space
    └── <model-slug>.md       # one strand file per model (currently stubs, see below)
```

## The models

| Model | Concepts | Grades |
|---|---|---|
| [Two Foresters](models/two-foresters/) | Cooperation, social dilemma, sustainable resource use | 3-5, 6-8, 9-12 |
| [Two Communities](models/two-communities/) | Common pool resources, cooperation | 6-8, 9-12, UG |
| [Population Size and Living Costs](models/population-size-living-costs/) | Population dynamics, resource use | 6-8, 9-12, teacher ed |
| [Evolution and Competition for Forest Resources](models/evolution-competition-forest-resources/) | Evolution, natural selection | 6-8, 9-12 |
| [Evolution and Competition for Resources (Abstract)](models/evolution-competition-resources-abstract/) | Evolution, complex systems | 6-8, 9-12 |
| [Evolution of Resource Use with Harvest Efficiency](models/evolution-resource-use-harvest-efficiency/) | Evolution, interdependence | 9-12 |
| [Evolution of Resource Use and Social Behavior](models/evolution-resource-use-social-behavior/) | Cooperation, multilevel selection, monitoring & punishment | 9-12 |
| [Evolution of Resource Use Through Behavior Imitation](models/evolution-resource-use-behavior-imitation/) | Cultural evolution, social norms | 9-12, UG |
| [Island World](models/island-world/) | Evolution, founder effect, multilevel selection | 9-12, UG |
| [Evolution of Ethnocentrism](models/evolution-ethnocentrism/) | Kin selection, multilevel selection, ethnocentrism | 9-12 |
| [Bug Evolution](models/bug-evolution/) | Natural selection, predator-prey | 6-8, 9-12 |
| [Swarming](models/swarming/) | Complex systems, emergence | 9-12 |
| [Virus Epidemic](models/virus-epidemic/) | Epidemiology, public health | 6-8, 9-12 |
| [Wolves-Sheep-Grass](models/wolves-sheep-grass/) | Predator-prey, ecosystem dynamics | 6-8, 9-12, teacher ed |

Each model page links out to any OpenEvo-authored teaching materials (lesson plans, UI-overview
slide decks) that exist for it on the source site.

## LPM strands & extended learning

[`lpm-strands/`](lpm-strands/) is the working space for building out Learning Progression Map
strands tied to each model — see [`lpm-strands/README.md`](lpm-strands/README.md) for what that
involves and the current status of each strand (all start as stubs). It's also where
cross-model/extended-learning material goes as it's developed.

## Building & designing new models

Model design, editing, and curriculum integration for this collection are
supported by dedicated agents/skills in the sibling
[`curriculum-agents`](https://github.com/openevo-ccs/curriculum-agents)
repo:

- **`netlogo-modeler`** — designs, builds, and edits models in this repo
  (interface widgets, breeds/patches/procedures, BehaviorSpace
  experiments, keeping `model.nlogo` and `app.html` in sync). See
  `skills/netlogo-model-design`.
- **`netlogo-lpm-integrator`** — turns a model into a real
  [`lpm-strands/`](lpm-strands/) entry (grade-band progression, content
  anchor/thinking-tool alignment, competencies, assessment, schema-ready
  contribution). See `skills/netlogo-lpm-integration`.
- **`skills/netlogo-interactive-embedding`** — patterns for embedding a
  model's `app.html` in something bigger than a single page (a "digital
  lab notebook," multi-model comparisons extending this repo's own
  `index.html` explorer, assessment stimulus material).
- **`tools/netlogo-mcp`** — optional live NetLogo control (create/run/
  inspect/export) via the third-party
  [NetLogo-MCP](https://github.com/Razee4315/NetLogo-MCP) server, for
  anyone with a local NetLogo + JDK install.

## Running a model locally

Every model works two ways:
- **In-browser, no install:** open `models/<slug>/app.html` directly, or use the
  [live explorer](https://openevo-ccs.github.io/netlogo/).
- **In desktop NetLogo:** open `models/<slug>/model.nlogo` in
  [NetLogo](https://ccl.northwestern.edu/netlogo/) (developed by the Center for Connected
  Learning and Computer-Based Modeling at Northwestern University) to inspect or edit the code,
  interface, and info tab.

## Attribution & license

Models and their descriptions originate from OpenEvo / TeachingBase, OpenEvo CCS Lab
(https://openevo.eva.mpg.de/teachingbase/netlogo/), licensed
CC BY-SA. This repository's structure, LPM strands, and explorer app are original contributions
of the OpenEvo CCS Lab under the same license. See [LICENSE](LICENSE).
