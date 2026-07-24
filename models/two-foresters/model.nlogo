breed [trees tree]
breed [foresters forester]
breed [fences fence]

foresters-own [
  amount
  harvest
  wealth
]

trees-own [height]

globals [
  forest1
  forest2
  farmers1
  farmers2
 ]

;;;;;;;;;;;;;;;;;;;;;;
;;;Setup Procedures;;;
;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all

  setup-forests
  setup-trees
  if Private-forest? [setup-fence]
  setup-farmers

  reset-ticks
end

to setup-forests
  ask patches [set pcolor brown + 2]
  set forest1 patch-set patches with [pxcor < 5]
  set forest2 patch-set patches with [pxcor >= 5]
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

to setup-fence
  ask patches with [ pxcor = 4 ] [
    sprout-fences 1 [
    set shape "thick line"
    set color grey
    set xcor 4.5
      ifelse pycor  < 4
      [facexy 4.5 5 ]
      [facexy 4.5 0 ]
  ]]
end


to setup-farmers
  ask patches with [pxcor = 2 and pycor = 1 ]
    [sprout-foresters  1 [
      set shape "person logger"
      set color green
      set size 1.2 ] ]

  ask patches with [pxcor = 6 and pycor = 1 ]
    [sprout-foresters 1 [
      set shape "person logger"
      set color red
      set size 1.2] ]

  set farmers1 turtle-set foresters-on forest1
  set farmers2 turtle-set foresters-on forest2
end


;;;;;;;;;;;;;;;;;;;;;;;;
;;;Runtime Procedures;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to go

  ifelse Private-forest?
   [setup-fence]
   [ask fences [die]]

  ask farmers1 [set amount Percent-cut1]
  ask farmers2 [set amount Percent-cut2]

  cut-trees

  ask trees [ regrow]

  tick
end

to cut-trees
  ifelse Private-forest?
  [harvest-private]
  [harvest-commons]

  ask foresters [set wealth wealth + harvest]
end

to harvest-private
   ask farmers1 [
    if member? patch-here forest1 = false [ move-to one-of forest1]
    let trees1 trees-on forest1
    let harvest-tree max-one-of (trees1 in-radius 1) [height]
    move-to harvest-tree
    set harvest (  [height] of harvest-tree  * amount / 100)
    ask  harvest-tree [set height (height - (height * [amount ] of myself / 100))]
  ]

  ask farmers2 [
    if member? patch-here forest2 = false [ move-to one-of forest2]
    let trees2 trees-on forest2
    let harvest-tree max-one-of (trees2 in-radius 1) [height]
    move-to harvest-tree
    set harvest (  [height] of harvest-tree  * amount / 100)
    ask  harvest-tree [set height (height - (height * [amount ] of myself / 100))]
  ]
end

to harvest-commons
  ask foresters [
    let harvest-tree max-one-of (trees in-radius 2) [height]
     move-to harvest-tree
     set harvest (  [height] of harvest-tree  * ( amount / 100))
     ask  harvest-tree [set height (height - (height * [amount ] of myself / 100))]
  ]
end

to regrow ;; tree
  ifelse height > 0
 [ set height  (height + ((Growth-Rate * height) * (1 - (height / ( Max-Treeheight)  ))))
   ]
  [set height 0.01]
  set size height / 100
end
@#$#@#$#@
GRAPHICS-WINDOW
210
15
668
249
-1
-1
45.0
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
9
0
4
1
1
1
iterations
10.0

BUTTON
8
19
103
53
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
8
104
103
138
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
151
190
184
Percent-cut1
Percent-cut1
0
100
50.0
1
1
%
HORIZONTAL

BUTTON
8
61
104
95
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
9
283
181
316
Growth-Rate
Growth-Rate
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
9
242
181
275
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
676
15
1089
248
Forest stock (% of maximum)
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
"Forest 1" 1.0 0 -10899396 true "" "if Private-forest? [plotxy ticks (sum [height] of trees-on forest1 / ( (Max-Treeheight ) * count forest1)) * 100]"
"Forest 2" 1.0 0 -2674135 true "" "if Private-forest? [plotxy ticks (sum [height] of trees-on forest2 / ((Max-Treeheight ) * count forest2)) * 100]"
"Total average" 1.0 0 -16777216 true "" "if Private-forest? = false [plotxy ticks (sum [height] of trees / ((Max-Treeheight ) * count patches)) * 100]"

SLIDER
9
190
190
223
Percent-cut2
Percent-cut2
0
100
90.0
1
1
%
HORIZONTAL

SWITCH
10
367
149
400
Private-forest?
Private-forest?
0
1
-1000

PLOT
676
252
1089
474
Accumulated harvest amount
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
"Forester 1" 1.0 0 -10899396 true "" "plot sum [wealth] of farmers1"
"Forester 2" 1.0 0 -2674135 true "" "plot sum [wealth] of farmers2"

PLOT
210
252
599
474
Harvest amount per iteration
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Forester 1" 1.0 0 -10899396 true "" "plot sum [harvest] of farmers1"
"Forester 2" 1.0 0 -2674135 true "" "plot sum [harvest] of farmers2"

MONITOR
1093
266
1164
311
Forester 1
sum [wealth] of farmers1
0
1
11

MONITOR
1093
314
1164
359
Forester 2
sum [wealth] of farmers2
0
1
11

MONITOR
602
267
673
312
Forester 1
sum [harvest] of farmers1
2
1
11

MONITOR
602
315
673
360
Forester 2
sum [harvest] of farmers2
2
1
11

MONITOR
1094
32
1153
77
Forest 1
sum [height] of trees-on forest1 / ( (Max-Treeheight ) * count forest1) * 100
2
1
11

