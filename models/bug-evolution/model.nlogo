breed [ preds Pred ]

breed [ bugs bug ]

bugs-own [
  speed             ;; either 1, 2, 3, 4, 5, or 6
]

preds-own [
  nearest-bug
]

globals [
  catches-by-speed  ;; a list of total bugs caught, where the list index is the speed minus one
]

to setup
  clear-all
  set-default-shape bugs "bug"

  ask patches [ set pcolor white ]   ;; white background
  set catches-by-speed n-values 6 [ 0 ]
  foreach [ 1 2 3 4 5 6 ] [ the-speed ->
    create-bugs number-bugs-per-speed [ set speed the-speed ]
  ]
  ask bugs [
    setxy random-xcor random-ycor
    set-color
  ]
  ;; the predator breed contains one turtle that is used to represent
  ;; a predator of the bugs (a bird)
  create-preds 5 [
    ifelse Predator = "Bird" [
      set shape "bird"
    ]
      [ set shape "spider"
    ]
    setxy random-xcor random-ycor
    set color black
    set size 2
  ]
  reset-ticks
end

to go
  ;; use EVERY to limit the overall speed of the model

    check-caught

    ifelse Predator = "Bird"
      [ask preds [
       move-predator
      set shape "bird"  ]]
     [ask preds [ set shape "spider"  ]]
    ;; recolor the bugs in case the user changed SPEED-COLOR-MAP
    ask bugs [
      set-color
      move-bug

    ;; advance the clock without plotting

    ;; plotting takes time, so only plot every 10 ticks
    ;;if ticks mod 10 = 0 [ update-plots ]
  ]
  tick
end


to move-predator
  rt random 20
  lt random 20
  find-nearest-bug
  set heading towards nearest-bug
  fd 0.15
end


to move-bug
  let candidate-predator nobody
  let target-heading 0

  if bugs-waggle? [ right (random-float 45 - random-float 45) ]
  fd speed * 0.06

  ifelse Predator = "Bird" [
    let predators-in-view preds in-cone 2 120
    ifelse any? predators-in-view [
      set candidate-predator one-of predators-in-view
      set target-heading 180 + towards candidate-predator
      set heading target-heading
      set label "!"
    ]
    [ set label "" ]
  ]
  [ set label "" ]
end

to find-nearest-bug
  set nearest-bug min-one-of bugs [distance myself]
end


to check-caught
  let prey [ bugs in-radius (size / 2) ] of one-of preds
  ;; no prey here? oh well
  if not any? prey [ stop ]
  ;; eat only one of the bugs at the mouse location
  ask one-of prey [
    let n item (speed - 1) catches-by-speed
    set catches-by-speed replace-item (speed - 1) catches-by-speed (n + 1)
    die
  ]
  ;; replace the eaten bug with a random offspring from the remaining population
  ask one-of bugs [ hatch 1 [ rt random 360 ] ]
end

to-report colors-by-speed
  ;; report a list of bug colors by speed
  report [ violet blue green brown orange red ]
end

to set-color  ;; turtle procedure
  set color item (speed - 1) colors-by-speed
end


; Copyright 2005 Uri Wilensky.
; See Info tab for full copyright and license.
@#$#@#$#@
GRAPHICS-WINDOW
350
10
887
548
-1
-1
23.0
1
10
1
1
1
0
1
1
1
-11
11
-11
11
1
1
1
Model rounds
30.0

MONITOR
10
545
187
590
Total number of caught bugs
sum catches-by-speed
0
1
11

BUTTON
10
70
102
110
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
210
70
271
110
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

PLOT
900
275
1355
545
Histogram of the bug population
Speed
Number of bugs
0.0
8.0
0.0
50.0
true
false
"" ";; the HISTOGRAM primitive can't make a multi-colored histogram,\n;; so instead we plot each bar individually\nclear-plot\nforeach [ 1 2 3 4 5 6 ] [ the-speed ->\n  create-temporary-plot-pen (word the-speed)\n  set-plot-pen-mode 1 ; bar mode\n  set-plot-pen-color item (the-speed - 1) colors-by-speed\n  plotxy the-speed count bugs with [ speed = the-speed ]\n]"
PENS

PLOT
10
160
305
345
Average bug speed
Model round
Speed
0.0
1000.0
0.0
0.5
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks mean [speed] of bugs"

SLIDER
10
10
237
43
number-bugs-per-speed
number-bugs-per-speed
1
50
50.0
1
1
NIL
HORIZONTAL

PLOT
10
350
305
540
Caught bugs by speed
Speed
Number of bugs
0.0
8.0
0.0
10.0
true
false
"" ";; the HISTOGRAM primitive can't make a multi-colored histogram,\n;; so instead we plot each bar individually\nclear-plot\nforeach [ 1 2 3 4 5 6 ] [ the-speed ->\n  create-temporary-plot-pen (word the-speed)\n  set-plot-pen-mode 1 ; bar mode\n  set-plot-pen-color item (the-speed - 1) colors-by-speed\n  plotxy the-speed item (the-speed - 1) catches-by-speed\n]"
PENS

SWITCH
10
120
175
153
bugs-waggle?
bugs-waggle?
1
1
-1000

CHOOSER
245
10
337
55
Predator
Predator
"Bird" "Spider"
1

