turtles-own [
  harvestPref
  harvest-amount
  punisher?
  aware-of-who
  energy
  harvest
  punished?
  ]

patches-own [ resource ]

globals [
  commons
  commonsResources
  harvestTraits

   ]

to setup
  clear-all
   ask n-of Number-Agents patches [
    sprout 1 [
    set shape "circle"
      set size 0.8
      set punished? false
      set aware-of-who []
    ifelse random-float 100 < Percent-Sustainables
     [set harvestPref "sustainable"]  ;; determine the harvest preference (greedy or sustainable)
     [set harvestPref "greedy"]
    ifelse random-float 100 < Percent-Punishers
     [set punisher? true]  ;; determine the harvest preference (greedy or sustainable)
     [set punisher? false]
    update-color  ;; change the color of the agent on the basis of the strategy
    set energy Living-costs + 1]
  ]

  ask patches [
    set resource Carrying-capacity
    set pcolor scale-color brown resource  0 (Carrying-capacity + 30) ]

  reset-ticks
end


;;;;;;; Main routine ;;;;;;
to go
  if count turtles = 0 [stop]

  ask turtles
   [ifelse harvestPref = "sustainable"
      [set harvest-amount Harvest-sustainable]
      [ set harvest-amount Harvest-greedy]

    set aware-of-who []
    harvesting
   ]

    sense-cheaters
    punish

   ask turtles
  [ set energy energy + harvest

    expend-energy
    reproduce

    death]

  ask patches [
    regrow
    recolor]
  tick
end

to harvesting
 ifelse Punishment = "suspend harvest once"
  [ifelse punished? = false
    [harvest-commons]
    [set harvest 0]
   ]
  [harvest-commons]
  set punished?  false
end

to harvest-commons  ;; from Waring et al., 2017

   set harvest 0

      ; define the patches withing the local Moore neighborhood on which the current agent may harvest.
      set Commons (patch-set neighbors patch-here) ;; set list of patches to harvest from to include all neighboring patches

      set commonsResources sum ([resource] of Commons)  ;; sums all of the resources in my commons
      let commonsList sort-on [resource] Commons  ;; sort the list by the amount of resource on the patch
      set commonsList reverse commonsList  ;; reverse the sort list so it is largest to smallest

      ifelse commonsResources < harvest-amount  ;; if the total commons are less than what the agent wants to harvest
      [ set harvest (commonsResources); - ( count myCommons * 0.1 ))
        ask Commons [ set resource 0 ]
        move-away
      ]

      [
        while [harvest < harvest-amount][  ;; while you are still in need
        ;; harvest some resource from the neighborhood
          foreach commonsList [ ?1 ->
            ifelse [resource] of ?1 <= (harvest-amount - harvest)
              [set harvest (harvest + [resource] of ?1 )
               ask ?1 [set resource 0]
              ]

              [ask ?1 [
                set resource (resource - ([harvest-amount] of myself - [harvest] of myself))
              ]
                set harvest harvest-amount
              ]
          ]  ;; end foreach
        ]  ;; end while
     ] ;; end second part of ifelse commonsResources
end

to move-away
  let next-patch max-one-of (neighbors with [not any? turtles-here]) [resource]
  if next-patch != nobody
    [move-to next-patch
     set energy energy - 1
     ]
end

to sense-cheaters
  ask turtles with [punisher? = true]
   [ set harvest harvest - Costs-perception
     let cheaters  (turtles-on neighbors) with [harvestPref = "greedy"]
     set aware-of-who n-of  ( Perception-accuracy  / 100 * count cheaters) cheaters
   ]
end

to punish
  ask turtles with [ harvestPref = "greedy" and punished? = false]
  [let punishers  (turtles-on neighbors) with [ member? myself [aware-of-who] of self]
    if count punishers >= minimum-punishers
    ;;if any? punishers
   [ set punished? true
      if Punishment = "kill"[die]
      if Punishment = "pay fine"
       [set harvest harvest  - Fine
        set punished? false
        ask turtles-on neighbors [set harvest harvest  + (Fine / (count turtles-on neighbors) )]
       ]
      ask punishers [
        set harvest harvest  - ( Costs-punishment / count punishers)

      ]
     ]
  ]
end

to expend-energy
  set energy energy - Living-costs
end

