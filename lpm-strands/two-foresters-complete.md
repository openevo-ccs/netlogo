# LPM Strand: Two Foresters

> **⚠️ DRAFT CONCEPT** — synthesized by an LLM across the NetLogo and OpenEvo CCS ecosystem's
> existing materials, not validated by expert review or empirical classroom testing. Use as a
> starting point for research and policy-development discussion, not as vetted curriculum. See
> [lpm-strands/README.md](README.md).

> **Superseded (2026-08-26)**: this file's well-developed grade-band/content-anchor/competency
> content (independently verified accurate against the real ConceptBase registry) has been
> incorporated into the real, linked strand at [two-foresters.md](two-foresters.md) (already
> `metadata.json`'s `lpmStrand` pointer target — unlike `bug-evolution-complete.md`, this file was
> never itself the linked strand), which adds the restructuration-theory rationale and the parallel
> `oe:LearningDependency` claim this draft predates. Left in place rather than deleted, per this
> ecosystem's general never-delete discipline.

> Status: **Complete** - This strand is fully developed with grade-band progression, content anchor alignment, competency mapping, and assessment.

## Model
- [Run the model](../models/two-foresters/)
- [Model metadata](../models/two-foresters/metadata.json)
- [Download .nlogo](../models/two-foresters/model.nlogo)

## Overview

This strand explores the fundamental social dilemma of cooperation through the simplest possible setting: two individuals sharing a renewable resource. Students investigate how individual decisions about harvesting affect collective outcomes, understanding the tension between short-term individual benefits and long-term collective welfare. The strand connects to real-world dilemmas in resource management, environmental sustainability, and social cooperation.

## Grade-Band Progression

### Grades 3-5: Introduction to Cooperation Dilemmas

**Learning Objectives:**
- Understand that individual choices can affect others
- Recognize the difference between sustainable and unsustainable harvesting
- Observe how cooperation and defection lead to different outcomes

**Key Concepts:**
- Cooperation vs. defection
- Sustainable vs. unsustainable resource use
- Short-term vs. long-term outcomes
- Trust and agreements

**Activities:**
1. Run the model with different harvest rates
2. Observe what happens when both foresters cooperate
3. Observe what happens when one foresters defects
4. Discuss: Why is it hard to cooperate even when it helps both?

**Assessment Indicators:**
- Can describe what happens with different harvest choices
- Recognizes that choices affect both foresters
- Understands the difference between sustainable and unsustainable harvesting

### Grades 6-8: Understanding Social Dilemmas

**Learning Objectives:**
- Explain the structure of social dilemmas
- Analyze how payoff structures affect cooperation
- Understand the role of trust and communication
- Explore conditions that make cooperation more or less likely

**Key Concepts:**
- Social dilemma structure
- Payoff matrices and costs/benefits
- Trust and reputation
- Communication and agreements
- Temptation to defect

**Activities:**
1. Create payoff matrices for different scenarios
2. Experiment with different regrowth rates
3. Discuss real-world examples of social dilemmas
4. Use causal mapping to diagram dilemma structure

**Assessment Indicators:**
- Explains why cooperation is difficult in dilemmas
- Analyzes how payoffs affect decisions
- Recognizes the role of trust and communication
- Can identify social dilemmas in real life

### Grades 9-12: Mechanisms and Solutions

**Learning Objectives:**
- Analyze the mathematical structure of social dilemmas
- Evaluate different solutions to dilemmas (punishment, communication, institutions)
- Connect to game theory and evolutionary biology
- Apply understanding to real-world resource management problems

