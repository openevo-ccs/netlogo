turtles-own [
  harvest-type
  harvest-amount
  harvest
  energy
]

patches-own [resource]

globals [
  carryingcap
  growthrate
 ]

;;;;;;;;;;;;;;;;;;;;;;
;;;Setup Procedures;;;
;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all

  set carryingcap 100
  set growthrate 0.3

  setup-patches
  setup-turtles

  reset-ticks
end

to setup-patches

 ask patches [
    set resource ( 75 + random (carryingcap / 4))
    set pcolor scale-color brown resource  0 (carryingcap + 30)
  ]
end

to setup-turtles
  ask n-of 50 patches
    [sprout 1
      [set energy Living-costs + 1]]

  ask n-of Sustainables turtles [ set harvest-type "sustainable"]

   ask turtles [
    if Agents-Appearance = "Persons" [ set shape "person" set size 1]
    if Agents-Appearance = "Bacteria" [ set shape "bacteria" set size 1.2]
    if Agents-Appearance = "Circles" [ set shape "circle" set size 0.8]

    ifelse harvest-type = "sustainable"
      [set color green ]
      [set harvest-type "greedy"
       set color red]
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;
;;;Runtime Procedures;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to go
  if count turtles = 0 [stop]

  ask turtles [
    ifelse harvest-type = "sustainable"
      [set harvest-amount Harvest-sustainables ]
      [set harvest-amount Harvest-greedy ]]

  ask turtles [
    if Agents-Appearance = "Persons" [ set shape "person" set size 1]
    if Agents-Appearance = "Bacteria" [ set shape "bacteria" set size 1.2]
    if Agents-Appearance = "Circles" [ set shape "circle" set size 0.8]]

  move
  harvest-patch

  livingcosts

  if Reproduction [reproduce]
  death

  ask patches [
    regrow
    recolor]

  tick
end

to move ;;turtle procedure

 ask turtles [
    let nextpatch max-one-of (patches in-radius 2 with [not any? turtles-here] ) [resource]
    if nextpatch != nobody
      [ face nextpatch
        move-to nextpatch]

    ]
end

to harvest-patch
  ask turtles [
   ifelse [resource] of patch-here > harvest-amount
   [set harvest harvest-amount
    ask patch-here [ set resource resource - [harvest-amount] of myself]]
   [set harvest [resource] of patch-here
    ask patch-here [set resource 0]
    ]
    set energy energy + harvest
  ]
end

to livingcosts
  ask turtles [set energy energy - Living-costs]
end

to reproduce
 ask turtles
  [ let neighborhood  (patch-set neighbors with [not any? turtles-on self ])
      if (any? neighborhood)  and random-float 1 < ( 0.001 * energy );;/ 100)
        [hatch 1 [
         mutate
         set energy ([energy] of myself / 2)
         move-to one-of neighborhood
          ]
        set energy (energy / 2)
        ]
     ]
end

to mutate  ;; turtle procedure
    if random-float 100 < Mutation-rate
    [ifelse harvest-type = "sustainable"
      [set harvest-type "greedy"]
      [set harvest-type "sustainable"]
    ]
   update-color
end

to update-color
   ifelse harvest-type = "sustainable"
      [ set color green ]
      [ set color red ]
end

to death
  ask turtles
  [if energy <= 0 [die]
     if random-float 100 < Death-rate [ die ]]

end

to regrow ;; patch
  ifelse resource > 0
  [set resource precision (resource + ((growthrate * resource) * (1 - (resource / carryingcap )))) 3]
  [ set resource 0.1]
end

to recolor ;; patch
  set pcolor scale-color brown resource 0 (carryingcap + 30)
end

;;; Farmers1 variables
to-report average-energy-greedys
  report sum [energy] of turtles with [harvest-type = "greedy"] / count turtles with [harvest-type = "greedy"]
end

to-report average-energy-sustainables
  report sum [energy] of turtles with [harvest-type = "sustainable"] / count turtles with [harvest-type = "sustainable"]
end
@#$#@#$#@
GRAPHICS-WINDOW
194
10
802
319
-1
-1
12.0
1
10
1
1
1
0
0
0
1
0
49
0
24
1
1
1
Iterations
10.0

