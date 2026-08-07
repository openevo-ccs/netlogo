# LPM Strand: Bug Evolution

> **Superseded (2026-08-07)**: this file was never linked from `models/bug-evolution/metadata.json`'s
> `lpmStrand` pointer (which points at `bug-evolution.md`) and was not, in fact, the ecosystem's real
> strand for this model — the git-health/status tooling correctly reported "not started" throughout.
> Its well-developed grade-band/content-anchor/competency content (independently verified accurate
> against the real ConceptBase registry) has been incorporated into the real, linked strand at
> [bug-evolution.md](bug-evolution.md), which adds the restructuration-theory rationale this draft
> predates. Left in place rather than deleted, per this ecosystem's general never-delete discipline.

> Status: **Complete** - This strand is fully developed with grade-band progression, content anchor alignment, competency mapping, and assessment.

## Model
- [Run the model](../models/bug-evolution/)
- [Model metadata](../models/bug-evolution/metadata.json)
- [Download .nlogo](../models/bug-evolution/model.nlogo)

## Overview

This strand explores natural selection through a simple, intuitive model: beetles evolving running speed to escape from bird predators. Students investigate how variation, differential survival, and inheritance lead to evolutionary change, understanding the core mechanisms of natural selection while avoiding common misconceptions. The strand connects to real-world examples of evolution in nature and human contexts.

## Grade-Band Progression

### Grades 6-8: Introduction to Natural Selection

**Learning Objectives:**
- Understand that traits vary in a population
- Observe how some traits lead to higher survival
- Recognize that traits can change over generations
- Avoid teleological thinking ("evolved to")

**Key Concepts:**
- Trait variation
- Differential survival
- Inheritance
- Natural selection
- Adaptation

**Activities:**
1. Run the model with different predation pressures
2. Observe how speed changes over generations
3. Record observations about which beetles survive
4. Discuss: Why do faster beetles become more common?

**Assessment Indicators:**
- Can describe how natural selection works
- Recognizes that traits vary and change over time
- Avoids "evolved to" language
- Understands that not all beetles survive

### Grades 9-12: Mechanisms of Natural Selection

**Learning Objectives:**
- Explain the four components of natural selection (variation, differential survival, inheritance, time)
- Analyze how trade-offs affect evolution
- Understand context-dependence of adaptation
- Avoid genetic determinism and teleological thinking

