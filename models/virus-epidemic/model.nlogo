turtles-own
  [ sick?                ;; if true, the turtle is infectious
    sick-time            ;; how long, in weeks, the turtle has been infectious
    vaccinated?          ;; whether vaccinated
    immunity-duration    ;; how many weeks immunity lasts?
    remaining-immunity   ;; how many weeks of immunity the turtle has left
    immune?
    dying?              ;; whether dying from infection
    age ]                 ;; how many weeks old the turtle is

globals
  [ %infected            ;; what % of the population is infectious
    %immune              ;; what % of the population is immune
    lifespan             ;; the lifespan of a turtle
    chance-reproduce     ;; the probability of a turtle generating an offspring each tick
    carrying-capacity    ;; the number of turtles that can be in the world at one time
    chance-infection
    number-dead ]        ;; how many died from infection

;; The setup is divided into four procedures
to setup
  clear-all
  setup-constants
  setup-turtles
  update-global-variables
  update-display
  reset-ticks
end

;; This sets up basic constants of the model.
to setup-constants
  set lifespan 80 * 52      ;; 80 times 52 weeks
  set chance-reproduce 1
  set carrying-capacity 500
end

;; We create a variable number of turtles of which a certain percentage are infected and a certain percentage is vaccinated,
;; and distribute them randomly
to setup-turtles
  create-turtles Number-people
    [ set shape "person"
      setxy random-xcor random-ycor
      set age random lifespan
      set sick-time 0
      set remaining-immunity 0
      set dying? false
      set vaccinated? false
      set size 1.5  ;; easier to see
      get-healthy
      if random-float 100 < Percent-infected [ get-sick ]
      if random-float 100 < Percent-vaccinated [set vaccinated? true]
      ifelse vaccinated? = false
      [set immunity-duration Duration-of-immunity
       set immune? false]
      [set immunity-duration 300
       set immune? true ]]
end

to go
  ifelse Mandatory-face-masks [set chance-infection 5][set chance-infection Chance-of-infection]
  ask turtles [
    get-older
    if Lockdown = false [ move ]
    if sick? [ recover-or-die ]
    ifelse sick? [ infect ] [ reproduce ]
  ]

  update-vaccinated

  update-global-variables

  death-from-infection

  update-display
  tick
end

to get-older ;; turtle procedure
  set age age + 1
  if age > lifespan [ die ]  ;; Turtles die of old age once their age exceeds the lifespan (set at 80 years in this model).
  if immune? [ set remaining-immunity remaining-immunity - 1 ]
  if sick? [ set sick-time sick-time + 1 ]
  if remaining-immunity < 0 [set immune? false]
end

to move ;; turtle procedure,Turtles move about at random.
  rt random 100
  lt random 100
  fd 1
end

;; Once the turtle has been sick long enough, it either recovers (and becomes immune) or it dies.
to recover-or-die ;; turtle procedure
  if sick-time > Duration-of-illness                        ;; If the turtle has survived past the virus' duration, then
    [ ifelse random-float 100 < Chance-of-recovery   ;; either recover or die
      [ become-immune ]
      [ set dying? true ] ]
end

;; If a turtle is sick, it infects other turtles in the vicinity.
to infect ;; turtle procedure
  ask other turtles in-radius Infection-radius with [ not sick? and not immune? ] ;; Immune turtles don't get sick.
    [ if random-float 100 < chance-infection
      [ get-sick ] ]
end

to get-sick ;; turtle procedure
  set sick? true
  set remaining-immunity 0
end

to get-healthy ;; turtle procedure
  set sick? false
  set dying? false
  set remaining-immunity 0
  set sick-time 0
end

to become-immune ;; turtle procedure
  set sick? false
  set immune? true
  set sick-time 0
  set remaining-immunity immunity-duration
end

;; If there are less turtles than the carrying-capacity then turtles can reproduce.
to reproduce
  if count turtles < carrying-capacity and random-float 100 < chance-reproduce
    [ hatch 1
      [ set age 1
        lt 45 fd 1
        get-healthy ] ]