BUTTON
10
10
105
44
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
10
87
105
121
Start
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
9
256
185
289
Harvest-sustainables
Harvest-sustainables
0
20
7.0
0.5
1
NIL
HORIZONTAL

BUTTON
10
48
106
82
One round
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
808
10
1159
186
Populations (% of carrying capacity)
NIL
NIL
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"Resource" 1.0 0 -5207188 true "" "plot (sum [resource] of patches / (carryingcap * count patches)) * 100"
"Agents" 1.0 0 -11053225 true "" "plot ( count turtles / count patches ) * 100"

SLIDER
9
293
184
326
Harvest-greedy
Harvest-greedy
harvest-sustainables
100
10.0
0.5
1
NIL
HORIZONTAL

PLOT
369
330
799
546
Average energy of agents
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Sustainables" 1.0 0 -10899396 true "" "carefully [plot average-energy-sustainables] [plot 0]"
"Greedy" 1.0 0 -2674135 true "" "carefully [plot average-energy-greedys] [plot 0]"

SLIDER
9
388
182
421
Living-costs
Living-costs
0
Harvest-sustainables - 1
0.0
0.1
1
NIL
HORIZONTAL

PLOT
808
375
1161
571
Trait Frequencies (%)
NIL
NIL
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"Sustainables" 1.0 0 -10899396 true "" "if count turtles > 0 [plot (count turtles with [harvest-type = \"sustainable\"] / count turtles) * 100]"
"Greedy" 1.0 0 -2674135 true "" "if count turtles > 0 [plot (count turtles with [harvest-type = \"greedy\"] / count turtles) * 100]"

SLIDER
9
427
181
460
Mutation-rate
Mutation-rate
0
10
0.0
0.1
1
%
HORIZONTAL

SLIDER
10
149
182
182
Sustainables
Sustainables
0
50
50.0
1
1
NIL
HORIZONTAL

CHOOSER
10
196
148
241
Agents-Appearance
Agents-Appearance
"Persons" "Bacteria" "Circles"
1

PLOT
808
188
1160
373
Agent Population
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total" 1.0 0 -16777216 true "" "plot count turtles"
"Sustainables" 1.0 0 -10899396 true "" "plot count turtles with [harvest-type = \"sustainable\"]"
"Greedy" 1.0 0 -2674135 true "" "plot count turtles with [harvest-type = \"greedy\"]"

TEXTBOX
12
131
162
149
Initial population = 50
11
0.0
1

SLIDER
9
465
181
498
Death-rate
Death-rate
0
10
0.0
1
1
%
HORIZONTAL

TEXTBOX
1168
36
1327
78
Carrying capacity: 100 resource units per Patch\nResource growth rate: 0.3
11
0.0
1

TEXTBOX
1168
11
1318
29
Resource
14
0.0
1

SWITCH
9
341
182
374
Reproduction
Reproduction
1
1
-1000

TEXTBOX
193
345
342
387
Agents reproduce with a probability of   0.001 * Energy
11
0.0
1

TEXTBOX
1170
96
1320
114
Agents
14
0.0
1

TEXTBOX
1169
119
1319
137
Carrying capacity: 1 per Patch
11
0.0
1

MONITOR
369
552
572
597
Average energy of modest agents
average-energy-sustainables
1
1
11

MONITOR
577
552
779
597
Average energy of greedy agents
average-energy-greedys
1
1
11

MONITOR
1164
188
1247
233
Total
count turtles
0
1
11

