---
title: About
permalink: /about/
---

## About us

<!-- <img class='img-responsive center-block' src="/images/logo/swarm-lab-logo.png" width="100%" height="100%" /> -->

We are a group of scientists and engineers working at the intersection between robotics, control theory, machine learning, and game theory to design high performance, interactive autonomous systems. Our lab is based in the [Department of Electrical and Computer Engineering](https://www.ece.utexas.edu) [Wireless Networking and Communications Group (WNCG)](https://wncg.org/) and [Texas Robotics](https://robotics.utexas.edu) at UT Austin.

## Research
Some of our lab's core research interests are:

### **Blockchain Applications in Machine Learning and Federated Learning, Control Methods for Token Economies**:

Current Federated Learning (FL) and decentralized Machine Learning (ML) applications suffer from potential attacks from adversarial participants and may result in poor performance. Blockchain is a great tool to enable decentralized applications to build trust in the network. We develop algorithms that use blockchain at its core to implement FL and ML robustly.

Additionally, recently many infrastructure systems have started using blockchain to make their system truly decentralized. To control such systems, widely used methods are heuristic and don’t include adaptability to network changes. We defined these economies as dynamical systems and then utilized [control and game theory methods to reach desired system behaviors](https://arxiv.org/abs/2210.12881). We are interested in widening the game and control theoretical aspects of the blockchain economies under different applications. 

### **Decentralized Data Sharing Algorithms for Multi-agent Systems**:

Federated learning (FL) has been widely used in multi-agent systems with homogeneous neural models. However, FL is not suitable when agents have heterogeneous models whose gradients of weights cannot be shared. We proposed [decentralized data-sharing algorithm](https://openreview.net/forum?id=iM932PeUi_7) for agents with heterogeneous models. We aim to design provably convergent algorithms achieving the same performance as the centralized ones with linear time complexity execution. We envision that related challenges are in the following aspects: 1) how to share data while [preserving privacy](https://proceedings.mlr.press/v164/geng22a.html); 2) how to [evaluate](https://proceedings.mlr.press/v164/geng22a.html) the contribution of data shared to others in terms of model performance.
<!-- In our algorithm, agents share data with each other and collaboratively achieve any data distribution by playing a potential game. Also, when the number of agents is large, we proposed a decentralized algorithm to select a subset of agents to play the potential game. We show that our algorithms are provably convergent and achieve the same performance as the centralized algorithm with linear time complexity execution. -->

### **Realistic Adversarial Data Augmentation for Robust Models**: 

State-of-the-art data augmentation methods use random data cropping and rotation techniques on **pixel domain**. However, we argue that these methods do not capture the real world adversarial examples. We propose new data augmentation methods for time series in [model predictive controllers](https://ieeexplore.ieee.org/abstract/document/9929419) and images in [vision-based robotic controllers](https://openreview.net/forum?id=WJbw_C-pCox). We use gradient ascent to generate realistic adversarial examples. Our methods are more effective than the current data augmentation methods in terms of **robustness** and **performance** on unseen datasets.


## Lab Members

Our group started in August 2021. Visit our [people page](/people/) for profiles of lab members.

## Prospective students
Prospective graduate student please reach out to Sandeep by email to express your interest. Please include a CV and a brief note about your research interests and put "Potential Graduate Student" in the subject of your mail. We are looking for students with a strong background in control theory, machine learning, and/or game theory. We are also interested in students with a strong background in robotics, computer vision, and/or wireless communications.