to reproduce
  let birthrate 0.001 * energy
  if random-float 1 < birthrate [
    let destination one-of neighbors with [not any? turtles-here]
    if destination != nobody [
        hatch 1 [
        move-to destination
        set punished? false
        set aware-of-who []
        mutate
        set energy ([energy] of myself / 2)]
       ]
    set energy (energy / 2)
          ]
end

;; modify the children of agents according to the mutation rate
to mutate  ;; turtle procedure
    if random-float 100 < Mutation-rate
    [
    ifelse harvestPref = "greedy"
    [set harvestPref "sustainable"]
    [set harvestPref "greedy"]
    ]
    if random-float 100 < Mutation-rate
    [ ifelse punisher? = true
    [set punisher?  false]
    [set punisher?  true ]
    ]
   update-color
end

to update-color
   ifelse harvestPref = "sustainable"
      [ ifelse punisher? = true
        [set color green ]
        [set color turquoise]
      ]
      [ ifelse punisher? = true
          [set color orange ]
          [set color red]
      ]
end

to death
    if energy <= 0 [ die ]
    if random-float 100 < Death-rate [ die ]
end

to regrow
  ifelse resource > 0
  [set resource ceiling (resource + ((Growth-rate * resource) * (1 - (resource / Carrying-capacity )))) ]
  [set resource 0.1 ]
end

to recolor
  set pcolor scale-color brown resource  0 (Carrying-capacity + 30)
end
@#$#@#$#@
GRAPHICS-WINDOW
356
11
764
420
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
39
0
39
1
1
1
ticks
30.0

BUTTON
198
11
284
44
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
784
215
1267
445
Trait frequencies (%)
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
"Sustainable, punisher" 1.0 0 -10899396 true "" "plotxy ticks (count turtles with [color = green] / count turtles) * 100"
"Sustainable, not punisher" 1.0 0 -14835848 true "" "plotxy ticks (count turtles with [color = turquoise] / count turtles) * 100"
"Greedy, punisher" 1.0 0 -955883 true "" "plotxy ticks ( count turtles with [color = orange] / count turtles) * 100"
"Greedy, not punisher " 1.0 0 -2674135 true "" "plotxy ticks ( count turtles with [color = red] / count turtles) * 100"

BUTTON
104
11
194
44
Once
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
7
87
230
120
Percent-Sustainables
Percent-Sustainables
0
100
20.0
1
1
%
HORIZONTAL

SLIDER
6
504
184
537
Mutation-rate
Mutation-rate
0
10
1.0
0.5
1
%
HORIZONTAL

SLIDER
7
50
231
83
Number-Agents
Number-Agents
0
count patches
200.0
1
1
NIL
HORIZONTAL

BUTTON
7
11
101
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

SLIDER
6
465
184
498
Living-costs
Living-costs
0
Harvest-sustainable - 1
4.0
0.5
1
NIL
HORIZONTAL

PLOT
782
447
1267
680
Average energy
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
"Sustainable, punisher" 1.0 0 -10899396 true "" "carefully [plot sum [energy] of turtles with [color = green ] / count turtles with [color = green ]][plot 0]"
"Sustainable, not punisher" 1.0 0 -14835848 true "" "carefully [plot sum [energy] of turtles with [color = turquoise ] / count turtles with [color = turquoise ]][plot 0]"
"Greedy, punisher" 1.0 0 -955883 true "" "carefully [plot sum [energy] of turtles with [color = orange ] / count turtles with [color = orange ]][plot 0]"
"Greedy, not punisher" 1.0 0 -2674135 true "" "carefully [plot sum [energy] of turtles with [color = red ] / count turtles with [color = red ]][plot 0]"

SLIDER
5
543
184
576
Death-rate
Death-rate
0
10
1.0
0.5
1
%
HORIZONTAL

PLOT
783
11
1267
211
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
"Resource" 1.0 0 -5207188 true "" "plot (sum [resource] of patches / (count patches * Carrying-capacity)) * 100"
"Agents" 1.0 0 -11053225 true "" "plot (count turtles / count patches) * 100"

TEXTBOX
164
252
308
272
Maximum Sustainable Yield
11
0.0
1

SLIDER
7
250
157
283
Carrying-capacity
Carrying-capacity
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
7
288
157
321
Growth-rate
Growth-rate
0
1
0.3
0.1
1
NIL
HORIZONTAL

MONITOR
164
275
221
320
MSY
Carrying-capacity * Growth-rate / 4
2
1
11