MONITOR
1165
237
1247
282
Sustainables
count turtles with [harvest-type = \"sustainable\"]
0
1
11

MONITOR
1166
286
1248
331
Greedy
count turtles with [harvest-type = \"greedy\"]
0
1
11

MONITOR
1165
375
1247
420
Sustainables
(count turtles with [harvest-type = \"sustainable\"] / count turtles) * 100
1
1
11

MONITOR
1165
425
1247
470
Greedy
(count turtles with [harvest-type = \"greedy\"] / count turtles) * 100
1
1
11

@#$#@#$#@
# Model purpose
What is the purpose of the model?

This model simulates the evolution of a population of resource users competing for the same resource. With the help of the model, we can observe that competition for limited resources can lead to the evolution of increasing resource use and to the overuse of the resource. We can also observe predator-prey-dynamics between the resource and its user population.


# Entities and variables
What kinds of entities are in the model? By what state variables, or attributes, are these entities characterized? What are the temporal and spatial resolutions and extents of the model?

## General environment

### Changeable variables

* _Living-costs_: the costs that each agent has to deduct from his energy per iteration for basic survival
* _Mutation-rate_: The probability with which offspring agents have other traits than their parents
* _Death-rate_: The probability with which agents die independent of their energy level
(these variables could be considered both a factor of the environment and a variable of the agents, but we list them here since they do not vary among agents)


## Patches

There are 50*25 patches in the world. 

### Constant patch variables
(these variables and behaviors are always the same for all of the patches and in each iteration)

* Carrying capacity per patch : Ressource = 100, Agents = 1
* Growth rate of the resource = 0.3
* The resources on a patch regrow by a logistic growth function up to the carrying capacity: 
new resource level = current resource level + (Growth-Rate * current resource level) * (1 - (current resource level / carrying capacity)


### Changing variables during a simulation
(variables that change as a result of the simulation)

  * actual resource level of a patch in units

## Agents
Agents can have one of two resource consumption traits: sustainable (green color) or “greedy” (red color). 


### Constant agent variables and behaviors
(these variables and behaviors are always the same for all of the agents of this type and in each iteration)

* In each iteration, each agent moves to a patch with the most resources within a radius of two patches.


### Changeable agent variables
(variables that are changeable by the user on the interface): 

* _Agents-Appearance_: Agents can have three types of appearances: bacteria, human, or circle. These appearances do not change any other agent behaviors or variables.
* _Harvest-sustainables_:  the amount of resource units harvested per iteration by sustainable agents
* _Harvest-greedy_: the amount of resource units harvested per iteration by greedy agents
* _Reproduction_: ability of agents to produce offspring


### Changing variables during a simulation
(variables that change as a result of the simulation)

* _harvested amount_: the amount of resource units that is harvested by an agent in the current iteration
* _Energy level_: the total accumulated energy (in resource units) that an agent is accumulating during a simulation
* Offspring have a different harvesting type from their parents with a probability of _Mutation-rate_.


# Model Setup
What is the initial state of the model world when one clicks on Setup? Is initialization always the same, or does it vary among simulations?

* A world with 50*25 patches is created.
* The parameter carrying capacity is set at 100.
* The parameter growth rate is set at 0.3
* The initial amount of resource units on a patch is distributed randomly between 75 and 100.
* 50 agents, with the selected number of sustainable agents, are randomly distributed on patches (maximum one agent per patch).
* Sustainable agents are green and greedy agents are red; agents have the appearance set by _Agents-Appearance_ setting.
* The initial level of energy of agents is set at living costs + 1.


# Model Processes
What happens in each iteration? Which entities do what, and in what order? When are state variables updated?

![Model processes image](https://openevo.eva.mpg.de/wp-content/uploads/NetLogo-model-evolution-abstract-procedures-overviews.png)

# Outputs
What kinds of model outcomes can be observed on the interface? How do they emerge from model parameters, agent behaviors, and interactions?


## In the world
Resource levels on patches change as they are being harvested and as they regrow. Agents move around, reproduce, and die. 
 

## Output diagrams and monitors

### Populations (% of carrying capacity)
The state of the resource and of the agent population in the world as percentage of total carrying capacity; resulting from resource harvesting behavior and resource regrowth, agent reproduction and death

### Agent Population
The absolute numbers of sustainable and greedy agents and the total population size, resulting from mutations, reproduction, and death

### Trait frequencies
The relative frequencies of sustainable and greedy agents in the population, resulting from mutations, different reproduction rates, and death

### Average energy of agents
average energy levels of sustainable and greedy agents, resulting from resource harvest, minus living costs and reproduction


# Concepts and Principles
Which important concepts or principles are represented in the model?

The resource is characterized by two ecologically significant parameters:

* the **carrying capacity**: this is the largest possible amount of resources that can be present on a patch / in a certain area. In ecology, carrying capacity is often represented by the letter k. In this model, it is represented by the maximum growth height of the trees. In the real world, carrying capacity is influenced by biotic and abiotic factors like temperature and humidity or availability of other resources.
* the **resource growth rate**: this is the rate at which a resource grows back from one time step to the next. It is often represented in ecology by the letter r. 

The resource grows along a **logistic (S-shaped, sigmoid) population growth function** according to the following formula: 
Resource state at the next point in time = current resource state +  ( r * current resource state) * (1 - current resource state / k ) 

**Variation**
There can be two variants of harvesting behavior in the population - sustainable or greedy. New trait variants can be introduced randomly in the population through the parameter _mutation rate_.

**Reproductive fitness**
Agents that harvest more resources and have higher energy levels produce more offspring. They have higher fitness relative to agents with lower energy levels.

**Inheritance**
Agents create offspring and inherit their harvesting behavior/type to their offspring (with some variability based on _mutation rate_)

**Natural selection**
The frequency of traits in the agent population changes as a result of trait variation, differential reproduction (fitness), and inheritance of traits. 

**Sensing and Information Processing** 
Agents sense their environment in a radius of 2 patches: if a patch is occupied by another agent, and the patch with the most resources.
Agents do not store any information (i.e. have no memory).

**Objectives and goal-directed behavior**
Agents move to an unoccupied patch with the most resources in a radius of 2 patches
Agents harvest their predetermined harvest amount (or until there are no more resources) 

**Learning and Adaptation**
Agents do not learn and do not adapt their behavior over their lifetimes.

**Interactions** 
Agents interact indirectly through competition for limited resources and space, and through their changing of environmental conditions through resource extraction and placing of offspring

**Role of randomness** 

* Agents are being distributed randomly in the world at the beginning of a simulation.
* The order in which agents move and harvest within one iteration is random.
* Agents move to a randomly selected patch if several patches fulfill the objectives
* The order in which agents produce offspring within one iteration is random.
* Agents produce offspring with a probability of  (0.001 * Energy).
* Agents place offspring on a randomly selected unoccupied neighboring patch.
* Offspring mutate with a probability of Mutation-rate.
* Agents die with a probability of Death-rate.

# Model Teaching Materials

Teaching materials for this model: https://openevo.eva.mpg.de/teachingbase/netlogo-evolution-and-competition-for-resources-abstract/


# References and Citation

For this model:

* Hanisch, S. (2022). Evolution and competition for resources. OpenEvo NetLogo Models. https://openevo.eva.mpg.de/teachingbase/netlogo/

For the NetLogo-Software:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.


# Licence

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. http://creativecommons.org/licenses/by-nc-sa/4.0/
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bacteria
true
0
Polygon -7500403 true true 135 210 120 285 135 240 135 285 150 240 150 285 150 240 165 285 165 240 180 285 165 210
Circle -7500403 true true 105 122 90
Circle -7500403 true true 110 75 80
Circle -7500403 false true 45 60 0

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person farmer
false
10
Polygon -7500403 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 60 195 90 210 114 154 120 195 180 195 187 157 210 210 240 195 195 90 165 90 150 105 150 150 135 90 105 90
Circle -7500403 true false 110 5 80
Rectangle -7500403 true false 127 79 172 94
Polygon -13345367 true true 120 90 120 180 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 180 90 172 89 165 135 135 135 127 90
Polygon -13345367 true true 116 4 113 21 71 33 71 40 109 48 117 34 144 27 180 26 188 36 224 23 222 14 178 16 167 0
Line -16777216 false 225 90 270 90
Line -16777216 false 225 15 225 90
Line -16777216 false 270 15 270 90
Line -16777216 false 247 15 247 90
Rectangle -6459832 true false 240 90 255 300

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

thick line
true
0
Rectangle -7500403 true true 150 0 150 300
Rectangle -7500403 true true 135 0 165 300

thicker line
true
0
Rectangle -7500403 true true 150 0 150 300
Rectangle -7500403 true true 105 0 195 300

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
