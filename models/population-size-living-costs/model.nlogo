breed [trees tree]
breed [foresters forester]

foresters-own [
  harvestrate
  harvest
  wealth
 ]

trees-own [height]

globals [
  max-height
 ]


;;;;;;;;;;;;;;;;;;;;;;
;;; Model setup procedures - these are executed when you click on “Setup.”
;;;;;;;;;;;;;;;;;;;;;;

to setup

  clear-all ;; clear the world

  set max-height 100 ;; set maximal tree hight to 100

  setup-trees
  setup-foresters

  reset-ticks
end

to setup-trees
  ask patches [
    set pcolor brown + 2
    sprout-trees 1 [
    set shape "tree"
    set color green - 2
    set height max-height
    set size ( height / 100 )
  ]]
end


to setup-foresters
  ask n-of number-foresters patches
    [sprout-foresters  1 [
      set shape "person logger"
      set size 0.9
      set color blue ] ]
end

;;;;;;;;;;;;;;;;;;;;;;;;
;;;Procedures - these are performed in each model round ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to go

  if not any? foresters [stop] ;; stop the simulation when there are no more foresters left in the world

  ask foresters [set harvestrate harvest-rate];; Allocate the set harvest rate to the foresters

  move
  cut-trees

  livingcosts

  death

  ask trees [ regrow]

  tick
end

to move ;; foresters move to one of the largest trees within 2 patches.
 ask foresters [
    let next-tree max-one-of (trees in-radius 2 with [not any? foresters-here] ) [height]
    if next-tree != nobody
      [ move-to next-tree]
  ]
end

to cut-trees ;; foresters harvest from the tree from their patch
  ask foresters [
    let harvest-tree one-of trees-here
      set harvest ([height] of harvest-tree * ( harvestrate / 100))
      set wealth wealth + harvest
      ask  harvest-tree [set height (height - (height * [harvestrate ] of myself / 100))]
    ]
end

to livingcosts ;; foresters pay living costs, which are deducted from their wealth.
  ask foresters [set wealth wealth - living-cost]
end

to death ;; foresters die if they don't have enough wealth
  ask foresters
  [if wealth <= 0 [die]
   ]
end

to regrow ;; trees regrow
  set height  (height + ((growth-rate-trees / 100 * height) * (1 - (height / ( max-height)  ))))
  set size height / 100
end

;;;;;;;;;;;;;
;;; foresters-variables
;;;;;;;;;;;;

to-report average-wealth-foresters ;; average wealth of greedy foresters
  report sum [wealth] of foresters / count foresters
end
@#$#@#$#@
GRAPHICS-WINDOW
231
10
914
424
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
24
0
14
1
1
1
Modellrunden
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
10
195
203
228
harvest-rate
harvest-rate
0
100
90.0
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

PLOT
922
10
1350
288
forest stock (% of maximum)
model rounds
forest stock (%)
0.0
10.0
0.0
100.0
true
false
"" ""
PENS
"Gesamt" 1.0 0 -16777216 true "" "plot (sum [height] of trees / ((max-height ) * count patches)) * 100"

PLOT
232
430
701
658
Average accumulated wealth of foresters
model rounds
wealth
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Gemäßigte" 1.0 0 -13345367 true "" "carefully [plot average-wealth-foresters] [plot 0]"

SLIDER
10
295
203
328
living-cost
living-cost
0
50
30.0
0.1
1
NIL
HORIZONTAL

PLOT
735
430
1176
657
forester population
model rounds
number-foresters
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Gesamt" 1.0 0 -7500403 true "" "plot count foresters"

SLIDER
11
147
203
180
number-foresters
number-foresters
0
375
2.0
1
1
NIL
HORIZONTAL

MONITOR
737
664
930
721
total number of foresters
count foresters
0
1
14

MONITOR
923
295
1067
352
forest stock (%)
(sum [height] of trees / ((max-height ) * count patches)) * 100
0
1
14