MONITOR
1094
81
1153
126
Forest 2
sum [height] of trees-on forest2 / ( (Max-Treeheight) * count forest2) * 100
2
1
11

MONITOR
1095
130
1152
175
Total
sum [height] of trees / (Max-Treeheight * count patches) * 100
2
1
11

@#$#@#$#@
# Model purpose
What is the purpose of the model?

This model serves to illustrate a number of key concepts and processes in ecology, behavioral science and sustainability. In particular, it shows the social dilemma that can emerge when individuals have to share a limited common-pool resource. 

# Entities and variables
What kinds of entities are in the model? By what state variables, or attributes, are these entities characterized? What are the temporal and spatial resolutions and extents of the model?

## General environment
### Changeable variables
_Private forest_: This setting determines if the world is divided into two by a fence or not.

## Patches
There are 5*10 brown-colored patches in the world, representing an area of forest, e.g. one hectare per patch.
Patches belong to Forest 1 (left side of the world) or Forest 2 (right side of the world).

## Trees
There are 50 trees in the world (one per patch). The trees could represent actual individual trees, or a collection of several trees, e.g. 100 trees on one hectare.

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
There are two foresters in the world.

### Constant forester variables and behaviors
(these variables and behaviors are always the same for all of the agents of this type and in each iteration)

* The forester that starts on Forest 1 is called Forester 1 and is colored green
* The forester that starts on Forest 2 is called Forester 2 and is colored red.
* In each iteration, each forester moves to one of the neighboring patches with the highest tree on it (if there is more than one tree with the tallest height, it chooses one of them randomly).

### Changeable forester variables
(variables that are changeable by the user on the interface): 

* _percent cut1_: the fraction of a tree that forester 1 harvests at each iteration from a tree
* _percent cut2_: the fraction of a tree that forester 2 harvests at each iteration from a tree

### Changing variables during a simulation

* _harvested amount_: the amount  in tree units that is harvested by a forester in the current iteration
* _Accumulated harvest_: the total accumulated harvest  in tree units that a forester is accumulating during a simulation

# Model Setup
What is the initial state of the model world when one clicks on Setup? Is initialization always the same, or does it vary among simulations?

* A world with 50 patches is created.
* There is a tree agent on each patch, and each tree has the maximum growth height.
* If the “private forest” switch is on, a line is drawn in the middle of the world, cutting the forest into two forests with 5*5 patches.
* In each forest, a forester agent is placed on the same patch every time, one forester in red, one forester in green.

# Model Processes
What happens in each iteration? Which entities do what, and in what order? When are state variables updated?

![Model processes image](https://openevo.eva.mpg.de/wp-content/uploads/Two-foresters-procedures-overviews.png)

# Outputs
What kinds of model outcomes can be observed on the interface? How do they emerge from model parameters, agent behaviors, and interactions?


## In the world
Trees change in height as they are being harvested and as they regrow.

## Output diagrams and monitors
### Forest Stock (% of maximum)
The state of the forest in the world or of each private forest as a percentage of maximum possible stock, resulting from harvesting behavior of foresters and regrowth of trees

### Harvest amount per iteration
The amount that each forester harvests per iteration, resulting from harvest rate and the actual tree height

### Accumulated harvest amount
The harvest amount that each forester accumulates during the simulation. The accumulated harvests increase continuously because foresters never lose or “use up” any of their harvested amounts. 

# Concepts and Principles
Which important concepts or principles are represented in the model?


The resource is characterized by two ecologically significant parameters:

* the **carrying capacity**: this is the largest possible amount of resources that can be present on a patch / in a certain area. In ecology, carrying capacity is often represented by the letter k. In this model, it is represented by the maximum growth height of the trees. In the real world, carrying capacity is influenced by biotic and abiotic factors like temperature and humidity or availability of other resources.
* the **resource growth rate**: this is the rate at which a resource grows back from one time step to the next. It is often represented in ecology by the letter r. 

The resource grows along a **logistic (S-shaped, sigmoid) population growth function** according to the following formula: 
Resource state at the next point in time = current resource state + (r * current resource state) * (1 - current resource state / k) 

**Common-pool resources**
Common-pool resources are resources or goods that are accessible to all members of a community, so no one can be excluded from using them;
reduced by the use, such that removal by one user reduces availability to others. Therefore, the resource is limited (there is not an endless amount available), and users can end up competing for the resource.
Examples of common-pool resources for humans are fish stocks in the ocean or in a lake, public forests, groundwater, air, beach sites, busy roads, busy public parks.

**Social interactions**
In social interactions, the behavior of one individual has outcomes for others in the group. Social interactions can be both intraspecific (between members of one species) and interspecific (between members of different species). Social interactions can be direct (such as reacting to each other, aggression, sharing resources) or indirect (such as when competing for resources or changing shared environmental conditions). 
In this model, foresters interact indirectly (in the common forest setting) by competing for limited resources and by changing environmental conditions through resource extraction.

**Perception and information processing**
Forester agents are aware of the tree heights on their neighbor patches.
Agents do not store any information (i.e. they do not have a memory).


**Preferences and goal-directed behavior**
Foresters move to a neighboring patch with the largest tree.
Foresters always harvest the percentage of the tree set by the percent-cut parameter.


**Learning and Adaptation**
Agents do not learn and do not adapt their behavior.

**Randomness**
for the common forest: The order in which foresters move and harvest from the resource  (whether the green or the red forester goes first) within an iteration is random.
Foresters move to a random patch if multiple patches match preferences.


# Model Materials

Teaching materials for the model: https://openevo.eva.mpg.de/teachingbase/netlogo-2-foresters/

# References and Citation


For this model:

* Hanisch, S. (2022). Two foresters. OpenEvo NetLogo Models.   https://openevo.eva.mpg.de/teachingbase/netlogo/

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