**Key Concepts:**
- Variation, differential survival, inheritance, time
- Trade-offs (speed vs. energy cost)
- Context-dependence (what's adaptive depends on environment)
- Fitness and reproductive success
- Population-level vs. individual-level change

**Activities:**
1. Systematically explore predation pressure and energy cost
2. Compare outcomes with different food availability
3. Use Tinbergen's questions to analyze beetle speed
4. Discuss real-world examples of natural selection

**Assessment Indicators:**
- Explains natural selection using proper terminology
- Recognizes trade-offs and context-dependence
- Avoids teleological and genetic determinist thinking
- Distinguishes individual vs. population-level change

### Undergraduate: Advanced Analysis

**Learning Objectives:**
- Design and test hypotheses about natural selection
- Analyze model behavior using quantitative methods
- Connect model findings to empirical research
- Evaluate model assumptions and limitations

**Key Concepts:**
- Evolutionary game theory
- Quantitative analysis of selection
- Model validation and limitations
- Applications to medicine, agriculture, conservation

**Activities:**
1. Design original BehaviorSpace experiments
2. Analyze model data statistically
3. Compare model predictions with empirical studies (antibiotic resistance, pesticide resistance)
4. Write research reports connecting model to literature

**Assessment Indicators:**
- Designs rigorous computational experiments
- Interprets results in light of evolutionary theory
- Connects to real-world phenomena
- Critically evaluates model assumptions

## Content Anchor Alignment

### Primary Content Anchors

**1. Cross-Species Comparisons**
- Natural selection across different species
- Similarities and differences in evolutionary mechanisms
- Comparative examples (beetles, bacteria, humans)

**2. Ancient Ancestors**
- Evolution as a historical process
- How traits change over long time scales
- Ancestral relationships and common descent

### Secondary Content Anchors

**3. Our Mind**
- Human tendencies toward teleological thinking
- Cognitive biases in understanding evolution
- How to overcome misconceptions

**4. Global Sustainability Goals**
- Evolution in response to human impacts
- Antibiotic resistance as an evolutionary problem
- Conservation and evolutionary processes

## Thinking Tool Integration

### 1. Tinbergen's Questions
- **Function:** How does fast running help beetles survive?
- **Mechanism:** How does speed affect escape from predators?
- **Development:** How do beetles develop running ability?
- **Evolution:** How did running speed evolve?

### 2. Causal Mapping
- **Application:** Map causes of speed increase/decrease
- **Purpose:** Visualize multiple interacting factors
- **Activity:** Diagram: predation pressure → survival → reproduction → speed frequency

### 3. The Noticing Tool
- **What patterns do you notice in speed changes?**
- **What surprises you about the results?**
- **What questions does this raise about evolution?**

### 4. Analogies
- Compare to:
  - Antibiotic resistance in bacteria
  - Pesticide resistance in insects
  - Human adaptations to high altitude

### 5. Payoff Matrices
- **Application:** Analyze trade-offs between speed and energy cost
- **Purpose:** Understand costs and benefits of traits

### 6. Structure of Knowledge
- Connect to: Variation → Selection → Adaptation → Evolution

## Competency Alignment

### OE-CONCEPT-000102: Natural Selection
- **Definition:** Differential reproductive success among heritable variants within a population, resulting from their interaction with the environment.
- **Connection:** Model shows all four components of natural selection
- **Performance Indicators:**
  - Explain natural selection using proper terminology
  - Identify variation, differential survival, inheritance, and time
  - Predict how selection pressures affect trait frequencies

### OE-CONCEPT-000104: Adaptation
- **Definition:** A heritable trait that increases an organism's fitness within a given environment, shaped by natural selection over generations.
- **Connection:** Speed can be adaptive in high-predation environments
- **Performance Indicators:**
  - Explain why speed might be adaptive
  - Recognize context-dependence of adaptation
  - Avoid assuming adaptations are "good" or "progressive"

### OE-CONCEPT-000211: Agency
- **Definition:** The capacity of an individual or system to act intentionally and make choices that influence outcomes.
- **Connection:** Beetles don't "choose" to evolve - evolution is a population-level process
- **Performance Indicators:**
  - Distinguish individual agency from population-level evolution
  - Avoid anthropomorphizing beetles
  - Understand that evolution doesn't have goals

## Assessment

### Integrated Causal Reasoning Assessment

**Assessment File:** [assessments/bug-evolution.json](../assessments/bug-evolution.json)

**Purpose:** Diagnose integrated vs. dichotomized reasoning about natural selection

**Format:** 5-item multiple-choice assessment with vignette

**Key Misconceptions Assessed:**
1. Teleological thinking ("evolved to")
2. Lamarckian thinking (acquired traits inherited)
3. Progressionism (evolution has direction)
4. Individual-level thinking (confusing individual change with evolution)
5. Genetic determinism (traits are fixed)

### Additional Assessment Methods

**1. Prediction Tasks**
- Students predict outcomes under different conditions
- Assess understanding of selection mechanisms

**2. Causal Mapping**
- Students diagram natural selection processes
- Assess understanding of causal relationships

**3. Misconception Identification**
- Students identify and correct misconceptions
- Assess metacognitive awareness

## Teaching Materials

### Lesson Plans

**Lesson 1: Introduction to Natural Selection (Grades 6-8)**
- Duration: 45 minutes
- Objectives: Understand basic natural selection, avoid teleology
- Activities: Model exploration, observation recording

**Lesson 2: Mechanisms of Natural Selection (Grades 9-12)**
- Duration: 60 minutes
- Objectives: Analyze trade-offs, context-dependence
- Activities: Parameter exploration, Tinbergen's questions

**Lesson 3: Advanced Analysis (Undergraduate)**
- Duration: 90 minutes
- Objectives: Design experiments, connect to research
- Activities: Experiment design, literature connection

## Common Misconceptions

1. **"Beetles evolved to be fast"** - Use proper evolutionary language
2. **"Beetles choose to be fast"** - Evolution is population-level, not individual choice
3. **"Faster is always better"** - Trade-offs and context-dependence
4. **"Evolution has a goal"** - Evolution has no direction or purpose
5. **"Individual beetles evolve"** - Evolution happens to populations, not individuals

## Connections to Other Models

### Direct Connections
- **island-world**: Compare selection in different environments
- **evolution-competition-forest-resources**: Add resource competition
- **wolves-sheep-grass**: Compare predator-prey dynamics

### Thematic Connections
- **evolution-ethnocentrism**: Compare selection of cooperation strategies
- **virus-epidemic**: Compare evolution in different systems

## Extensions and Variations

### Model Extensions
1. Add multiple traits (size, color, behavior)
2. Add environmental variation
3. Add sexual selection
4. Add coevolution with predators

### Cross-Model Comparisons
1. Compare with Island World (different environments)
2. Compare with Evolution of Ethnocentrism (strategy selection)
3. Compare with Virus Epidemic (different evolutionary system)

### Real-World Applications
1. Antibiotic resistance
2. Pesticide resistance
3. Climate change adaptation
4. Conservation and evolution

## Schema-Ready Contribution

This strand is ready to be authored as a formal OECB contribution.

## References

- Darwin, C. (1859). *On the Origin of Species*.
- Mayr, E. (1982). *The Growth of Biological Thought*. Harvard University Press.
- Futuyma, D. J. (2013). *Evolution*. Sinauer Associates.

---

**Last Updated:** 2025-01-09  
**Status:** Complete and ready for use  
**Contributors:** OpenEvo CCS Lab