---
title: "TensorCommitments: A Lightweight Verifiable Inference for Language Models"
description: NeurIPS 2026 paper
categories: blog
---

*By Oguzhan Baser and the TensorCommitments team*

# A receipt for a cloud LLM run

Accepted to the 40th Conference on Neural Information Processing Systems (NeurIPS 2026).

**Authors:** Oguzhan Baser, Elahe Sadeghi, Eric Wang, Nico Vergauwen, Sam Kazemian, Hong Kang, Sandeep P. Chinchali, and Sriram Vishwanath.

**TL;DR:** TensorCommitments lets a lightweight client check selected hidden states from a remote LLM run using compact cryptographic commitments. On LLaMA 2-13B, the paper reports 98.6 ms of post-inference prover time and 12 ms of verifier time, with no verifier GPU.

[Read the paper](https://arxiv.org/abs/2602.12630) | [Explore the code](https://github.com/NeurIPS26TC/TensorCommitment)

## The question behind the answer

A cloud model returns text. What it does not return is much evidence of the computation that produced it. A client could rerun the model to compare results, but that assumes access to the weights and another GPU. The problem grows sharper when inference is part of a longer workflow: one altered prompt, weight block, or intermediate state can quietly change what comes next.

TensorCommitments asks a practical question: can the service leave a compact, checkable record of an inference while the client remains lightweight?

## Keep the tensor structure

A commitment is a cryptographic tag for data: change the data, and the tag should no longer match. Many schemes first flatten model activations into long vectors. TensorCommitments instead commits to activation tensors through multivariate polynomials, preserving the axes that make the data a tensor in the first place. In the paper's fixed-size interpolation experiment, moving from one to two dimensions reduces runtime from 4.1 seconds to 0.125 seconds. That observation motivates the construction; it is an interpolation benchmark, not an end-to-end inference speedup.

The commitments are organized in a *Terkle Tree*. A single root binds the evolving states of an interaction, while a verifier can request a path to a selected value and check it without replaying the model. The tree makes the record compact enough to query, and the multivariate openings retain the shape of the underlying data.

![TensorCommitments inference workflow]({{site.baseurl}}/images/post/TensorCommitments/01_workflow.png)
*Figure 1. From activation tensors to a challenged proof checked by the verifier (paper Fig. 2).*

## Spend checks where they matter

Checking every layer of a large model would erase much of the efficiency gain. The paper therefore scores layers using spectral properties of their weights and allocates a fixed verification budget to influential blocks. This is a deliberate trade-off: the cryptographic opening verifies what was selected, while attack detection still depends on which layers are checked and on the verifier's budget. TensorCommitments is not presented as a full zero-knowledge proof of every operation.

![Attack manipulation coverage from the layer-selection experiment]({{site.baseurl}}/images/post/TensorCommitments/02_layer_selection.png)
*Figure 2. Attack manipulation coverage for layer-selection policies (paper Fig. 5).*

## What the experiments show

For LLaMA 2-13B on an A100, the paper reports 10.165 seconds for base inference. TensorCommitments adds 98.6 ms of post-inference prover work and 12 ms of verification: roughly 0.97% and 0.12% of that base time. The verifier's reported GPU use is 0 GB. In the paper's evaluated attack suite, detection accuracy is 96.02%, versus 82.59% for the TOPLOC baseline. The study also reports up to a 48% improvement under prompt-tampering attacks, and its layer-selection policy covers up to 75% more attacked layers than alternatives at the same budget.

![Performance comparison with prior verifiable inference methods]({{site.baseurl}}/images/post/TensorCommitments/04_system_overhead.png)
*Figure 3. LLaMA 2-13B system and detection comparison (paper Table 1).*

![Detection accuracy under tailored attacks]({{site.baseurl}}/images/post/TensorCommitments/03_attack_detection.png)
*Figure 4. Detection across tested attack scenarios (paper Fig. 7).*

These numbers belong to the reported models, hardware, attacks, and selection budgets. They show a promising efficiency and detection profile; they do not imply that every possible tampering attempt will be caught.

## Where this leads

Remote inference will be easier to trust when a client can ask for evidence, rather than accepting only a fluent answer. TensorCommitments offers one route toward that goal: proofs tied to model tensors, a tree that binds an interaction, and verification costs small enough for a client without a GPU.

The limits matter too. The design needs a trusted setup, the prover needs GPU access to the activations, and the paper does not claim full zero knowledge. Its robustness is bounded by the layers and checks a verifier can afford. Those constraints point directly to the next research questions: stronger coverage, more distributed trust, and privacy guarantees that remain practical at LLM scale.

[Paper](https://arxiv.org/abs/2602.12630) | [Code](https://github.com/NeurIPS26TC/TensorCommitment)
