---
title: 'AttentionViG: Cross-Attention-Based Dynamic Neighbor Aggregation in Vision GNNs'
description: LoG 2026 paper
categories: blog
---

*By Oguzhan Baser*

# AttentionViG: Cross-Attention-Based Dynamic Neighbor Aggregation in Vision GNNs

Accepted to the Fifth Learning on Graphs Conference (LoG 2026).

**Authors:** Hakan Emre Gedik, Andrew Martin, Mustafa Munir, Oguzhan Baser, Radu Marculescu, Sandeep P. Chinchali, and Alan C. Bovik.

**TL;DR:** AttentionViG teaches Vision GNNs which neighbors matter. Cross-attention dynamically weights neighboring nodes, helping sparse graphs suppress irrelevant features while reaching up to **83.9% ImageNet-1K top-1 accuracy**.

[Read the paper](https://arxiv.org/abs/2509.25570) | [PDF](https://arxiv.org/pdf/2509.25570)

<figure style="text-align: center;">
  <img src="{{site.baseurl}}/images/post/AttentionViG/02_architecture.png" alt="AttentionViG multi-scale architecture combining inverted residual blocks and Grapher layers" style="max-width: 100%; height: auto; margin: auto; display: block;">
  <figcaption>Figure 1. Overview of the AttentionViG architecture across scales.</figcaption>
</figure>

## Motivation

Vision Graph Neural Networks (ViGs) represent image patches as nodes and exchange information through graph edges. Their performance depends on graph construction and on how each node aggregates its neighbors.

Dynamic k-nearest-neighbor graphs can capture semantic relationships, but neighbor search is expensive. Fixed sparse graphs such as SVGA are more efficient, yet may connect semantically unrelated nodes. Common aggregation operators also lack an explicit mechanism for learning how important each proposed neighbor should be.

We ask:

- **Q1 (Adaptive aggregation):** Can a ViG learn which proposed neighbors are relevant instead of treating every connection equally?
- **Q2 (Efficiency and transfer):** Can it retain sparse graph efficiency while improving classification and dense prediction?

## Contributions

- **Cross-attention aggregation.** Queries come from each node, while keys and values come from its neighbors. Cosine similarity is transformed through an exponential affinity function, giving neighbors independent relevance weights rather than forcing them to compete through softmax.
- **AttentionViG.** We integrate this aggregation into a multi-scale hybrid CNN-GNN architecture. Inverted residual blocks perform local processing, while Grapher layers use efficient SVGA connectivity for non-local message passing.
- **Broad evaluation.** We evaluate AttentionViG on ImageNet-1K, MS-COCO, and ADE20K.

<figure style="text-align: center;">
  <img src="{{site.baseurl}}/images/post/AttentionViG/01_cross_attention.png" alt="Cross-attention aggregation uses node queries and neighbor keys and values to learn independent neighbor relevance weights" style="max-width: 100%; height: auto; margin: auto; display: block;" loading="lazy">
  <figcaption>Figure 2. Cross-attention aggregation: neighbor weighting and aggregation pipeline.</figcaption>
</figure>

## How AttentionViG Works

The key idea is to separate graph construction from neighbor importance. SVGA supplies candidate neighbors; cross-attention learns which should contribute strongly and which should be suppressed. This makes message passing adaptive to image content without expensive dynamic neighbor search. The parallelized Grapher implementation retains linear scaling with input resolution.

## Results

On ImageNet-1K, AttentionViG-S/M/B achieve **81.3% / 83.1% / 83.9% top-1 accuracy** at **1.6 / 3.2 / 4.8 GFLOPs**. AttentionViG-B matches GreedyViG-B at 83.9% while using 4.8 rather than 5.2 GFLOPs. These results use the paper's training setup with knowledge distillation from a RegNetY-16GF teacher.

<figure style="text-align: center;">
  <img src="{{site.baseurl}}/images/post/AttentionViG/03_imagenet_results.png" alt="ImageNet-1K results: AttentionViG-S 81.3 percent at 1.6 GFLOPs, M 83.1 percent at 3.2 GFLOPs, and B 83.9 percent at 4.8 GFLOPs" style="max-width: 100%; height: auto; margin: auto; display: block;" loading="lazy">
  <figcaption>ImageNet-1K performance summary. Values are reported in the paper.</figcaption>
</figure>

AttentionViG-B also reaches **46.4 box AP and 42.3 mask AP on MS-COCO**, and **47.8 mIoU on ADE20K**, using Mask R-CNN and Semantic FPN, respectively.

<figure style="text-align: center;">
  <img src="{{site.baseurl}}/images/post/AttentionViG/04_dense_prediction.png" alt="AttentionViG-B dense prediction results: 46.4 box AP and 42.3 mask AP on COCO, and 47.8 mIoU on ADE20K" style="max-width: 100%; height: auto; margin: auto; display: block;" loading="lazy">
  <figcaption>COCO and ADE20K transfer performance summary. Values are reported in the paper.</figcaption>
</figure>

In vanilla ViG, cross-attention reaches 74.3% top-1 at 1.6 GFLOPs, matching EdgeConv's accuracy at about two-thirds of its FLOPs. In the affinity-function ablation, exponential affinity reaches 81.3% top-1 versus 80.8% with softmax.

Similarity visualizations show the model emphasizing semantically related regions while suppressing unrelated ones.

<figure style="text-align: center;">
  <img src="{{site.baseurl}}/images/post/AttentionViG/05_neighbor_visualization.png" alt="Query-key similarity maps for fish and bird images highlight semantically related regions" style="max-width: 100%; height: auto; margin: auto; display: block;" loading="lazy">
  <figcaption>Figure 3. Query-key similarity visualizations highlighting semantically related regions.</figcaption>
</figure>

## Impact

AttentionViG shows that efficient graph construction does not require every proposed edge to be equally useful. Learning neighbor relevance allows Vision GNNs to remain sparse and efficient while becoming more selective about the information they propagate. Extending the aggregation idea to video, point clouds, and other graph-based domains is a promising direction for future work.

For the complete experiments, ablations, and implementation details, [read the paper](https://arxiv.org/abs/2509.25570).
