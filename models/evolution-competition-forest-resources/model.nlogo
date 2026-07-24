breed [trees tree]
breed [foresters forester]

foresters-own [
  harvest-type
  amount
  harvest
  wealth
]

trees-own [height]


;;;;;;;;;;;;;;;;;;;;;;
;;;Setup Procedures;;;
;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all

  setup-forest
  setup-trees
  setup-foresters

  reset-ticks
end

to setup-forest
  ask patches [set pcolor brown + 2]

end

to setup-trees
  ask patches [
    sprout-trees 1 [
    set shape "tree"
    set color green - 2
    set height Max-Treeheight
    set size ( height / 100 )
  ]]
end


to setup-foresters
  ask n-of Initial-Number-Foresters patches
    [sprout-foresters  1 [
      set shape "person logger"

      set size 0.9 ] ]

  ask n-of Number-Modest foresters [ set harvest-type "modest"]

  update-color

end


;;;;;;;;;;;;;;;;;;;;;;;;
;;;Runtime Procedures;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to go

  ask foresters with [harvest-type = "modest"] [set amount Percent-cut-modest]
  ask foresters with [harvest-type = "greedy"] [set amount Percent-cut-greedy]

  cut-trees

  livingcosts

  if Reproduction?
  [reproduce]

  death

  ask trees [ regrow]

  tick
end

to cut-trees
  ask foresters [
     let harvest-tree max-one-of (trees in-radius 1) [height]
         move-to harvest-tree
        set harvest (  [height] of harvest-tree  * ( amount / 100))
        ask  harvest-tree [set height (height - (height * [amount ] of myself / 100))]
    set wealth wealth + harvest
    ]
end

to livingcosts
  ask foresters [set wealth wealth - Living-costs]
end

to reproduce

 ask foresters
  [ let neighborhood  (patch-set neighbors with [not any? foresters-on self ])
      if (any? neighborhood)  and random-float 1 < ( 0.0005 * wealth );;/ 100)
        [hatch 1 [
             mutate
         set wealth ([wealth] of myself / 2)
         move-to one-of neighborhood
          ]
        set wealth (wealth / 2)
        ]
     ]
end

to mutate  ;; turtle procedure
    if random-float 100 < Mutation-rate
    [ifelse harvest-type = "modest"
      [set harvest-type "greedy"]
      [set harvest-type "modest"]
    ]
   update-color
end

to death
  ask foresters
  [if wealth <= 0 [die]]
end

to update-color
   ask foresters [
    ifelse harvest-type = "modest"
      [set color green ]
      [set harvest-type "greedy"
       set color red]
  ]
end

to regrow ;; tree
    set height  (height + ((Growth-rate * height) * (1 - (height / ( Max-Treeheight)  ))))
    set size height / 100
end

;;;;;;;;;;;;;;
;;;;;;;;;;;;;

;;; Forester variables
to-report average-wealth-greedys
  report sum [wealth] of foresters with [harvest-type = "greedy"] / count foresters with [harvest-type = "greedy"]
end

to-report average-wealth-modest
  report sum [wealth] of foresters with [harvest-type = "modest"] / count foresters with [harvest-type = "modest"]
end
@#$#@#$#@
GRAPHICS-WINDOW
205
10
753
289
-1
-1
27.0
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
19
0
9
1
1
1
iterations
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
95
105
129
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
11
217
193
250
Percent-cut-modest
Percent-cut-modest
0
Percent-cut-greedy
10.0
0.1
1
%
HORIZONTAL

BUTTON
10
52
106
86
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

SLIDER
12
336
184
369
Growth-rate
Growth-rate
0
2
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
12
297
184
330
Max-Treeheight
Max-Treeheight
0
100
100.0
1
1
NIL
HORIZONTAL

PLOT
761
10
1189
288
Forest stock (% of maximum)
NIL
NIL
0.0
10.0
0.0
100.0
true
false
"" ""
PENS
"Total" 1.0 0 -16777216 true "" "plot (sum [height] of trees / ((Max-Treeheight ) * count patches)) * 100"

SLIDER
11
255
193
288
Percent-cut-greedy
Percent-cut-greedy
Percent-cut-modest
100
20.0
0.1
1
%
HORIZONTAL

PLOT
205
293
602
515
Average Accumulated Wealth
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
"Modest" 1.0 0 -10899396 true "" "carefully [plot average-wealth-modest] [plot 0]"
"Greedy" 1.0 0 -2674135 true "" "carefully [plot average-wealth-greedys] [plot 0]"

SLIDER
11
176
190
209
Number-Modest
Number-Modest
0
Initial-Number-Foresters
50.0
1
1
NIL
HORIZONTAL

SLIDER
12
459
185
492
Living-costs
Living-costs
0
10
0.0
0.5
1
NIL
HORIZONTAL

SWITCH
13
384
155
417
Reproduction?
Reproduction?
1
1
-1000

