# LPM Strand: Evolution of Ethnocentrism

> Status: **Complete** - This strand is fully developed with grade-band progression, content anchor alignment, competency mapping, and assessment.

## Model
- [Run the model](../models/evolution-ethnocentrism/app.html)
- [Model metadata](../models/evolution-ethnocentrism/metadata.json)
- [Download .nlogo](../models/evolution-ethnocentrism/model.nlogo)

## Overview

This strand explores the biological evolution of ethnocentric behavior through agent-based modeling. Students investigate how cooperation strategies evolve in populations with ethnic markers, examining the roles of kin selection, multilevel selection, and frequency-dependent selection. The strand connects evolutionary theory to real-world phenomena of intergroup cooperation, discrimination, and social identity.

## Grade-Band Progression

### Grades 6-8: Introduction to Cooperation Strategies

**Learning Objectives:**
- Understand basic cooperation and defection strategies
- Observe how different strategies spread in a population
- Recognize that outcomes depend on interaction patterns

**Key Concepts:**
- Cooperation vs. defection
- Strategy frequency in populations
- Local vs. global interaction

**Activities:**
1. Run the model with default settings and observe strategy spread
2. Compare local vs. global interaction modes
3. Record observations about which strategies become common

**Assessment Indicators:**
- Can describe what happens to different strategies over time
- Recognizes that interaction patterns affect outcomes
- Can predict which strategies might succeed in different conditions

### Grades 9-12: Mechanisms of Ethnocentric Evolution

**Learning Objectives:**
- Explain how ethnocentrism can evolve through natural selection
- Analyze the roles of kin selection and multilevel selection
- Understand frequency-dependent selection and payoff structures
- Evaluate the conditions that favor different cooperation strategies

**Key Concepts:**
- Natural selection and differential reproduction
- Kin selection and positive assortment
- Multilevel selection (within-group vs. between-group)
- Frequency-dependent selection
- Payoff matrices and game theory
- Population structure and spatial organization

**Activities:**
1. Systematically explore payoff matrix parameters
2. Compare outcomes with different numbers of ethnicities
3. Analyze how local interaction and offspring placement affect strategy success
4. Use BehaviorSpace experiments to test hypotheses
5. Apply Tinbergen's questions to ethnocentric behavior

**Assessment Indicators:**
- Explains ethnocentrism as an evolved strategy, not a moral choice
- Recognizes multiple interacting mechanisms (kin selection, multilevel selection)
- Understands context-dependence of strategy success
- Avoids teleological and genetic determinist thinking
- Can analyze payoff structures and predict outcomes

### Undergraduate: Advanced Analysis and Applications

**Learning Objectives:**
- Design and test hypotheses about ethnocentric evolution
- Analyze model behavior using mathematical and computational methods
- Connect model findings to empirical research on human cooperation
- Evaluate implications for understanding real-world intergroup dynamics

**Key Concepts:**
- Evolutionary game theory
- Agent-based modeling methodology
- Cultural evolution and gene-culture coevolution
- Experimental design in computational models
- Applications to human social psychology and political science

**Activities:**
1. Design original BehaviorSpace experiments
2. Analyze model data using statistical methods
3. Compare model predictions with empirical studies
4. Explore extensions (e.g., adding learning, reputation systems)
5. Write research reports connecting model to literature

**Assessment Indicators:**
- Designs rigorous computational experiments
- Interprets model results in light of evolutionary theory
- Connects model findings to real-world phenomena
- Critically evaluates model assumptions and limitations

## Content Anchor Alignment

### Primary Content Anchors

**1. Cooperation Games**
- Payoff matrices as representations of strategic interactions
- Prisoner's Dilemma structure in ethnocentrism
- Evolution of cooperation in repeated interactions

**2. Cross-Species Comparisons**
- Ethnocentrism in humans vs. other species
- In-group favoritism across taxa
- Evolutionary origins of social identity

**3. Cultural Diversity**
- Ethnic markers as social categories
- Cultural transmission of cooperation norms
- Variation in ethnocentric tendencies across cultures

### Secondary Content Anchors

**4. Our Mind**
- Cognitive biases in social perception
- Automatic categorization of in-group vs. out-group
- Evolutionary psychology of social cognition

**5. Governing the Commons**
- Group-level cooperation and resource management
- Institutions for reducing intergroup conflict
- Evolution of governance systems

## Thinking Tool Integration

