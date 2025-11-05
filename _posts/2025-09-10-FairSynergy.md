---
title: 'FairSynergy: Fair Resource Allocation for Fleet Intelligence'
description: GLOBECOM 2025 paper
categories: blog
---

*By Oguzhan Baser*

# FairSynergy: Fair Resource Allocation for Fleet Intelligence

2025 IEEE Global Communications Conference (GLOBECOM 2025)

**TLDR:** Give or substitute each extra unit of compute or memory to the agent that benefits most to lift fleet accuracy by up to +25% in inference and +11% in training, with even bigger gains as fleets grow!

[arXiv](https://arxiv.org/abs/2509.03353) |
[Code](https://github.com/UTAustin-SwarmLab/Fair-Synergy)

## Motivation
Intelligent fleets involving machine learning (ML) deployed drones, autonomous cars, or phones rarely look uniform. Some fleet agents have much better on-board compute or memory, while others face harder inputs such as hard-to-parse images and complex prompts. While cloud assists fleets by allocating its limited resources, it is not really trivial how to allocate for optimal collective performance across the heterogeneous agents. If we split cloud resources evenly, we waste the budget on saturated parts of the accuracy-vs-resource curve while starving steep ones. We ask:

- **Q1 (Fairness):** Where does the next unit of resource raise accuracy the most?
- **Q2 (Multivariate Utility):** How can we substitute multiple types of ML resources available?


<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/FS_sysarch.png" alt="FairSynergy System Plot" height="auto" style="margin: auto; display: block;">
   <figcaption>FairSynergy Overview</figcaption>
   <p></p>
</figure>


## Contributions
We introduce FairSynergy, a novel framework to allocate cloud resources fairly across the intelligent heterogeneous agents.
- **Diminishing Marginal Returns:** We empirically show that learning and inference curves across vision and language models consistently have the same concave pattern: accuracy improves with more resources (e.g., model size, data, compute) but with diminishing returns.
- **Fair Allocation in ML:** With a concave objective, Network Utility Maximization (NUM) is the natural fit. It mathematically implies the condition turns into an intuitive policy: allocate so each agent’s next unit of resource yields the same marginal accuracy gain. 
- **Cobb-Douglas:** Like capital and labor in production, compute/model capacity and labeling/data curation both drive accuracy, each with diminishing returns and substitution. We form a multivariate utility captures this to co-allocate the resources. (Figs. 5–6)

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/FS_concavetraining.png" alt="Results Boxplot" height="auto" style="margin: auto; display: block;">
   <figcaption>The Law of Diminishing Marginal Returns: Training</figcaption>
   <p></p>
</figure>

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/FS_result_concaveinference.png" alt="Results Boxplot" height="auto" style="margin: auto; display: block;">
   <figcaption>The Law of Diminishing Marginal Returns: Inference</figcaption>
   <p></p>
</figure>

## FairSynergy Framework

- **Inference Setting (RTI)- Univariate Case (Compute):** At short intervals, the framwork estimates each agent’s next-unit accuracy gain from extra cloud compute. Give the next unit to the highest gain, repeat until gains are roughly equalized—then reshuffle as conditions change. This hits the fairness/efficiency sweet spot without heavy tuning.


- **Learning Setting (DL) - Bivariate Case (Compute + Labeling Effort):**  The framework uses the same “next-unit” idea with a quick two-step loop: hold labels fixed and split compute by the one resource rule; then hold compute fixed and split labeling time by the same rule. A few rounds settle to a stable co-allocation so compute-hungry agents get cycles and data-hungry agents get labels.

- **Handling Heterogeneity:** Harder tasks show larger early gains, so the allocator leans into them first and naturally rebalances as gains even out. The result is proportional fairness and fleet-level accuracy that scales with more agents and changing workloads—no math knobs to tune. 

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/FS_result_concaveinference.png" alt="Results Boxplot" height="auto" style="margin: auto; display: block;">
   <figcaption>**Extending Multivariate ML Utility**: Cobb-Douglas Production Function For a Given Capital and Labor</figcaption>
   <p></p>
</figure>

## Results


We compare our method to common baselines and standard fair allocation methods:

- **Fair-Synergy (Ours)** allocates compute (and labels) to equalize next-unit accuracy gains per agent using fitted concave utilities.

- **Random Allocation** splits the available compute (and labels) at random among agents.

- **Uniform Allocation** gives every agent the same share of compute (and labels), ignoring local differences.

- **Classical NUM** optimizes a uniform log utility (identical response curves), so allocation follows equalized marginal gains without task-specific reweighting and agent heterogeneity.

- **Dominant Resource Fairness (DRF)** equalizes each agent’s dominant resource share, targeting max–min fairness across resources.

- **Leximin** prioritizes the worst-off first, maximizing the minimum utility, then the next, and so on. It is a stricted form of fairness compared to other methods.

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/FS_result_boxplot.png" alt="Results Boxplot" height="auto" style="margin: auto; display: block;">
   <figcaption>How well does Fair-Synergy perform compared to the benchmarks?</figcaption>
   <p></p>
</figure>

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/FS_result_lineplot.png" alt="Results Lineplots" height="auto" style="margin: auto; display: block;">
   <figcaption>How does Fair-Synergy scale with increasing number of agents?</figcaption>
   <p></p>
</figure>

### Key findings:
- **Fairness-Accuracy Trade-off:** We observe for stricter fairness conditions, while the worst case accuracy increases the aggregate accuracy decreases. Hovewer, we achieve the best trade-off by obtaining both the best performance and necessary fairness conditions. 
- **Scalability:** As fleets grow, our method converts heterogeneity into higher accuracy unlike (+6% RTI, +30% DL) and Uniform/DRF/Leximin (+13% RTI, +51% DL) at 100 agents. 


## Impact
Fair-Synergy treats fairness as physics, not philosophy. Fairness means, no single agent experiences an increase in its accuracy while reducing the other's accuracy more. As accuracy is concave, the right thing is to spend cloud resources where marginal gains are steepest and to do so optimize jointly over multiple substitutable resources. A fair allocation is the most efficient allocation because concavity makes “equalize marginal gains” optimal.