PLOT
962
293
1286
516
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
"Modest" 1.0 0 -10899396 true "" "carefully [plot (count foresters with [harvest-type = \"modest\"] / count foresters) * 100][plot 0]"
"Greedy" 1.0 0 -2674135 true "" "carefully [plot (count foresters with [harvest-type = \"greedy\"] / count foresters) * 100][plot 0]"

PLOT
609
293
956
516
Forester Population
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
"Modest" 1.0 0 -10899396 true "" "plot count foresters with [harvest-type = \"modest\"]"
"Greedy" 1.0 0 -2674135 true "" "plot count foresters with [harvest-type = \"greedy\"]"
"Total" 1.0 0 -7500403 true "" "plot count foresters"

SLIDER
12
139
190
172
Initial-Number-Foresters
Initial-Number-Foresters
0
50
50.0
1
1
NIL
HORIZONTAL

TEXTBOX
19
423
169
465
Agents reproduce with a probability of 0.0005 * wealth
11
0.0
1

SLIDER
12
498
185
531
Mutation-rate
Mutation-rate
0
50
0.0
0.1
1
NIL
HORIZONTAL

MONITOR
205
518
397
563
Average wealth of modest foresters
average-wealth-modest
1
1
11

MONITOR
401
518
601
563
Average wealth of greedy foresters
average-wealth-greedys
1
1
11

