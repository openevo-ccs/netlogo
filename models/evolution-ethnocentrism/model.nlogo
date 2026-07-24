turtles-own [
  energy
  cooperate-with-same?
  cooperate-with-different?
 ]

;; creates a world with an agent on each patch
to setup-full
  clear-all
  ask patches [ create-turtle ]
  reset-ticks
end

;; creates a new agent in the world
to create-turtle  ;; patch procedure
  sprout 1 [
    set shape random-shape

    ;; determine the strategy for interacting with someone of the same color
    set cooperate-with-same? (random-float 100 < Percent-cooperate-with-same)

    ;; determine the strategy for interacting with someone of a different color
    if Number-ethnicities > 1 [set cooperate-with-different? (random-float 100 < Percent-cooperate-with-different)

      ;; change the color of the agent on the basis of the strategy
      update-color2]
    if Number-ethnicities = 1 [update-color1]
    set energy 50
  ]
end

to-report random-shape
  if Number-ethnicities = 1 [ report "circle" ]
  if Number-ethnicities = 2 [ report one-of [ "circle" "x"  ] ]
  if Number-ethnicities = 3 [ report one-of [ "circle" "x" "square"  ] ]
  if Number-ethnicities = 4 [ report one-of [ "circle" "x" "square" "triangle" ] ]
  if Number-ethnicities = 5 [ report one-of [ "circle" "x" "square" "triangle" "circle 2"] ]
  if Number-ethnicities = 6 [ report one-of [ "circle" "x" "square" "triangle" "circle 2" "square 2" ] ]
end

;;;;;;;;;;;;;;;;;;;;;;;;
;;;Runtime Procedures;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to go
  if count turtles = 0 [stop]

  if interaction = "local" [ask turtles [ interact-local ]]
  if interaction = "anywhere" [ask turtles [interact-anywhere]]

  ask turtles [ reproduce ]
  ask turtles [ expand-energy]
  death           ;; kill some of the agents
  tick
end


to interact-local  ;; turtle procedure, interact with Moore neighborhood
  ask turtles-on one-of neighbors  [
    if shape = [shape] of myself [
    if cooperate-with-same? = true
       [ifelse [cooperate-with-same?] of myself
          [ ask myself [ set energy energy + A ]
            set energy  energy + A ]
          [ ask myself [ set energy energy + B]
            set energy energy + C]]
    if cooperate-with-same? = false
          [ifelse [cooperate-with-same?] of myself
          [ ask myself [ set energy energy + C ]
            set energy  energy + B ]
          [ ask myself [ set energy energy + D]
              set energy energy + D]  ]
      ]

    ;; if we are different shapes we take a different strategy
    if shape != [shape] of myself [
      if cooperate-with-different? = true
       [ifelse [cooperate-with-different?] of myself
          [ ask myself [ set energy energy + A ]
            set energy  energy + A ]
          [ ask myself [ set energy energy + B]
            set energy energy + C]]
    if cooperate-with-different? = false
          [ifelse [cooperate-with-different?] of myself
          [ ask myself [ set energy energy + C ]
            set energy  energy + B ]
          [ ask myself [ set energy energy + D]
              set energy energy + D]  ]
      ]
     ]
end

to interact-anywhere  ;; turtle procedure, interact with any random patch
  ask turtles-on one-of patches [

    if shape = [shape] of myself [
    if cooperate-with-same? = true
       [ifelse [cooperate-with-same?] of myself
          [ ask myself [ set energy energy + A ]
            set energy  energy + A ]
          [ ask myself [ set energy energy + B]
            set energy energy + C]]
    if cooperate-with-same? = false
          [ifelse [cooperate-with-same?] of myself
          [ ask myself [ set energy energy + C ]
            set energy  energy + B ]
          [ ask myself [ set energy energy + D]
              set energy energy + D]  ]
      ]

    ;; if we are different colors we take a different strategy
    if shape != [shape] of myself [
      if cooperate-with-different? = true
       [ifelse [cooperate-with-different?] of myself
          [ ask myself [ set energy energy + A ]
            set energy  energy + A ]
          [ ask myself [ set energy energy + B]
            set energy energy + C]]
      if cooperate-with-different? = false
          [ifelse [cooperate-with-different?] of myself
          [ ask myself [ set energy energy + C ]
            set energy  energy + B ]
          [ ask myself [ set energy energy + D]
              set energy energy + D]  ]
      ]
    ]