PLOT
345
449
778
681
Average harvest per iteration
NIL
NIL
0.0
10.0
0.0
5.0
true
false
"" ""
PENS
"Sustainble, punisher" 1.0 0 -10899396 true "" "carefully [plot sum [harvest] of turtles with [color = green] / count turtles with [color = green]][plot 0]"
"Sustainble, not punisher" 1.0 0 -14835848 true "" "carefully [plot sum [harvest] of turtles with [color = turquoise] / count turtles with [color = turquoise]][plot 0]"
"Greedy, punisher" 1.0 0 -955883 true "" "carefully [plot sum [harvest] of turtles with [color = orange] / count turtles with [color = orange]][plot 0]"
"Greedy, not punisher" 1.0 0 -2674135 true "" "carefully [plot sum [harvest] of turtles with [color = red] / count turtles with [color = red]][plot 0]"

SLIDER
8
163
197
196
Harvest-sustainable
Harvest-sustainable
0
100
7.0
0.5
1
NIL
HORIZONTAL

SLIDER
8
199
197
232
Harvest-greedy
Harvest-greedy
0
100
10.0
0.5
1
NIL
HORIZONTAL

SLIDER
7
333
186
366
Perception-accuracy
Perception-accuracy
0
100
100.0
1
1
%
HORIZONTAL

SLIDER
7
124
231
157
Percent-Punishers
Percent-Punishers
0
100
20.0
1
1
%
HORIZONTAL

SLIDER
188
373
342
406
Costs-punishment
Costs-punishment
0
3
0.8
0.1
1
NIL
HORIZONTAL

CHOOSER
6
372
183
417
Punishment
Punishment
"kill" "suspend harvest once" "pay fine"
1

SLIDER
6
422
185
455
Fine
Fine
1
20
1.0
1
1
NIL
HORIZONTAL

SLIDER
188
333
342
366
Costs-perception
Costs-perception
0
3
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
190
422
340
455
Minimum-punishers
Minimum-punishers
1
9
1.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
# Model purpose
What is the purpose of the model?

This model simulates the evolution of a population of agents competing for the same resource. Agents have two types of traits - harvesting preference (sustainable or greedy harvesting), and ability to perceive and punish other agents. Punishing agents have the ability to perceive other agents in their environment to some degree and to react to their behavior. They can kill agents with greedy harvesting behavior, stop them from harvesting in the next iteration, or have them pay a penalty fee to their neighbors. Agents have a cost (energy) to pay for both detection and punishment, so this behavior is altruistic. Punishing agents have the ability to coordinate punishment with a minimum number of punishers to share punishment costs. Due to this social perception and social behavior in the population, greedy harvesting behavior can become less advantageous or even disadvantageous, and sustainable harvesting behavior can spread in the population. Concepts like kin selection, frequency-dependent selection , multi-level selection play a role in the outcomes that are observed.


# Entities and variables
What kinds of entities are in the model? By what state variables, or attributes, are these entities characterized? What are the temporal and spatial resolutions and extents of the model?

## General environment

### Changeable variables

* _Living-costs_: the costs that each agent has to deduct from his energy per iteration for basic survival
* _Mutation-rate_: The probability with which offspring agents have other traits than their parents
* _Death-rate_: The probability with which agents die independent of their energy level
(these variables could be considered both a factor of the environment and a variable of the agents, but we list them here since they do not vary among agents and are rather “imposed” from the environment)


## Patches

There are 40*40 patches in the world. 

### Constant patch variables
(these variables and behaviors are always the same for all of the patches and in each iteration)