end

to update-vaccinated
  ifelse count turtles with [vaccinated?]  < (count turtles * Percent-vaccinated / 100)
    [ask n-of (((count  turtles * Percent-vaccinated / 100) - count turtles with [vaccinated?]) * Percent-vaccinated / 100) turtles with [vaccinated? = false and sick? = false]
      [set vaccinated? true
       set immunity-duration 300
       set immune? true ]]
    [ask n-of ((count turtles with [vaccinated?]) - (count  turtles * Percent-vaccinated / 100)) turtles with [vaccinated? = true]
      [set vaccinated? false
       set immunity-duration Duration-of-immunity
       ]]
end

to update-global-variables
  if count turtles > 0
    [ set %infected (count turtles with [ sick? ] / count turtles) * 100
      set %immune (count turtles with [ immune? ] / count turtles) * 100
      set number-dead number-dead + (count turtles with [ dying? ] ) ]
end

to death-from-infection
  ask turtles with [dying?] [die]
end

to update-display
  ask turtles
      [ifelse sick? [ set color red] [set color green]
       ifelse vaccinated? = false
        [ if immune? [ set color cyan]]
            [ set color blue ]]
end

to new-infection ;; release a new infection in the population
  ask one-of turtles with [immune? = false and sick? = false] [ get-sick ]
end
@#$#@#$#@
GRAPHICS-WINDOW
405
10
920
526
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-19
19
-19
19
1
1
1
Model rounds
30.0

SLIDER
15
290
220
323
Duration-of-illness
Duration-of-illness
0.0
99.0
4.0
1.0
1
weeks
HORIZONTAL

SLIDER
15
250
222
283
Chance-of-recovery
Chance-of-recovery
0.0
99.0
70.0
1.0
1
%
HORIZONTAL

SLIDER
15
170
220
203
Chance-of-infection
Chance-of-infection
0.0
100.0
50.0
1.0
1
%
HORIZONTAL

BUTTON
15
10
102
50
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
205
10
276
50
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
950
10
1535
370
Population
Weeks
% of the population
0.0
0.0
0.0
100.0
true
true
"" ""
PENS
"sick" 1.0 0 -2674135 true "" "plot count turtles with [ sick? ] / count turtles * 100"
"healthy" 1.0 0 -10899396 true "" "plot count turtles with [ not sick? and not immune? ]  / count turtles * 100"
"immune" 1.0 0 -11221820 true "" "plot count turtles with [ immune? ]  / count turtles * 100"
"vaccinated" 1.0 0 -13345367 true "" "plot count turtles with [vaccinated?]  / count turtles * 100"

SLIDER
15
60
220
93
Number-people
Number-people
10
600
500.0
1
1
NIL
HORIZONTAL

BUTTON
110
10
197
50
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

SLIDER
15
330
217
363
Duration-of-immunity
Duration-of-immunity
0
300
16.0
1
1
weeks
HORIZONTAL

SLIDER
15
100
220
133
Percent-infected
Percent-infected
0
100
1.0
1
1
%
HORIZONTAL

SWITCH
15
485
145
518
Lockdown
Lockdown
1
1
-1000

SLIDER
15
210
220
243
Infection-radius
Infection-radius
0
10
1.0
1
1
m
HORIZONTAL

SLIDER
15
525
187
558
Percent-vaccinated
Percent-vaccinated
0
100
0.0
1
1
NIL
HORIZONTAL

TEXTBOX
225
335
400
376
Duration of natural immunity after an infection
12
0.0
1

TEXTBOX
195
530
365
571
With vaccination, the duration of immunity is 300 weeks.
12
0.0
1

SWITCH
15
445
187
478
Mandatory-face-masks
Mandatory-face-masks
1
1
-1000

TEXTBOX
195
445
395
486
With mandatory face masks, the chance of infection is reduced to 5%.
12
0.0
1

TEXTBOX
225
215
385
256
At which distance from others is there a threat of infection?
12
0.0
1