MONITOR
610
519
722
564
Population (modest)
count foresters with [harvest-type = \"modest\"]
0
1
11

MONITOR
737
520
843
565
Population (greedy)
count foresters with [harvest-type = \"greedy\"]
0
1
11

MONITOR
857
520
955
565
Population (total)
count foresters
0
1
11

MONITOR
1001
521
1126
566
Frequency (modest)
(count foresters with [harvest-type = \"modest\"] / count foresters) * 100
1
1
11

MONITOR
1130
521
1254
566
Frequency (greedy)
(count foresters with [harvest-type = \"greedy\"] / count foresters) * 100
1
1
11

MONITOR
1193
10
1274
55
Forest stock
(sum [height] of trees / ((Max-Treeheight ) * count patches)) * 100
2
1
11

@#$#@#$#@
# Model purpose
What is the purpose of the model?

This model simulates the evolution of a population of resource users competing for the same resource, illustrated by the example of a forest. With the help of the model, we can observe that competition for limited resources can lead to the evolution of increasing resource use rates and to the overuse of the resource.


# Entities and variables
What kinds of entities are in the model? By what state variables, or attributes, are these entities characterized? What are the temporal and spatial resolutions and extents of the model?

## General environment

### Changeable variables

* _Living-costs_: the costs that each agent has to deduct from his energy per iteration for basic survival (this variable could be considered both a factor of the environment and a variable of the forester agents, but we list it here since it does not vary among foresters)
* _Mutation-rate_: The probability with which offspring have other traits than their parents (this variable could be considered both a factor of the environment and a variable of the forester agents, but we list it here since it does not vary among foresters)

## Patches

There are 10*20 brown-colored patches in the world, representing an area of forest, e.g. one hectare per patch.

## Trees
There are 200 trees in the world (one per patch). The trees could represent actual individual trees, or a collection of several trees, e.g. 100 trees per patch.

### Constant tree variables and behaviors
(these variables and behaviors are always the same for all of the agents of this type and in each iteration)

* All trees regrow by a logistic growth function up to the maximum tree height: 
new height = current height + (Growth-Rate * height) * (1 - (height /Max-Treeheight)

### Changeable tree variables
(variables that are changeable by the user on the interface): 

* _maximum tree height_: the maximum height in units that a tree can grow to
* _tree growth rate_: the rate at which a tree grows per iteration

### Changing variables during a simulation
(variables that change as a result of the simulation)

  * actual tree height in units

## Foresters
There are two types of foresters in the world: greedy (shown in red) or modest (shown in green).


### Constant forester variables and behaviors
(these variables and behaviors are always the same for all of the agents of this type and in each iteration)

* In each iteration, each forester moves to one of the neighboring patches with the highest tree on it (if there is more than one tree with the tallest height, it chooses one of them randomly).

### Changeable forester variables
(variables that are changeable by the user on the interface): 

* _percent cut modest_: the fraction of a tree that modest foresters harvest per iteration
* _percent cut greedy_: the fraction of a tree that greedy foresters harvest per iteration
* _Reproduction_: whether or not the foresters produce offspring


### Changing variables during a simulation
(variables that change as a result of the simulation)

* _harvested amount_: the amount of tree units that is harvested by a forester in the current iteration
* _Accumulated wealth_: the total accumulated wealth (in tree units) that a forester is accumulating during a simulation
* Offspring have a different harvesting type from their parents with a probability of _Mutation-rate_.


# Model Setup
What is the initial state of the model world when one clicks on Setup? Is initialization always the same, or does it vary among simulations?

* A world with 200 patches is created.
* A tree is placed on each patch, and each tree has the maximum growth height.
* A number of foresters set by _Initial-Number-Foresters_, which can include a number of modest foresters  set by _Number modest_, is placed randomly on the patches in the world.

# Model Processes
What happens in each iteration? Which entities do what, and in what order? When are state variables updated?

![Model processes image](https://openevo.eva.mpg.de/wp-content/uploads/NetLogo-model-Evolution-forest-procedures-overviews.png)

# Outputs
What kinds of model outcomes can be observed on the interface? How do they emerge from model parameters, agent behaviors, and interactions?


## In the world
Trees change in height as they are being harvested and as they regrow. Foresters move around and reproduce or die. 

## Output diagrams and monitors

### Forest Stock (% of maximum)
The state of the forest in the world as a percentage of maximum possible stock, resulting from harvesting behavior of foresters and regrowth of trees

## Average accumulated wealth
The average level of wealth of modest and greedy foresters, resulting from resource harvest, minus living costs and reproduction

## Forester population
The number of foresters in the world by type and in total, resulting from mutations, reproduction, and death 

## Trait frequencies
The frequencies of the two forester types in % resulting from mutations, different reproduction rates, and death.


# Concepts and Principles
Which important concepts or principles are represented in the model?

The resource is characterized by two ecologically significant parameters:

* the **carrying capacity**: this is the largest possible amount of resources that can be present on a patch / in a certain area. In ecology, carrying capacity is often represented by the letter k. In this model, it is represented by the maximum growth height of the trees. In the real world, carrying capacity is influenced by biotic and abiotic factors like temperature and humidity or availability of other resources.
* the **resource growth rate**: this is the rate at which a resource grows back from one time step to the next. It is often represented in ecology by the letter r. 

The resource grows along a **logistic (S-shaped, sigmoid) population growth function** according to the following formula: 
Resource state at the next point in time = current resource state +  ( r * current resource state) * (1 - current resource state / k ) 

**Common-pool resources**
Common-pool resources are resources or goods that 
are accessible to all members of a community, so no one can be excluded from using them;
reduced by the use, such that removal by one user reduces availability to others. Therefore, the resource is limited (there is not an endless amount available), and users can end up competing for the resource.
Examples of common-pool resources for humans are fish stocks in the ocean or in a lake, public forests, groundwater, air, beach sites, busy roads, busy public parks.

**Trait variation**
Foresters can have one of two variants of harvesting behavior - sustainable or greedy. New trait variants can be introduced randomly in the population through the parameter _mutation rate_.

**Reproductive fitness**
Foresters that harvest more resources and have higher levels of wealth produce more offspring. They have higher fitness relative to foresters with lower levels of wealth.

**Inheritance**
Foresters create offspring and inherit their harvesting behavior/type to their offspring (with some variability based on _mutation rate_)

**Natural selection**
The frequency of traits in the forester population changes as a result of trait variation, differential reproduction (fitness), and inheritance of traits. 

**Social interactions**
In social interactions, the behavior of one individual has outcomes for others in the group. Social interactions can be both intraspecific (between members of one species) and interspecific (between members of different species). Social interactions can be direct (such as reacting to each other, aggression, sharing resources) or indirect (such as when competing for resources or changing shared environmental conditions). 

In this model, foresters interact indirectly by competing for limited forest resources and limited space, or by changing environmental conditions through resource extraction and by placing their offspring on patches.

**Perception and information processing**
Forester agents are aware of tree heights on their neighbor patches and whether patches are empty (i.e. have no forester on them).
Agents do not store any information (i.e. have no memory).


**Preferences and goal-directed behavior**
Foresters move to a patch with the largest tree.
Foresters always harvest the percentage of the tree set by the percent-cut parameter.

**Learning and Adaptation**
Agents do not learn and do not adapt their behavior over their lifetimes.

**Randomness**

* Foresters are randomly placed on patches at model setup. 
* The order in which foresters move and harvest from the resource within an iteration is random.
* Foresters move to a random patch if multiple patches match preferences.
* The order in which foresters reproduce is random.
* Foresters reproduce with a probability of 0.0005 * wealth (so the higher the level of wealth, the higher the chances of reproducing)
* Foresters place an offspring on a randomly chosen empty neighboring patch.


# Model Materials

Teaching materials for this model: https://openevo.eva.mpg.de/teachingbase/netlogo-evolution-and-competition-for-forest-resources/


# References and Citation

For this model:

* Hanisch, S. (2022). Evolution and forest resource use. OpenEvo NetLogo Models. https://openevo.eva.mpg.de/teachingbase/netlogo/

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

person logger
false
10
Polygon -7500403 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 60 195 90 210 114 154 120 195 180 195 187 157 210 210 240 195 195 90 165 90 150 105 150 150 135 90 105 90
Circle -7500403 true false 110 5 80
Rectangle -7500403 true false 127 79 172 94
Polygon -13345367 true true 120 90 120 180 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 180 90 172 89 165 135 135 135 127 90
Polygon -13345367 true true 116 4 113 21 71 33 71 40 109 48 117 34 144 27 180 26 188 36 224 23 222 14 178 16 167 0
Polygon -16777216 true false 240 95 230 95 235 60 256 66 296 70 293 122 274 102
Polygon -6459832 true false 247 95 224 196 216 226 229 232 260 96

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
NetLogo 6.2.0
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