MONITOR
231
664
449
721
average wealth
average-wealth-foresters
0
1
14

SLIDER
10
243
204
276
growth-rate-trees
growth-rate-trees
0
100
10.0
1
1
%
HORIZONTAL

@#$#@#$#@
# Aim and purpose of the model
What is the purpose of the model?

This model simulates a population of resource users who use a shared natural resource, illustrated by the example of a forest. With the help of the model, we can observe how population size (number of foresters), tree growth rate, forester harvest rate, and cost of living are related to each other.


# Entities and variables
What types of entities are there in the model? What state variables or properties characterize these entities? What are the temporal and spatial resolutions of the model?


## General environment
### Changeable variables

* _Cost of living_: the cost that each forester must deduct from their energy or wealth per model round for basic survival (this variable could be considered both a factor of the environment and a variable of the foresters, but we list it here because this variable is the same for all foresters)

## Patches
There are 15*25 = 375 brown patches on the world representing forest area, e.g., one hectare per patch.


## Trees
There are 375 trees on the world (one tree per patch). The trees could represent actual individual trees or a collection of several trees, e.g., 100 trees per patch.

### Constant variables and behaviors 
(these variables and behaviors are always the same for all agents of this type and in every iteration)

* All trees grow to their maximum height using a logistic growth function: 
new height = current height + (growth rate * height) * (1 - (height / maximum tree height)


### Modifiable variables 
(variables that can be changed by the user on the user interface)

* _Growth rate trees_: the rate at which a tree grows per model round


### Variables that change during a simulation 
(variables that change as a result of the simulation)

* Actual tree height in units

## Foresters
There are a maximum of 375 foresters in the world.

### Constant variables and behaviors
 (these variables and behaviors are always the same for all agents of this type and in every iteration)

* In each iteration, each forester moves to one of the neighboring patches with the tallest tree on it (if there is more than one tree with the highest height, he randomly selects one of them).


### Changeable forester variables 
(variables that can be changed by the user on the user interface)
 

* _Number of foresters_: the number of foresters in the world at the start of a simulation
* _Harvest rate_: the proportion of a tree that  foresters harvest per model round


### Variables that change during a simulation 
(variables that change as a result of the simulation)

* _Harvest amount per model round_: the amount in tree units harvested by a forester in the current iteration
* _Accumulated wealth_: the total accumulated wealth


# Model setup
What is the initial state of the model when you click on Setup? Is the initialization always the same or does it vary between simulations?

* A world with 375 patches is created.
* A tree is placed on each patch, and each tree has the maximum growth height.
* A number of foresters, determined by the parameter _Number-of-foresters_, are randomly placed on the patches in the world.


# Processes
What happens in each iteration? Which entities do what and in what order? When are state variables updated?


![Model processes image](https://openevo.eva.mpg.de/wp-content/uploads/NetLogo-model-procedure-population-living-costs.png)

# Outputs / Result representation
What types of model results can be observed? How do they arise from model parameters, agent behavior, and interactions?


## In the world
The trees change their height by being harvested and growing back. Foresters move around and harvest the trees.


## Diagrams and monitors

### Forest condition (% vegetation cover)
The condition of the forest in the world as a percentage of the maximum possible stock, resulting from the harvesting behavior of the foresters and the regrowth of the trees.

### Average accumulated wealth of foresters
The average wealth of foresters, resulting from the harvesting of resources minus living expenses.


### Forester population
Number of foresters, which changes during a simulation only through the death of foresters.



# Model information

Teaching materials for the model:
https://docs.google.com/document/d/1xyE6yQidMVKwD_IvQ7pKE2qk2YPbnK5ym6TqAQ9X24M/edit?usp=sharing


## References and citation


For the model itself:

* Hanisch, S. (2022). Use of a community resource (forest). OpenEvo NetLogo models. https://openevo.eva.mpg.de/teachingbase/netlogo

For the NetLogo software:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.


## License

![CC BY-NC-SA 4.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/deed.de
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
NetLogo 6.3.0
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