BUTTON
15
370
127
403
New infection
new-infection
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
135
370
285
401
Creates a new infection in the population
12
0.0
1

TEXTBOX
20
145
170
163
Virus parameters
14
0.0
1

TEXTBOX
20
420
195
451
Public health measures
14
0.0
1

PLOT
950
375
1235
560
Number of deaths through infection
Weeks
Number
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot number-dead"

MONITOR
1255
375
1350
432
Years
ticks / 52
2
1
14

@#$#@#$#@
# What does this model simulate?

The model simulates the spread of a viral infection in a population. Several factors related to the virus and the course of the disease, as well as measures implemented by the health system, influence the spread of the virus.

# How does the model work?

## The following processes occur in the model in each round:

* The risk of infection is updated depending on whether a mask mandate is in effect.

* Individuals age by one week. When individuals reach the age of 80, they die.

* If individuals are sick or immune, they increase the duration of their illness and immunity by one week.

* If there is no lockdown, individuals move one step in a random direction.

* When individuals reach the specified duration of illness, they recover with a probability of recovery and become immune. If they do not recover, they die.

* Sick individuals infect other individuals within a radius of infection with a probability of chance-of-infection.

* Healthy individuals produce healthy offspring with a probability of 1%.

* The percentage of vaccinated individuals in the population is updated (depending on the parameter "percent vaccinated").

* The color of individuals is adjusted according to their status.

* Clicking on "New Infection" will infect a randomly selected person who is neither immune nor currently ill.


## Parameters:
*  Number-people: population size

*  Percent-infected: the percentage of infected people in the initial population

*  Chance-of-infection: the probability that an infected person infects another person

*  Infection-radius: the radius in meters within which one person can infect another person in close proximity (the larger the radius, the faster a virus can spread)

*  Chance-of-recovery: the probability that an infected person will recover (if they do not recover, they will die)

*  Duration-of-illness: the duration of the illness in weeks (one model round represents one week)

*  Duration-of-immunity: the duration of immunity after infection

*  Mandateory-face-masks: whether face masks are mandatory (in this case, the risk of infection is set to 5%)

*  Lockdown: whether a lockdown is in place (in this case, people no longer move about)

*  Percent-vaccinated: the proportion of vaccinated individuals in the population. With vaccination, the duration of immunity is 300 weeks.


## Out put diagrams and monitors

* Population: The percentage of infected, healthy, immune, and vaccinated individuals in the population

* Number of ceaths due to infection: The total number of deaths from infection during the simulation

# Possible research questions and assignments

*  What influence do the parameters of the virus and the course of the disease have on the course of the epidemic?

*  What influence do mandatory mask-wearing, lockdowns, and vaccination rates have on the spread of the virus?

*  Under which parameter settings can one speak of herd immunity?

*  Refute or confirm the following hypothesis: The higher the risk of infection, the more people will die from the virus.

You are responsible for a country's health system. A novel virus is detected in 1% of the population. Your task is to advise the government on what measures should be taken to contain the spread of the virus and prevent deaths. The virus spreads through the air, and according to current research, the infection rate is 90% with an infection radius of up to 1 meter. The illness lasts 4 weeks, and 10% of those infected have died. People who recover from the infection are immune for 20 weeks.

* The government wants to know how many deaths can be expected after two years if no measures are taken.

*  What measures do you recommend to the government to contain the virus and prevent deaths? Explain your recommendations, also considering the further consequences of the measures.

Computer Science: Change other parameters in the source code, e.g., lifespan, reproductive chances, movement, or maximum population size, and observe how this affects the development of virus epidemic.
 

# Citation 

For the model:

Hanisch, S. (2025). Virus epidemic. https://openevo.eva.mpg.de/teachingbase/netlogo/. Adapted from: Wilensky, U. (1998).  NetLogo Virus - Circle Visualization model.  http://ccl.northwestern.edu/netlogo/models/Virus-CircleVisualization.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

NetLogo-Software:

Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.


## Licence


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