**Key Concepts:**
- Game theory (Prisoner's Dilemma, Public Goods Game)
- Nash equilibrium
- Evolution of cooperation
- Institutional solutions
- Repeated interactions and reputation

**Activities:**
1. Analyze the model as a Prisoner's Dilemma
2. Explore how repeated interactions change outcomes
3. Design institutional solutions (rules, monitoring, punishment)
4. Apply to climate change, fisheries, and other real-world dilemmas
5. Use Tinbergen's questions to analyze cooperation

**Assessment Indicators:**
- Analyzes dilemmas using game theory concepts
- Evaluates different solution mechanisms
- Connects model to real-world problems
- Understands evolution of cooperation

## Content Anchor Alignment

### Primary Content Anchors

**1. Cooperation Games**
- Payoff matrices as representations of strategic interactions
- Prisoner's Dilemma structure
- Evolution of cooperation in repeated interactions

**2. Governing the Commons**
- Shared resource management
- Individual vs. collective interests
- Institutional solutions to dilemmas

### Secondary Content Anchors

**3. Global Sustainability Goals**
- Sustainable resource use
- Long-term vs. short-term thinking
- Intergenerational equity

**4. Our Mind**
- Trust and social cognition
- Temptation and self-control
- Fairness and reciprocity

## Thinking Tool Integration

### 1. Payoff Matrices
- **Application:** Students create and analyze payoff matrices for different harvest scenarios
- **Purpose:** Understand how costs and benefits shape decisions
- **Activity:** Create matrices for sustainable vs. unsustainable scenarios

### 2. Causal Mapping
- **Application:** Map how individual decisions → collective outcomes
- **Purpose:** Visualize the dilemma structure
- **Activity:** Diagram the causal chain from harvest to forest health

### 3. Tinbergen's Questions
- **Function:** How does cooperation help both foresters?
- **Mechanism:** How do harvest decisions affect the forest?
- **Development:** How do children learn to cooperate?
- **Evolution:** How did cooperation evolve in humans?

### 4. The Noticing Tool
- **What patterns do you notice in sustainable vs. unsustainable outcomes?**
- **What surprises you about the results?**
- **What questions does this raise about real-world dilemmas?**

### 5. Analogies
- Compare to: 
  - Climate change agreements
  - Fishery management
  - Public goods (clean air, parks)

### 6. Structure of Knowledge
- Connect to: Social dilemmas → Game theory → Cooperation → Resource management

## Competency Alignment

### OE-CONCEPT-oe-interdisciplinary-cooperation: Cooperation
- **Definition:** Coordinated behavior among individuals or groups that produces a mutual benefit not achievable, or less efficiently achieved, alone.
- **Connection:** Model shows the tension between individual and collective benefits
- **Performance Indicators:**
  - Explain why cooperation is difficult in dilemmas
  - Analyze conditions that favor cooperation
  - Evaluate solutions to cooperation problems

### OE-CONCEPT-oe-interdisciplinary-agency: Agency
- **Definition:** The capacity of an individual or system to act intentionally and make choices that influence outcomes.
- **Connection:** Foresters make strategic choices that affect outcomes
- **Performance Indicators:**
  - Recognize forester decision-making
  - Understand how choices affect collective outcomes
  - Analyze the role of agency in cooperation

## Assessment

### Integrated Causal Reasoning Assessment

**Assessment File:** [assessments/two-foresters.json](../assessments/two-foresters.json)

**Purpose:** Diagnose integrated vs. dichotomized reasoning about social dilemmas

**Format:** 5-item multiple-choice assessment with vignette

**Key Misconceptions Assessed:**
1. Individual blame (attributing problems to character)
2. Moral reasoning (using moral categories instead of analysis)
3. Technological optimism (assuming technical fixes)
4. Determinism (assuming relationships can't change)

### Additional Assessment Methods

**1. Payoff Matrix Analysis**
- Students create and analyze payoff matrices
- Assess understanding of strategic interactions

**2. Causal Mapping Tasks**
- Students diagram the dilemma structure
- Assess understanding of causal relationships

**3. Real-World Application**
- Students apply understanding to climate change, fisheries, etc.
- Assess transfer of learning

## Teaching Materials

### Lesson Plans

**Lesson 1: Introduction to Cooperation (Grades 3-5)**
- Duration: 45 minutes
- Objectives: Understand cooperation vs. defection, observe outcomes
- Activities: Model exploration, group discussion

**Lesson 2: Understanding Social Dilemmas (Grades 6-8)**
- Duration: 60 minutes
- Objectives: Analyze dilemma structure, payoff matrices
- Activities: Payoff matrix creation, causal mapping

**Lesson 3: Mechanisms and Solutions (Grades 9-12)**
- Duration: 90 minutes
- Objectives: Game theory analysis, solution design
- Activities: Game theory analysis, institutional design

## Common Misconceptions

1. **"Cooperation is always good"** - Explore when cooperation can be harmful
2. **"People cooperate because they're nice"** - Understand structural bases of cooperation
3. **"More cooperation is always better"** - Examine costs and trade-offs
4. **"Cooperation requires conscious intention"** - Learn about emergent cooperation
5. **"Once trust is broken, it can't be rebuilt"** - Study conditions for rebuilding trust

## Connections to Other Models

### Direct Connections
- **two-communities**: Compare individual vs. group-level cooperation
- **population-size-living-costs**: Explore effects of more agents
- **evolution-competition-forest-resources**: Add evolutionary dynamics

### Thematic Connections
- **evolution-ethnocentrism**: Compare cooperation with in-group favoritism
- **evolution-resource-use-social-behavior**: Explore punishment mechanisms
- **wolves-sheep-grass**: Compare cooperation vs. competition

## Extensions and Variations

### Model Extensions
1. Add more foresters (see Two Communities)
2. Add communication and reputation
3. Add punishment mechanisms
4. Add learning and strategy adaptation

### Cross-Model Comparisons
1. Compare with Two Communities (individual vs. group)
2. Compare with Evolution of Ethnocentrism (cooperation with markers)
3. Compare with Wolves-Sheep-Grass (cooperation vs. predation)

### Real-World Applications
1. Climate change agreements
2. Fishery management
3. Public goods provision
4. Teamwork and collaboration

## Schema-Ready Contribution

This strand is ready to be authored as a formal OECB contribution following the strand/substrand schema.

## References

- Ostrom, E. (1990). *Governing the Commons*. Cambridge University Press.
- Axelrod, R. (1984). *The Evolution of Cooperation*. Basic Books.
- Hardin, G. (1968). The tragedy of the commons. *Science*, 162(3859), 1243-1248.

---

**Last Updated:** 2025-01-09  
**Status:** Complete and ready for use  
**Contributors:** OpenEvo CCS Lab