end

;; use energy to determine if the agent gets to reproduce
to reproduce  ;; turtle procedure
      let birthrate 0.001 * energy
    if random-float 1 < birthrate and energy >= 100 [
  ;;if energy >= 100 [
    ;; find an empty location to reproduce into
    if offspring-placement = "local"
    [let destination one-of neighbors with [not any? turtles-here]
     if destination != nobody [
      ;; if the location exists hatch a copy of the current turtle in the new location
      ;;  but mutate the child
      hatch 1 [
        move-to destination
        mutate
        set energy 50
           ]
          ]
      set energy energy - 50
       ]
    if offspring-placement = "anywhere"
    [ let destination one-of patches with [not any? turtles-here]
     if destination != nobody [
      ;; if the location exists hatch a copy of the current turtle in the new location
      ;;  but mutate the child
      hatch 1 [
        move-to destination
        mutate
        set energy 50
           ]
          ]
       set energy energy - 50
    ]
  ]
end

;; modify the children of agents according to the mutation rate
to mutate  ;; turtle procedure
  ;; mutate the color
 if Number-ethnicities > 1
  [ if random-float 100 < Mutation-rate [
    let old-shape shape
    while [shape = old-shape]
      [ set shape random-shape ] ]
   if random-float 100 < Mutation-rate [
    set cooperate-with-different? not cooperate-with-different?
  ] ]
   if random-float 100 < Mutation-rate
    [ set cooperate-with-same? not cooperate-with-same? ]
  ifelse Number-ethnicities > 1 [update-color2][update-color1]
end

to expand-energy
  set energy energy - living-costs
end

to death
    ask turtles [
    if energy <= 0 [ die ]
    if random-float 100 < Death-rate [ die ]]
end

to update-color1
  ifelse cooperate-with-same? [set color green] [set color red]
end

;; make sure the shape matches the strategy
to update-color2
  ;; if the agent cooperates with same they are a circle
  ifelse cooperate-with-same? [
    ifelse cooperate-with-different?
      [ set color green ]    ;; filled in circle (altruist)
      [ set color orange ]  ;; empty circle (ethnocentric)
  ]
  ;; if the agent doesn't cooperate with same they are a square
  [
    ifelse cooperate-with-different?
      [ set color turquoise ]    ;; filled in square (cosmopolitan)
      [ set color red ]  ;; empty square (egoist)
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
273
10
781
519
-1
-1
10.0
1
10
1
1
1
0
1
1
1
0
49
0
49
1
1
1
ticks
30.0

BUTTON
186
10
269
43
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
785
10
1276
256
Frequency of strategies
Iterations
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Altruists" 1.0 0 -10899396 true "" "plotxy ticks count turtles with [color = green] / count turtles"
"Ethnocentrists" 1.0 0 -817084 true "" "if Number-ethnicities > 1 [plotxy ticks count turtles with [color = orange] / count turtles]"
"Cosmopolitans" 1.0 0 -14835848 true "" "if Number-ethnicities > 1 [plotxy ticks count turtles with [color = turquoise] / count turtles]"
"Selfish" 1.0 0 -2674135 true "" "plotxy ticks count turtles with [color = red] / count turtles"

BUTTON
8
10
94
43
Setup
setup-full
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
100
10
182
43
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

CHOOSER
7
51
105
96
Number-ethnicities
Number-ethnicities
1 2 3 4 5 6
2

CHOOSER
121
177
259
222
offspring-placement
offspring-placement
"local" "anywhere"
0

CHOOSER
8
177
114
222
interaction
interaction
"local" "anywhere"
0

SLIDER
8
308
152
341
Living-costs
Living-costs
0
10
2.5
0.5
1
NIL
HORIZONTAL

INPUTBOX
49
408
99
468
A
3.0
1
0
Number

INPUTBOX
167
408
217
468
C
0.0
1
0
Number

INPUTBOX
219
408
269
468
B
5.0
1
0
Number

INPUTBOX
168
478
218
538
D
1.0
1
0
Number

SLIDER
7
233
152
266
Mutation-rate
Mutation-rate
0
10
0.5
0.5
1
%
HORIZONTAL

SLIDER
7
270
153
303
Death-rate
Death-rate
0
10
0.5
0.5
1
%
HORIZONTAL

SLIDER
8
101
258
134
Percent-cooperate-with-same
Percent-cooperate-with-same
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
8
139
258
172
Percent-cooperate-with-different
Percent-cooperate-with-different
0
100
50.0
1
1
%
HORIZONTAL

INPUTBOX
101
408
151
468
A
3.0
1
0
Number

TEXTBOX
9
353
280
409
PAYOFF MATRIX:\n               \n                         Cooperate                          Defect\n------------------------------------------------------------------
11
0.0
1

TEXTBOX
159
405
174
545
|\n|\n|\n|\n|\n|\n|\n|\n|\n|
11
0.0
1

TEXTBOX
11
417
49
501
Coop.\n\n\n\n\nDefect
11
0.0
1

INPUTBOX
220
478
270
538
D
1.0
1
0
Number

INPUTBOX
49
478
99
538
B
5.0
1
0
Number

INPUTBOX
101
478
151
538
C
0.0
1
0
Number

PLOT
785
261
1276
519
Average energy per strategy
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Altruists" 1.0 0 -10899396 true "" "carefully [plot sum [energy] of turtles with [color = green ] / count turtles with [color = green]][plot 0]"
"Ethnocentrists" 1.0 0 -955883 true "" "if Number-ethnicities > 1 [carefully [plot sum [energy] of turtles with [color = orange ] / count turtles with [color = orange ]][plot 0]]"
"Cosmopolitans" 1.0 0 -14835848 true "" "if Number-ethnicities > 1 [carefully [plot sum [energy] of turtles with [ color = turquoise ] / count turtles with [ color = turquoise ]][plot 0]]"
"Selfish" 1.0 0 -2674135 true "" "carefully [plot sum [energy] of turtles with [color = red ] / count turtles with [color = red]][plot 0]"

PLOT
785
527
1117
714
Frequency of ethnicities
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
"Circles" 1.0 0 -16777216 true "" "plot count turtles with [shape = \"circle\"] / count turtles"
"X" 1.0 0 -7500403 true "" "plot count turtles with [shape = \"x\"] / count turtles"
"Square" 1.0 0 -10402772 true "" "plot count turtles with [shape = \"square\"] / count turtles"
"Triangle" 1.0 0 -5825686 true "" "plot count turtles with [shape = \"triangle\"] / count turtles"
"Empty circle" 1.0 0 -3026479 true "" "plot count turtles with [shape = \"circle 2\"] / count turtles"
"Empty square" 1.0 0 -3889007 true "" "plot count turtles with [shape = \"square 2\"] / count turtles"

@#$#@#$#@
# Model purpose
What is the purpose of the model?

This model simulates the biological evolution of cooperators and cheaters in the world. Agents are also part of ethnicities, and their behaviors depend also on whether the agent they interact with is of their own or a different ethnicity. 

Outcomes of behaviors are represented in a payoff matrix and one can observe how different payoff structures affect the evolution of the population.

Furthermore, one can observe the role of assortment and population structure in the evolution of the population. Agents either interact with one of their neighbors, or interact randomly with anyone in the world. Agents can either place their offspring on a neighboring empty patch, or anywhere in the world. Local interaction and offspring placement is advantageous for cooperators, highlighting the role of kin selection and frequency-dependent selection.

The model is based on Robert Axelrod and Ross A. Hammond and it suggests that “ethnocentric” behavior can be adaptive compared to selfish or altruistic behavior in a structured population with social markers.


# Entities and variables
What kinds of entities are in the model? By what state variables, or attributes, are these entities characterized? What are the temporal and spatial resolutions and extents of the model?

## General environment

### Changeable variables

* _Living-costs_: the costs that each agent has to deduct from his energy per iteration for basic survival
* _Mutation-rate_: The probability with which offspring agents have other traits than their parents
* _Death-rate_: The probability with which agents die independent of their energy level
* Payoffs for strategies (variables A, B, C, D): the different payoffs in energy units that agents get from interacting with other agents..
(these variables could be considered both a factor of the environment and a variable of the agents, but we list them here since they do not vary among agents and are rather “imposed” from the environment)

## Patches
 
There are 50*50 patches in the world. Patches do not have any variables.


## Agents

There can be a maximum of 2500 agents in the world (1 per patch).

### Constant agent variables and behaviors
(these variables and behaviors are always the same for all of the agents of this type and in each iteration)

* ethnicity / shape: the shape of the agent, representing its “ethnicity”. Up to six ethnicities/shapes can be included in the total population.
* _cooperate-with-same_: whether agents cooperate with those of the same ethnicity, true or false
* _cooperate-with-different_: whether agents cooperate with those of other ethnicities, true or false 
* color: based on the combination of cooperate-with-same and cooperate-with-different the agent is given a color (green, orange, turquoise, red)
* In each iteration, each agent attempts to interact with another agent.

### Changeable agent variables
(variables that are changeable by the user on the interface): 

* _Number of ethnicities_: The number of ethnicities in the population
* _percent-cooperate-with-same_: The percentage of agents that cooperate with other agents of the same ethnicity
* _percent-cooperate-with-different_: The percentage of agents that cooperate with other agents of different ethnicities
* _Interaction_: local or anywhere - if local, then agents interact with one of the agents on a neighboring patch; if anywhere, then agents interact with one of the agents anywhere in the world
* _Placement of offspring_: local or anywhere, if local, then agents place offspring on one of the unoccupied patches in the neighborhood; if anywhere, then agents place offspring on any unoccupied patch in the world


### Changing variables during a simulation
(variables that change as a result of the simulation)

* _Energy_: the energy level of an agent in units 
* Offspring have a different traits from their parents with a probability of _Mutation-rate_.


# Model Setup
What is the initial state of the model world when one clicks on Setup? Is initialization always the same, or does it vary among simulations?

* A world with 2500 patches is created.
* Each patch creates one agent. Each agent is randomly assigned one of the ethnicities (shapes).
* A fraction of agents, set by the parameter _Percent-cooperate-with-same_, gets the variable _cooperate-with-same_ set to true, the rest get the the variable _cooperate-with-same_ set to false
* A fraction of agents, set by the parameter _Percent-cooperate-with-different_, gets the _cooperate-with-different_ set to true, the rest get the the variable _cooperate-with-different_ set to false
* The agents are assigned colors based on their combination of traits:
    * green (altruists): cooperate-with-same = true; cooperate-with-different = true
    * orange (ethnocentrists):  cooperate-with-same = true; cooperate-with-different = false
    * turquoise (cosmopolitans):  cooperate-with-same = false; cooperate-with-different = true
    * red (selfish):  cooperate-with-same = false; cooperate-with-different = false
* The initial level of energy of agents is set at 50.


# Model Processes
What happens in each iteration? Which entities do what, and in what order? When are state variables updated?

![Model processes image](https://openevo.eva.mpg.de/wp-content/uploads/NetLogo-model-Ethnocentrism-procedures-overview.png)

# Outputs
What kinds of model outcomes can be observed on the interface? How do they emerge from model parameters, agent behaviors, and interactions?


## In the world
Agents reproduce and die. The spread of different strategies and ethnicities can be observed. If agents interact locally and/or place offspring on neighboring patches, clusters of “related” agents tend to form. 
 

## Output diagrams and monitors

### Frequencies of strategies
The relative frequencies of agents in the population by strategy, resulting from mutations, different reproduction rates, and death.

### Average energy of agents per strategy
Average energy levels of agents by strategy, resulting from payoffs, minus living costs and reproduction.

### Frequencies of ethnicities
The relative frequencies of agents in the population by ethnicity.


# Concepts and Principles
Which important concepts or principles are represented in the model?


**Trait variation**
Three types of traits vary in the population: ethnicity, _cooperate-with-same_ (true or false), _cooperate-with-different_ (true or false). Four strategies emerge from the combinations of _cooperate-with-same_ (true or false), _cooperate-with-different_ (true or false). Traits can vary randomly in the population through the parameter _mutation rate_.

**Reproductive fitness**
Agents that have higher energy levels have higher chances of producing offspring. They have higher fitness relative to agents with lower energy levels.

**Inheritance**
Agents create offspring and inherit their trait variants (ethnicity, strategy) to their offspring (with some variability based on _mutation rate_)

**Natural selection**
The frequency of traits in the agent population changes as a result of trait variation, differential reproduction (fitness), and inheritance of traits. 

**Kin selection, multi-level selection, frequency-dependent selection, altruism**
If placement of offspring is local, then clusters of related or similar agents in terms of ethnicity as well as strategy can form. If interaction is local, then altruists and ethnocentrists benefit from having similar agents in their neighborhood, depending on settings in the payoff matrix. 
If placement of offspring is anywhere in the world, then clusters of related or similar agents do not form. Similarly, if interaction is with other agents anywhere in the world, agents are less likely to interact with other agents from the same ethnicity or strategy. Depending on settings in the payoff matrix, this can result in altruists or ethnocentrists having lower fitness compared to selfish agents.


**Sensing and Information Processing** 
Agents sense the ethnicity and strategy of other agents.
Agents do not store any information (i.e. have no memory).

**Objectives and goal-directed behavior**
Agents attempt to interact with other agents. 

**Learning and Adaptation**
Agents do not learn and do not adapt their behavior over their lifetimes.

**Interactions** 

* Agents interact directly through noticing each other and cooperating or defecting in direct interactions.
* Agents interact indirectly through competition for limited space for the placing of offspring.


**Role of randomness** 

* Agents take on a randomly chosen ethnicity at the beginning of the simulation.
* Agents take on their strategy traits randomly based on the probability _Percent-cooperate-with-same_ and _Percent-cooperate-with-different_.
* The order in which agents interact within one iteration is random.
* Agents randomly choose another agent to interact with (from a neighboring patch or from anywhere in the world). 
* The order in which agents produce offspring within one iteration is random.
* Agents reproduce with a probability of 0.001 * Energy.
* Agents place offspring on a randomly selected unoccupied patch (in the neighborhood or anywhere in the world).
* Offspring mutate with a probability of _Mutation-rate_.
* Agents die with a probability of _Death-rate_.

# Model Teaching Materials

Teaching materials for the model: https://openevo.eva.mpg.de/teachingbase/netlogo-evolution-of-ethnocentrism/

# References and citation

Axelrod, R., & Hammond, R. A. (2003). The Evolution of Ethnocentric Behavior. In: Midwest Political Science Convention April 3-6, 2003. Chicago, USA. http://www-personal.umich.edu/~axe/research/AxHamm_Ethno.pdf 

Hammond, R. A., & Axelrod, R. (2006). The Evolution of Ethnocentrism. Journal of Conflict Resolution, 50(6), 926–936. http://doi.org/10.1177/0022002706293470


If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Hanisch, S. (2022). Ethnocentrism with customizable payoff matrix. OpenEvo NetLogo Models.  https://openevo.eva.mpg.de/teachingbase/netlogo/
 
* Adapted from: Wilensky, U. (2003).  NetLogo Ethnocentrism model.  http://ccl.northwestern.edu/netlogo/models/Ethnocentrism.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

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
NetLogo 6.2.0
@#$#@#$#@
setup-full repeat 150 [ go ]
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Experiment 104" repetitions="10" runMetricsEveryStep="false">
    <setup>setup-empty</setup>
    <go>go</go>
    <timeLimit steps="2000"/>
    <metric>coopown-percent</metric>
    <metric>defother-percent</metric>
    <metric>consist-ethno-percent</metric>
    <metric>meetown-percent</metric>
    <metric>coop-percent</metric>
    <metric>last100coopown-percent</metric>
    <metric>last100defother-percent</metric>
    <metric>last100consist-ethno-percent</metric>
    <metric>last100meetown-percent</metric>
    <metric>last100coop-percent</metric>
    <metric>cc-percent</metric>
    <metric>cd-percent</metric>
    <metric>dc-percent</metric>
    <metric>dd-percent</metric>
    <enumeratedValueSet variable="gain-of-receiving">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-ptr">
      <value value="0.12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrants-per-day">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-same">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation-rate">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-giving">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-different">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experiment 105" repetitions="10" runMetricsEveryStep="false">
    <setup>setup-empty</setup>
    <go>go</go>
    <timeLimit steps="2000"/>
    <metric>coopown-percent</metric>
    <metric>defother-percent</metric>
    <metric>consist-ethno-percent</metric>
    <metric>meetown-percent</metric>
    <metric>coop-percent</metric>
    <metric>last100coopown-percent</metric>
    <metric>last100defother-percent</metric>
    <metric>last100consist-ethno-percent</metric>
    <metric>last100meetown-percent</metric>
    <metric>last100coop-percent</metric>
    <metric>cc-percent</metric>
    <metric>cd-percent</metric>
    <metric>dc-percent</metric>
    <metric>dd-percent</metric>
    <enumeratedValueSet variable="gain-of-receiving">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-ptr">
      <value value="0.12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrants-per-day">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-same">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation-rate">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-giving">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-different">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="100"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experiment 106" repetitions="10" runMetricsEveryStep="false">
    <setup>setup-empty</setup>
    <go>go</go>
    <timeLimit steps="4000"/>
    <metric>coopown-percent</metric>
    <metric>defother-percent</metric>
    <metric>consist-ethno-percent</metric>
    <metric>meetown-percent</metric>
    <metric>coop-percent</metric>
    <metric>last100coopown-percent</metric>
    <metric>last100defother-percent</metric>
    <metric>last100consist-ethno-percent</metric>
    <metric>last100meetown-percent</metric>
    <metric>last100coop-percent</metric>
    <metric>cc-percent</metric>
    <metric>cd-percent</metric>
    <metric>dc-percent</metric>
    <metric>dd-percent</metric>
    <enumeratedValueSet variable="gain-of-receiving">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-ptr">
      <value value="0.12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrants-per-day">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-same">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation-rate">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-giving">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-different">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experiment 107" repetitions="10" runMetricsEveryStep="false">
    <setup>setup-empty</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>coopown-percent</metric>
    <metric>defother-percent</metric>
    <metric>consist-ethno-percent</metric>
    <metric>meetown-percent</metric>
    <metric>coop-percent</metric>
    <metric>last100coopown-percent</metric>
    <metric>last100defother-percent</metric>
    <metric>last100consist-ethno-percent</metric>
    <metric>last100meetown-percent</metric>
    <metric>last100coop-percent</metric>
    <metric>cc-percent</metric>
    <metric>cd-percent</metric>
    <metric>dc-percent</metric>
    <metric>dd-percent</metric>
    <enumeratedValueSet variable="gain-of-receiving">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-ptr">
      <value value="0.12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrants-per-day">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-same">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation-rate">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-giving">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-different">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experiment 108" repetitions="10" runMetricsEveryStep="false">
    <setup>setup-empty</setup>
    <go>go</go>
    <timeLimit steps="2000"/>
    <metric>coopown-percent</metric>
    <metric>defother-percent</metric>
    <metric>consist-ethno-percent</metric>
    <metric>meetown-percent</metric>
    <metric>coop-percent</metric>
    <metric>last100coopown-percent</metric>
    <metric>last100defother-percent</metric>
    <metric>last100consist-ethno-percent</metric>
    <metric>last100meetown-percent</metric>
    <metric>last100coop-percent</metric>
    <metric>cc-percent</metric>
    <metric>cd-percent</metric>
    <metric>dc-percent</metric>
    <metric>dd-percent</metric>
    <enumeratedValueSet variable="gain-of-receiving">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-ptr">
      <value value="0.12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrants-per-day">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-same">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation-rate">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-giving">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-different">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experiment 109" repetitions="10" runMetricsEveryStep="false">
    <setup>setup-empty</setup>
    <go>go</go>
    <timeLimit steps="2000"/>
    <metric>coopown-percent</metric>
    <metric>defother-percent</metric>
    <metric>consist-ethno-percent</metric>
    <metric>meetown-percent</metric>
    <metric>coop-percent</metric>
    <metric>last100coopown-percent</metric>
    <metric>last100defother-percent</metric>
    <metric>last100consist-ethno-percent</metric>
    <metric>last100meetown-percent</metric>
    <metric>last100coop-percent</metric>
    <metric>cc-percent</metric>
    <metric>cd-percent</metric>
    <metric>dc-percent</metric>
    <metric>dd-percent</metric>
    <enumeratedValueSet variable="gain-of-receiving">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-ptr">
      <value value="0.12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrants-per-day">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-same">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation-rate">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-giving">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-different">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experiment 110" repetitions="10" runMetricsEveryStep="false">
    <setup>setup-empty</setup>
    <go>go</go>
    <timeLimit steps="2000"/>
    <metric>coopown-percent</metric>
    <metric>defother-percent</metric>
    <metric>consist-ethno-percent</metric>
    <metric>meetown-percent</metric>
    <metric>coop-percent</metric>
    <metric>last100coopown-percent</metric>
    <metric>last100defother-percent</metric>
    <metric>last100consist-ethno-percent</metric>
    <metric>last100meetown-percent</metric>
    <metric>last100coop-percent</metric>
    <metric>cc-percent</metric>
    <metric>cd-percent</metric>
    <metric>dc-percent</metric>
    <metric>dd-percent</metric>
    <enumeratedValueSet variable="gain-of-receiving">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-ptr">
      <value value="0.12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrants-per-day">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-same">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation-rate">
      <value value="0.0025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-giving">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-different">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experiment 111" repetitions="10" runMetricsEveryStep="false">
    <setup>setup-empty</setup>
    <go>go</go>
    <timeLimit steps="2000"/>
    <metric>coopown-percent</metric>
    <metric>defother-percent</metric>
    <metric>consist-ethno-percent</metric>
    <metric>meetown-percent</metric>
    <metric>coop-percent</metric>
    <metric>last100coopown-percent</metric>
    <metric>last100defother-percent</metric>
    <metric>last100consist-ethno-percent</metric>
    <metric>last100meetown-percent</metric>
    <metric>last100coop-percent</metric>
    <metric>cc-percent</metric>
    <metric>cd-percent</metric>
    <metric>dc-percent</metric>
    <metric>dd-percent</metric>
    <enumeratedValueSet variable="gain-of-receiving">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-ptr">
      <value value="0.12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrants-per-day">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-same">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation-rate">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-giving">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-different">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experiment 113" repetitions="10" runMetricsEveryStep="false">
    <setup>setup-empty</setup>
    <go>go</go>
    <timeLimit steps="2000"/>
    <metric>coopown-percent</metric>
    <metric>defother-percent</metric>
    <metric>consist-ethno-percent</metric>
    <metric>meetown-percent</metric>
    <metric>coop-percent</metric>
    <metric>last100coopown-percent</metric>
    <metric>last100defother-percent</metric>
    <metric>last100consist-ethno-percent</metric>
    <metric>last100meetown-percent</metric>
    <metric>last100coop-percent</metric>
    <metric>cc-percent</metric>
    <metric>cd-percent</metric>
    <metric>dc-percent</metric>
    <metric>dd-percent</metric>
    <enumeratedValueSet variable="gain-of-receiving">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-ptr">
      <value value="0.12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrants-per-day">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-same">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutation-rate">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-giving">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immigrant-chance-cooperate-with-different">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
