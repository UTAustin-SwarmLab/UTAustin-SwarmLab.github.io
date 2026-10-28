---
title: About the lab
eyebrow: About
lede: We design high performance, interactive autonomous systems at the intersection of robotics, control theory, machine learning, and game theory.
permalink: /about/
---

<div class="about">
  <section class="about__intro prose" aria-labelledby="about-who">
    <h2 id="about-who">Who we are</h2>
    <p>We are a group of scientists and engineers working at the intersection between robotics, control theory, machine learning, and game theory to design high performance, interactive autonomous systems. Our group started in August 2021.</p>
    <p>Our lab is based in the <a href="https://www.ece.utexas.edu">Department of Electrical and Computer Engineering</a>, the <a href="https://wncg.org/">Wireless Networking and Communications Group (WNCG)</a> and <a href="https://robotics.utexas.edu">Texas Robotics</a> at UT Austin.</p>
    <p class="about__cta">
      <a class="btn btn--primary" href="/research/">Explore our research <svg class="icon" aria-hidden="true"><use href="#i-arrow-right"/></svg></a>
      <a class="btn btn--secondary" href="/people/">Meet the people</a>
      <a class="btn btn--secondary" href="/join/">Join us</a>
    </p>
  </section>

  <dl class="facts">
    <div><dt>Founded</dt><dd>August 2021</dd></div>
    <div><dt>Affiliations</dt><dd>ECE &middot; Texas Robotics &middot; WNCG</dd></div>
    <div><dt>Where</dt><dd>Anna Hiss Gym 2.204, UT Austin</dd></div>
  </dl>

  <section class="about__research prose" aria-labelledby="about-research" markdown="1">
<h2 id="about-research">Research</h2>
<p>Our research is organized into five themes, from swarm coordination and fleet learning to trustworthy and verifiable machine learning. The <a href="/research/">Research page</a> lists each theme with its papers, and <a href="/publications/">Publications</a> has everything in one searchable list.</p>

<details class="disclosure" markdown="1">
<summary>Earlier research directions (2022)</summary>

Some of our lab's core research interests were:

### **Blockchain Applications in Machine Learning and Federated Learning, Control Methods for Token Economies**:

Current Federated Learning (FL) and decentralized Machine Learning (ML) applications suffer from potential attacks from adversarial participants and may result in poor performance. Blockchain is a great tool to enable decentralized applications to build trust in the network. We develop algorithms that use blockchain at its core to implement FL and ML robustly.

Additionally, recently many infrastructure systems have started using blockchain to make their system truly decentralized. To control such systems, widely used methods are heuristic and don’t include adaptability to network changes. We defined these economies as dynamical systems and then utilized [control and game theory methods to reach desired system behaviors](https://arxiv.org/abs/2210.12881). We are interested in widening the game and control theoretical aspects of the blockchain economies under different applications. 

### **Decentralized Data Sharing Algorithms for Multi-agent Systems**:

Federated learning (FL) has been widely used in multi-agent systems with homogeneous neural models. However, FL is not suitable when agents have heterogeneous models whose gradients of weights cannot be shared. We proposed [decentralized data-sharing algorithm](https://openreview.net/forum?id=iM932PeUi_7) for agents with heterogeneous models. We aim to design provably convergent algorithms achieving the same performance as the centralized ones with linear time complexity execution. We envision that related challenges are in the following aspects: 1) how to share data while [preserving privacy](https://proceedings.mlr.press/v164/geng22a.html); 2) how to [evaluate](https://proceedings.mlr.press/v164/geng22a.html) the contribution of data shared to others in terms of model performance.

### **Realistic Adversarial Data Augmentation for Robust Models**: 

State-of-the-art data augmentation methods use random data cropping and rotation techniques on **pixel domain**. However, we argue that these methods do not capture the real world adversarial examples. We propose new data augmentation methods for time series in [model predictive controllers](https://ieeexplore.ieee.org/abstract/document/9929419) and images in [vision-based robotic controllers](https://openreview.net/forum?id=WJbw_C-pCox). We use gradient ascent to generate realistic adversarial examples. Our methods are more effective than the current data augmentation methods in terms of **robustness** and **performance** on unseen datasets.

</details>
</section>

  <section class="about__people prose" aria-labelledby="about-people">
    <h2 id="about-people">People and joining</h2>
    <p>Visit our <a href="/people/">people page</a> for profiles of lab members and alumni. If you would like to work with us, see <a href="/join/">how to apply</a>. For a look at life in the lab, browse our <a href="/lab_pictures/">photos</a>.</p>
  </section>

  <section class="about__support prose" aria-labelledby="about-support">
    <h2 id="about-support">Support</h2>
    <p>Our work is supported by NSF, DARPA, ONR, Cisco, Intel, Lockheed Martin, Honda Research Institute, Viavi and UT Good Systems.</p>
  </section>
</div>
