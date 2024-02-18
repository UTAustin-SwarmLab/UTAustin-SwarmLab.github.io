---
title: 'Online Foundation Model Selection in Robotics'
description: 
categories: blog
---

*By Po-han*

# How to Choose the Right Foundation Model for Robotics? Exploring Online Learning for Model Selection

[Link to paper](https://arxiv.org/abs/2402.08570)

## Motivation

The integration of foundation models into robotics marks a new era of innovation, promising to transform the landscape with unprecedented efficiency and capabilities. 
However, this transition is not without its challenges, particularly in the selection between high-performance, expensive closed-source models and more accessible, albeit potentially less powerful, open-source alternatives. This paper presents a solution to this dilemma, introducing an online learning framework that adeptly navigates the intricate trade-offs between cost, efficiency, and performance of both closed-source and open-source models.

## The Solution

The solution's backbone is a user-centric online model selection pipeline (as shown below), utilizing a pre-trained open-source encoder to simplify complex data into low-dimensional embeddings for an online learning algorithm. This strategy not only avoids the steep costs associated with collecting data from closed-source models for supervised-learning methods but also leverages the adaptability of online learning to select models, considering factors such as performance, time efficiency, and financial limitations.

<figure>
    <img src="{{site.baseurl}}/images/post/online_system.png" alt="System Pipeline">
   <figcaption>Online model selection pipeline</figcaption>
   <p></p>
</figure>

In the pipeline, a user sends their intentions in natural language and images to a model selected from a range of available options.
To do so, an encoder first processes the language and visual inputs to extract features. 
These features help an online learning algorithm select the suitable model that maximizes accuracy and minimizes response latency and monetary costs. 
The algorithm should avoid selecting models that execute incorrectly, marked with red crosses. 
The above examples come from the ALFRED dataset.

## Theory and Experiments

A thorough theoretical analysis underpins the superiority of contextual algorithms over non-contextual counterparts in model selection, demonstrating how the proposed method effectively balances these factors to make informed decisions. The experimental results further corroborate this, showcasing a significant improvement in task success rates across various language-based robotic applications, highlighting up to a  14% increase in efficiency compared to conventional methods.

Expanding on these findings, the paper delves deeper into the nuances of online learning algorithms, exploring their potential to revolutionize model selection processes. It examines the scalability of the proposed framework, considering its applicability across a broad spectrum of robotic tasks. The discussion extends to the implications of these advancements for the broader field of robotics, emphasizing the role of intelligent model selection in enhancing the autonomy and versatility of robotic systems.

<!-- Moreover, the paper addresses potential challenges and future directions, including the integration of more complex decision-making algorithms and the exploration of new domains for application. It calls for a collaborative effort within the research community to refine and expand upon the proposed framework, highlighting the importance of interdisciplinary approaches in tackling the multifaceted challenges of robotics and artificial intelligence. -->

In conclusion, this study not only provides a pragmatic solution to a pressing challenge in robotics but also lays the groundwork for future innovations. By bridging theoretical analysis with empirical evidence, it underscores the transformative potential of online learning algorithms in model selection, setting a new benchmark for efficiency, cost-effectiveness, and adaptability in robotic applications.