### 1. Payoff Matrices
- **Application:** Students manipulate the A, B, C, D payoff parameters
- **Purpose:** Understand how costs and benefits shape strategy evolution
- **Activity:** Create payoff matrices representing different real-world scenarios

### 2. Causal Mapping
- **Application:** Map causes of ethnocentrism increase/decrease
- **Purpose:** Visualize multiple interacting factors
- **Activity:** Create causal diagrams showing: population structure → interaction patterns → strategy success

### 3. Tinbergen's Questions
- **Function:** How does ethnocentrism help groups compete?
- **Mechanism:** How do ethnic markers and conditional cooperation work?
- **Development:** How do children learn ethnocentric tendencies?
- **Evolution:** How did ethnocentrism evolve through natural selection?

### 4. The Noticing Tool
- **What patterns do you notice in strategy spread?**
- **What surprises you about the results?**
- **What questions does this raise?**

### 5. Analogies
- Compare ethnocentrism to: 
  - Bacterial quorum sensing
  - Ant colony recognition systems
  - Human sports team loyalty

### 6. Structure of Knowledge
- Connect to: Natural selection → Cooperation → Multilevel selection → Human social behavior

## Competency Alignment

### OE-CONCEPT-000207: Cooperation
- **Definition:** Coordinated behavior among individuals or groups that produces a mutual benefit not achievable, or less efficiently achieved, alone.
- **Connection:** Model shows how cooperation can evolve despite temptation to defect
- **Performance Indicators:**
  - Explain conditions that favor cooperation
  - Analyze how cooperation strategies spread
  - Evaluate trade-offs between individual and group benefits

### OE-CONCEPT-000211: Agency
- **Definition:** The capacity of an individual or system to act intentionally and make choices that influence outcomes, rather than responding passively to external forces.
- **Connection:** Agents make strategic choices (cooperate/defect) that affect outcomes
- **Performance Indicators:**
  - Recognize agent decision-making in the model
  - Distinguish agent-level behavior from population-level outcomes
  - Understand how simple rules produce complex patterns

### OE-CONCEPT-000102: Natural Selection
- **Definition:** Differential reproductive success among heritable variants within a population, resulting from their interaction with the environment.
- **Connection:** Strategies with higher fitness (energy) reproduce more
- **Performance Indicators:**
  - Explain natural selection in the context of cooperation strategies
  - Identify heritable variation, differential fitness, and inheritance
  - Predict how selection pressures affect strategy frequencies

### OE-CONCEPT-000104: Adaptation
- **Definition:** A heritable trait that increases an organism's fitness within a given environment, shaped by natural selection over generations.
- **Connection:** Ethnocentrism can be adaptive in certain environments
- **Performance Indicators:**
  - Explain why ethnocentrism might be adaptive
  - Recognize context-dependence of adaptation
  - Avoid assuming adaptations are "good" or "progressive"

## Assessment

### Integrated Causal Reasoning Assessment

**Assessment File:** [assessments/evolution-ethnocentrism.json](../assessments/evolution-ethnocentrism.json)

**Purpose:** Diagnose integrated vs. dichotomized reasoning about ethnocentrism evolution

**Format:** 5-item multiple-choice assessment with vignette

**Scoring:**
- Integrated reasoning: Recognizes multiple mechanisms, context-dependence, agency
- Dichotomized reasoning: Single-cause explanations, genetic determinism, teleology

**Key Misconceptions Assessed:**
1. Genetic determinism (strategies are fixed)
2. Teleological thinking ("evolved to")
3. Single-cause explanations
4. Naturalistic fallacy (evolved = good)
5. Ignoring agency and cultural evolution

**Usage:**
- Pre-assessment before model exploration
- Post-assessment after activities
- Formative assessment during learning progression

### Additional Assessment Methods

**1. Observation Journals**
- Students record predictions, observations, and reflections
- Use digital lab notebook feature
- Assess ability to notice patterns and generate questions

**2. Causal Mapping Tasks**
- Students create causal diagrams of ethnocentrism evolution
- Assess understanding of multiple interacting factors

**3. Experimental Design**
- Students design BehaviorSpace experiments
- Assess hypothesis generation and experimental reasoning

**4. Argumentation Tasks**
- Students argue for/against claims about ethnocentrism
- Assess use of evidence and evolutionary reasoning

## Teaching Materials

### Lesson Plans

