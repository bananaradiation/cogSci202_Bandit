cogSci202_Bandit
================

## COGS 202 (UCSD) Final Project

## Temporal effects on decision making regarding the 2 (or K)-arm bandit problem

Team Members: Chun, Sneha, Sonali, Hannah, Yashodhan

# Research Motivation:
Balancing exploration and exploitation is essential for survival in an uncertain environment. Yet optimizing the process often requires complex computation that humans seldomly calculate consciously. We are interested in exploring what kind of models mimic human decision making and also match with optimal decision making models for 2 (or K)-arm bandit problems. We are also interested in providing insights into reasons for sub-optimal decision making in humans. This work is motivated from [1]. We hope to extend the existing models to observe temporal effects like changes in human behavior or the state of world on performance of various models.

# Extension Ideas:
One or more of the following extensions can be implemented:
* Reward value not fixed (for either exploration or exploitation). Investigation of whether the results presented in Lee et al. also extend to the case when rewards are continuous instead of binary.
* Multiple trials are not independent of each other
What happens if exploiting the same arms again leads to diminishing returns?
* What happens if exploration is encouraged over exploitation?
This can be modeled by changing weights for subsequent same choices (discount factor).
* The distribution of reward probability in the machine changes, e.g. having two distributions with a single switch from one to the other
* What happens when the underlying distribution of rewards from an alternative changes? We are talking about an abrupt change where the prior on the rewards changes. Does the synthetic data corresponding to the specific world/distribution match the results presented in Lee et al., and is there a noticeable decision shift when the distribution shifts?
* We hypothesize that the general latent state model will perform better in this case compared to the 𝜏-switch model since it is completely unconstrained in terms of exploration and exploitation states.
* Try to model the case where human memory is not entirely reliable but based on (possibly incorrect) recollection. This could be modeled by changing the memory window instead of recalling the outcomes of every previous trial.

# References:
[1] M. D. Lee, S. Zhang, M. Munro, and M. Steyvers. Psychological models of human and optimal performance in bandit problems. Cognitive Systems Research, 12:164–174, 2011.