PLOT
900
10
1355
265
Evolution of the bug population
Model round
Number of bugs
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Speed level 1" 1.0 0 -14454117 true "" "plot count bugs with [speed = 1]"
"Speed level 2" 1.0 0 -8990512 true "" "plot count bugs with [speed = 2]"
"Speed level 3" 1.0 0 -10899396 true "" "plot count bugs with [speed = 3]"
"Speed level 4" 1.0 0 -1184463 true "" "plot count bugs with [speed = 4]"
"Speed level 5" 1.0 0 -955883 true "" "plot count bugs with [speed = 5]"
"Speed level 6" 1.0 0 -2674135 true "" "plot count bugs with [speed = 6]"

BUTTON
110
70
202
110
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
1

@#$#@#$#@
## What does this model simulate?

The model simulates the evolution of speed in a bug population. Bugs are eaten by predators. The predators can be birds or spiders. Depending on the predator species, there is a different selecton pressure on the speed of the bugs.

## How does the model work?

The following processes occur in the model during each round:

* If the predator is a bird, the predators move a certain distance toward the nearest bug.

* Bugs change color to reflect their speed level.

* Bugs move forward, possibly with a random rotation if waggle motion is enabled.

* Predators capture one of the nearest bugs.

* The captured bug dies (disappears from the bug population).

* A randomly selected bug in the population produces offspring.


### Parameters:

* Number of bugs per speed: The number of bugs at each speed at the start of a simulation. Since there are six speed levels, the total number of bugs in the population is the value shown here multiplied by six.

* Predator: The type of predator – bird or spider. Birds move around, while spiders remain in one place.

* Waggle?: If this is enabled, the bugs move forward with a random rotation.


### Output Diagrams and Monitors

* Average bug speed: Shows the development of the average speed in the total population

* Caught bugs by speed: A histogram (bar chart) showing the number of captured bugs for each speed level.

* Total number of caught bugs: The total number of captured bugs during a simulation.

* Evolution of the bug population: Development of the number of bugs for each speed level

* Histogram of the bug population: A histogram (bar chart) showing the number of bugs in the total population for each speed level.

## Possible research questions and assignments

What influence does the type of predator have on the development of the bug population?

Why does the composition of the bug population change during the simulation?

Explain the process of natural selection using the observable development of the bug population.

Explain the concept of adaptation using the observable distribution of traits (speed levels) in the bug population.

What influence does waggle movement have on the development of the bug population?

Advanced / Computer Science: Change further parameters in the source code, e.g., locomotion or the number of predators, and observe how this affects the development of the bug population.
 

### Citation 

For the model: Hanisch, S. (2024). Bug evolution. https://openevo.eva.mpg.de/teachingbase/netlogo/. Adapted from Novak, M. and Wilensky, U. (2005). NetLogo Bug Hunt Speeds model. http://ccl.northwestern.edu/netlogo/models/BugHuntSpeeds. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL


NetLogo-Software: Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE


![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
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

bird
true
0
Polygon -7500403 true true 151 170 136 170 123 229 143 244 156 244 179 229 166 170
Polygon -16777216 true false 152 154 137 154 125 213 140 229 159 229 179 214 167 154
Polygon -7500403 true true 151 140 136 140 126 202 139 214 159 214 176 200 166 140
Polygon -16777216 true false 151 125 134 124 128 188 140 198 161 197 174 188 166 125
Polygon -7500403 true true 152 86 227 72 286 97 272 101 294 117 276 118 287 131 270 131 278 141 264 138 267 145 228 150 153 147
Polygon -7500403 true true 160 74 159 61 149 54 130 53 139 62 133 81 127 113 129 149 134 177 150 206 168 179 172 147 169 111
Circle -16777216 true false 144 55 7
Polygon -16777216 true false 129 53 135 58 139 54
Polygon -7500403 true true 148 86 73 72 14 97 28 101 6 117 24 118 13 131 30 131 22 141 36 138 33 145 72 150 147 147

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

spider
true
0
Polygon -7500403 true true 134 255 104 240 96 210 98 196 114 171 134 150 119 135 119 120 134 105 164 105 179 120 179 135 164 150 185 173 199 195 203 210 194 240 164 255
Line -7500403 true 167 109 170 90
Line -7500403 true 170 91 156 88
Line -7500403 true 130 91 144 88
Line -7500403 true 133 109 130 90
Polygon -7500403 true true 167 117 207 102 216 71 227 27 227 72 212 117 167 132
Polygon -7500403 true true 164 210 158 194 195 195 225 210 195 285 240 210 210 180 164 180
Polygon -7500403 true true 136 210 142 194 105 195 75 210 105 285 60 210 90 180 136 180
Polygon -7500403 true true 133 117 93 102 84 71 73 27 73 72 88 117 133 132
Polygon -7500403 true true 163 140 214 129 234 114 255 74 242 126 216 143 164 152
Polygon -7500403 true true 161 183 203 167 239 180 268 239 249 171 202 153 163 162
Polygon -7500403 true true 137 140 86 129 66 114 45 74 58 126 84 143 136 152
Polygon -7500403 true true 139 183 97 167 61 180 32 239 51 171 98 153 137 162

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
setup
ask predators [ show-turtle ]
repeat 15 [ ask bugs [ move-bug ] ]
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
1
@#$#@#$#@
