# BehaviorSpace Experiment Templates

This directory contains pre-configured BehaviorSpace experiment templates for each NetLogo model. These templates provide guided exploration of key concepts and phenomena.

## What are BehaviorSpace Experiments?

BehaviorSpace is NetLogo's built-in tool for running multiple simulations with different parameter values. It allows you to:

- Systematically explore how parameters affect outcomes
- Run many simulations automatically
- Collect data for analysis
- Test hypotheses about model behavior

## Using These Templates

1. Open the model in NetLogo desktop
2. Go to Tools → BehaviorSpace
3. Click "Import" and select the experiment file
4. Run the experiment and analyze results

## Experiment Categories

### Parameter Sweeps
Explore how changing one parameter affects outcomes while keeping others constant.

### Comparative Experiments
Compare different scenarios (e.g., local vs. global interaction).

### Sensitivity Analysis
Test how sensitive outcomes are to parameter changes.

## Experiment Naming Convention

`<model-slug>-<experiment-type>-<description>.xml`

## Contributing

When adding new experiments:

1. Follow the naming convention
2. Include a brief description in the experiment name
3. Document the purpose and expected findings in this README
4. Test the experiment before committing

## Status

| Model | Experiments Available |
|-------|----------------------|
| evolution-ethnocentrism | ✅ 3 experiments |
| two-foresters | 🔄 In progress |
| bug-evolution | 🔄 In progress |
| [other models] | ⏳ Not started |