* The resources on a patch regrow by a logistic growth function up to the carrying capacity: 
new resource level = current resource level + (Growth-Rate * current resource level) * (1 - (current resource level / carrying capacity)


### Changeable patch variables 
(variables that are changeable by the user on the interface)

* _carrying-capacity_: the maximum amount of resource units on a patch from 1-100
* _growth rate_: the rate at which resources on patches regrow 
The maximum sustainable yield is calculated based on carrying capacity and growth rate.


### Changing variables during a simulation
(variables that change as a result of the simulation)

  * actual resource level of a patch in units

## Agents
Agents are represented as circles. There can be a maximum of 1600 agents in the world (1 per patch).


### Constant agent variables and behaviors
(these variables and behaviors are always the same for all of the agents of this type and in each iteration)

* In each iteration, each agent attempts to harvest resources from the patches it is on as well as the eight neighboring patches. If the amount of resources available is lower than the amount that the agent attempts to harvest, it moves to a neighboring unoccupied patch with the most resources.


### Changeable agent variables
(variables that are changeable by the user on the interface): 

* _Harvest-sustainables_: the amount of resource units harvested by sustainable agents
* _Harvest-greedy_: the amount of resource units harvested by sustainable agents
* _Perception-accuracy_: the probability with which punishing agents notice greedy agents
* _Costs-perception_: the costs in units of energy that punishing agents have to pay in each iteration for perceiving other agents
* _Costs-punishment_: the costs in units of energy that punishing agents have to pay in each iteration for punishing other agents. Costs of punishment are shared between all punishing agents of an agent.
* _Punishment_: the kind of punishing behavior that punishing agents perform
* _Minimum-punishers_: the minimum number of other punishing agents that need to be in the neighborhood of a greedy agent so that punishers will indeed punish.
* _Fine_: if the punishment  is “pay fine”, the fine in energy units that punished agents have to pay (shared between all their neighbors)
* _Reproduction_: ability of agents to produce offspring


### Changing variables during a simulation
(variables that change as a result of the simulation)

* _harvest preference_: the harvest level preference of the agent (sustainable or greedy) as a trait.
* _punisher?_: Whether or not the agent has the ability to perceive and punish other agents
* _harvest-amount_: the actual amount of resource units that is harvested by an agent in the current iteration
* _aware-of-who_: the greedy agents in the neighborhood that the agent is perceiving
* _punished?_: Whether or not the agent is being punished
* _Energy_: the energy level (in resource units) of an agent 
* Offspring have a different harvest amount trait from their parents with a probability of _Mutation-rate_.


# Model Setup
What is the initial state of the model world when one clicks on Setup? Is initialization always the same, or does it vary among simulations?

* A world with 1600 patches is created.
* The initial amount of resource units on a patch is set to Carrying-capacity.
* A number of agents, set by the parameter Number-agents, are randomly distributed on patches (maximum of one agent per patch).
* A fraction of agents, set by the parameter Percent-sustainables, gets the variable harvest preference set to “sustainable”
* A fraction of agents, set by the parameter Percent-punishers, gets the variable punisher? set to true.
* The agents are assigned colors based on their combination of traits:
    * red: greedy, non-punishing
    * orange: greedy, punishing
    * blue: sustainable, non-punishing
    * green: sustainable, punishing
* The initial level of energy of agents is set at living costs + 1.


# Model Processes
What happens in each iteration? Which entities do what, and in what order? When are state variables updated?

![Model processes image](https://openevo.eva.mpg.de/wp-content/uploads/NetLogo-model-Evolution-resources-monitoring-punishment-procedures-overview.png)

# Outputs
What kinds of model outcomes can be observed on the interface? How do they emerge from model parameters, agent behaviors, and interactions?


## In the world
Resource levels on patches change as they are being harvested and as they regrow. Agents reproduce and die. Since agents place offspring on neighboring patches and do not move unless there are no more resources, clusters of “related” agents tend to form.
 

## Output diagrams and monitors

### Populations (% of carrying capacity)
The state of the resource and of the agent population in the world as percentage of total carrying capacity; resulting from resource harvesting behavior and resource regrowth, agent reproduction and death

### Trait frequencies
The relative frequencies of sustainable and greedy agents in the population, resulting from mutations, different reproduction rates, and death

### Average harvest per iteration 
Average harvested amounts of agents per iteration by trait, resulting from harvested resource units, minus costs for monitoring and punishing (for punishing agents), minus fines (for punished agents in case of punishment “Pay fine”)

### Average energy of agents
Average energy levels of agents by trait, resulting from resource harvest, minus living costs and reproduction, minus energy expenditure for moving.


# Concepts and Principles
Which important concepts or principles are represented in the model?

The resource is characterized by two ecologically significant parameters:

* the **carrying capacity**: this is the largest possible amount of resources that can be present on a patch / in a certain area. In ecology, carrying capacity is often represented by the letter k. In this model, it is represented by the maximum growth height of the trees. In the real world, carrying capacity is influenced by biotic and abiotic factors like temperature and humidity or availability of other resources.
* the **resource growth rate**: this is the rate at which a resource grows back from one time step to the next. It is often represented in ecology by the letter r. 

The resource grows along a **logistic (S-shaped, sigmoid) population growth function** according to the following formula: 
Resource state at the next point in time = current resource state +  ( r * current resource state) * (1 - current resource state / k ) 

**Trait variation**
Two types of traits vary in the population: harvesting behavior (sustainable or greedy), and ability to notice and punish other agents (present or not present). New trait variants can be introduced randomly in the population through the parameter mutation rate.

**Reproductive fitness**
Agents that have higher energy levels produce more offspring. They have higher fitness relative to agents with lower energy levels.

**Inheritance**
Agents create offspring and inherit their trait variants to their offspring (with some variability based on mutation rate)

**Natural selection**
The frequency of harvesting traits in the agent population changes as a result of trait variation, differential reproduction (fitness), and inheritance of traits. 

**Kin selection, multi-level selection, frequency-dependent selection, altruism**
The behavior of sustainable resource harvesting as well as of punishment is altruistic because these agents harvest lower amounts of resources such that the resource can be sustained, and they pay costs for noticing and punishing greedy harvesting behavior. In order for this trait to spread in the population through natural selection, altruists need to interact (directly and indirectly, see Interactions below) with other altruists. This is made possible in the model by the fact that agents do not move much and place their own offspring on neighboring patches. This way clusters of (related) altruists benefit from the sustaining of the resource, and they do not have to pay high costs for punishment because there are less greedy agents around.  Punishment reduces the fitness benefits of high harvesting levels, promoting the selection of altruistic traits over time.

**Sensing and Information Processing** 
Agents sense their environment in a radius of 1 patch: if a patch is occupied, the resource levels on each patch; as well as whether neighboring agents are greedy (with an accuracy of Perception-accuracy).
Punishing agents store the number of greedy agents they have noticed (aware-of-who) within one iteration (they “forget” between iterations).
Punished agents store whether they are being punished from one iteration to the next (so they will be suspended from harvesting in the following iteration)

**Objectives and goal-directed behavior**
Agents attempt to harvest their predetermined harvest amount (or until there are no more resources) from the patch they are on as well as the 8 neighboring patches.
If there aren’t enough resources around, agents move to a neighboring unoccupied patch with the most resources.
Punishing agents punish greedy agents through the parameters set by the kind of punishment

**Learning and Adaptation**
Agents do not learn and do not adapt their behavior over their lifetimes.

**Interactions**
Agents interact directly through noticing each other and punishing each other.
Agents interact indirectly through competition for limited resources and space, and through their changing of environmental conditions through resource extraction and placing of offspring

**Role of randomness**

* Agents are being distributed randomly in the world at the beginning of a simulation.
* Agents take on their traits (harvest preference and ability to notice and punish) randomly based on the probability _Percent-sustainables_ and _Percent-punishers_.
* The order in which agents harvest within one iteration is random.
* Agents move to a randomly selected patch if several patches fulfill the objectives.
* The order in which punishing agents notice greedy agents within one iteration is random.
* Greedy agents get noticed by punishing agents with a probability of _Perception-accuracy_.
* The order at which greedy agents that have been noticed get punished within one iteration is random.
* The order in which agents produce offspring within one iteration is random.
* Agents produce offspring with a probability of  (0.001 * Energy).
* Agents place offspring on a randomly selected unoccupied neighboring patch.
* Offspring mutate with a probability of _Mutation-rate_.
* Agents die with a probability of _Death-rate_.


# Model Teaching Materials


Teaching materials for this model:
https://openevo.eva.mpg.de/teachingbase/netlogo-evolution-of-resource-use-and-social-behavior-monitoring-and-punishment/

# References and Citation

For this model:

* Hanisch, S. (2022). Evolution, resources, monitoring and punishment. OpenEvo NetLogo Models. https://openevo.eva.mpg.de/teachingbase/netlogo/

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
  <experiment name="Exp bio evo behavior change" repetitions="3" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>count turtles with [ harvestPref = "low"]</metric>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="Mutation-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial-number-people">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fine">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitoring-efficiency">
      <value value="50"/>
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="defense-cost">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="norm-psyche">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="punishment-quorum">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="enforcement-cost">
      <value value="0"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="degree-fear">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="greedy-amount">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="degree-envy">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-percent-punishers">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="compassion">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-percent-sustainables">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regrowth-rate">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="punishment">
      <value value=""suspend harvest once""/>
      <value value=""kill""/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="living-costs">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sustainable-amount">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Mortality-rate">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="degree-guilt">
      <value value="0"/>
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
