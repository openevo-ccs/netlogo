# Two Foresters with learning (research variant)

A copy of the [Two Foresters](../../models/two-foresters/) model in which each forester learns its harvest percentage from the wood it takes. The classroom model is unchanged. Open `two-foresters-learning.nlogox` in NetLogo 7 (built and tested on 7.0.4).

Drafted with AI assistance, open for review. All results below are simulated and say nothing about real foresters or forests.

## Why it exists

Borgstede and Eggert (2021) derive a law for reinforcement learning from the Price equation. It says that, within a block of trials, the change in a learner's behavior follows the covariance between the behavior it tried and a predictor of benefit, here the wood taken. This variant lets us check that law in a small social-ecological model and see where the wood taken now stops being a good guide to wealth later.

## What was changed

* Each forester has a typical harvest percent (the starting value is the old Percent-cut slider). Each tick it tries a percent close to that level, plus or minus **Exploration**.
* After each block of **Block-length** ticks it computes S, the covariance of tried percent and wood taken divided by the mean wood taken, and shifts its typical level by **Learning-rate** times S.
* **Learning-rule** has two controls: "no learning" and "away from payoff".
* The old model created a new fence on every tick in the private forest. The variant adds a fence once.
* New monitors and the plot "Predicted vs observed change" compare S with the change actually seen in the next block.

## What the runs show

Three BehaviorSpace experiments are saved in the model file. Raw tables and summaries are in `results/`, and `analyze.py` recomputes the summaries.

**1. Does S predict the change?** (experiment `learning-rules`, 30 runs per setting, 500 ticks, blocks of 25 ticks, exploration of 10 points.)

| Rule | Share of blocks where the observed change has the sign of S | Median correlation of S with the observed change |
|---|---|---|
| toward payoff | 0.56 to 0.77 | 0.29 to 0.74 |
| no learning (control) | 0.49 to 0.54 | 0.07 to 0.20 |
| away from payoff (control) | 0.18 to 0.26 | scattered around zero, down to -0.54 in one setting |

The law follows the learners that learn toward payoff and misses the controls, as it did in the earlier agent test. The fit is looser here than in that test.

**2. Why the fit is loose.** (experiment `noise-sweep`, 1000 ticks.) Correlation rises with exploration, from a median of 0.12 to 0.28 at 5 points to 0.62 to 0.81 at 20 points, because wider variation gives the covariance more to work with. The share of correct signs reaches 0.95 with blocks of 100 ticks and 10 points of exploration. With short blocks and little variation, chance differences between blocks swamp the signal.

**3. Does wood taken now predict wealth later?** (experiment `proxy-validity`, forester 1 held fixed at 5 to 100 percent, forester 2 at 50, 200 ticks, 10 runs per level.)

| Forest | Correlation of first-block wood with wealth at 200 ticks | Level giving most early wood | Level giving most wealth at 200 ticks |
|---|---|---|---|
| private | 0.54 | 100 percent | 70 percent |
| shared | 0.80 | 100 percent | 85 percent |

In both forests the immediate payoff points at the highest level, and the best level for wealth is lower. The gap is larger in the private forest.

**A prediction that did not hold.** Before running, I expected learners in the shared forest to drift toward over-cutting and learners in the private forest to settle lower. Both drifted toward 78 to 88 percent. The private forester that started at 90 percent stayed high and ended with about a fifth of the wealth of its neighbor, probably because its trees were cut down early and regrow slowly from a low height. I did not test that explanation. If it holds, the trap comes from the forest's state, which the law does not describe.

## Limits

* The payoff is wood taken in one tick, which is a crude stand-in for long-term wealth.
* The law's slope is set to 1 because the predictor is the payoff itself.
* The paper covers the survival part of fitness, one context at a time, and a linear predictor. It tests nothing on new data. Critics of its claim that learning is part of natural selection are not read here.
* Runs end at 200 to 1000 ticks, so the results describe those spans.

## Files

* `two-foresters-learning.nlogox` is the model, with the three experiments.
* `analyze.py` and `results/` hold the analysis and the data.

## Source

Original model: Two Foresters, OpenEvo / TeachingBase, CC BY-SA 4.0. Borgstede, M., and Eggert, F. (2021). The formal foundation of an evolutionary theory of reinforcement. Behavioural Processes, 186, 104370. https://doi.org/10.1016/j.beproc.2021.104370