**Lesson 1: Introduction to Cooperation Strategies (Grades 6-8)**
- Duration: 45 minutes
- Objectives: Understand basic cooperation/defection, observe strategy spread
- Activities: Model exploration, observation recording, group discussion

**Lesson 2: Mechanisms of Ethnocentric Evolution (Grades 9-12)**
- Duration: 90 minutes
- Objectives: Explain kin selection, multilevel selection, payoff structures
- Activities: Parameter exploration, BehaviorSpace experiments, Tinbergen's questions

**Lesson 3: Advanced Analysis (Undergraduate)**
- Duration: 2 hours
- Objectives: Design experiments, analyze data, connect to research
- Activities: Original experiment design, data analysis, literature connection

### UI Overview
- [Slide deck](https://docs.google.com/presentation/d/e/2PACX-1vR_0rLeotSL0i__gffPv1DBS7SENeRtedsqNIjKmQilVKB1URJFt6fY3bdv2kaxKCSQIeXQY7TBeEve/pub)

### Related Resources
- Axelrod & Hammond (2003, 2006): Original ethnocentrism model
- Hamilton's rule and kin selection theory
- Multilevel selection theory (Wilson & Wilson)
- Human ethnocentrism research ( Brewer, 1999; Tajfel & Turner)

## Common Misconceptions

1. **Genetic Determinism**: "Ethnocentrism is genetic and can't be changed"
   - Correction: Strategies can be culturally transmitted and modified

2. **Teleological Thinking**: "Ethnocentrism evolved to help groups survive"
   - Correction: Use proper evolutionary language ("was favored by selection")

3. **Naturalistic Fallacy**: "Ethnocentrism is natural, therefore it's good"
   - Correction: Distinguish descriptive (what is) from normative (what ought to be)

4. **Single-Cause Explanations**: "Ethnocentrism is caused by X"
   - Correction: Multiple interacting mechanisms (kin selection, multilevel selection, cultural evolution)

5. **Ignoring Agency**: "People can't help being ethnocentric"
   - Correction: Humans have agency and can consciously shape cultural evolution

## Connections to Other Models

### Direct Connections
- **two-communities**: Compare group-level cooperation mechanisms
- **evolution-resource-use-social-behavior**: Explore punishment and monitoring
- **evolution-resource-use-behavior-imitation**: Study cultural transmission

### Thematic Connections
- **bug-evolution**: Compare natural selection mechanisms
- **island-world**: Explore population structure effects
- **wolves-sheep-grass**: Compare predator-prey vs. cooperation dynamics

## Extensions and Variations

### Model Extensions
1. Add learning: Agents adapt strategies based on experience
2. Add reputation: Agents remember past interactions
3. Add migration: Agents move between groups
4. Add punishment: Agents can punish defectors

### Cross-Model Comparisons
1. Compare ethnocentrism with two-communities (private vs. commons)
2. Compare with evolution-resource-use-behavior-imitation (cultural evolution)
3. Compare with island-world (population structure)

### Real-World Applications
1. Interethnic conflict and peacebuilding
2. Discrimination and prejudice reduction
3. International relations and diplomacy
4. Sports team rivalries and fan behavior

## Schema-Ready Contribution

This strand is ready to be authored as a formal OECB contribution following the strand/substrand schema. Key elements:

- Strand ID: OE-STRAND-XXX (to be assigned)
- Substrands for each grade band (6-8, 9-12, UG)
- Performance indicators aligned to competencies
- Assessment items mapped to reasoning patterns
- Content anchor and thinking tool alignments documented

## References

- Axelrod, R., & Hammond, R. A. (2003). The evolution of ethnocentric behavior. *Midwest Political Science Convention*.
- Axelrod, R., & Hammond, R. A. (2006). The evolution of ethnocentrism. *Journal of Conflict Resolution*, 50(6), 926-936.
- Hamilton, W. D. (1964). The genetical evolution of social behaviour. *Journal of Theoretical Biology*, 7(1), 1-16.
- Wilson, D. S., & Wilson, E. O. (2007). Rethinking the theoretical foundation of sociobiology. *The Quarterly Review of Biology*, 82(4), 327-348.
- Brewer, M. B. (1999). The psychology of prejudice: Ingroup love and outgroup hate? *Journal of Social Issues*, 55(3), 429-444.

## License

CC BY-SA 4.0 - See [LICENSE](../LICENSE)

---

**Last Updated:** 2025-01-09  
**Status:** Complete and ready for use  
**Contributors:** OpenEvo CCS Lab