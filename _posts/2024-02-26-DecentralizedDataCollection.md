---
title: 'Decentralized Data Collection for Robotic Fleet Learning: A Game-Theoretic Approach'
description: CoRL 2022 paper
categories: blog
---

*By Oguzhan A.*

# Robotic Fleet Data Collection Through Game Theory

[Link to paper](https://proceedings.mlr.press/v205/akcin23a.html)

## Motivation

In the rapidly evolving landscape of autonomous vehicles (AVs) and robotics, the efficient collection and utilization of data are crucial. Traditional data collection methods often lead to redundancy and inefficient use of bandwidth and storage. To deal with these challenges, we propose a strategic game between robots to sample data points to optimize data sampling, aiming to minimize the gap between current and target data distributions. This game-theoretic solution reaches a Nash equilibrium with only one message passing between AVs, offering an optimal strategy for data collection across robotic fleets.

### The Challenge

AVs traditionally operate in isolation, prioritizing data collection based on individual, often greedy strategies. This isolation can lead to resource wastage and inefficiency. Coordination among AVs is essential to ensure the selection of the most valuable data points, avoiding redundancy and optimizing the collective data collection effort.

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/data_games_toy_example.jpg" alt="Toy Example" width="50%" height="auto" style="margin: auto; display: block;">
   <figcaption>A motivating toy example with 2 robots and 2 classes</figcaption>
   <p></p>
</figure>


In the figure above, we show a toy example of why data collection needs to be coordinated. Here there are two robots observing data with only 2 classes. The axes represent the number of data points for each class. Our goal is to reach a target distribution (blue cross) where each class has 120 data points, represented by (120,120). The robots start at (0,0) with no data points in the cloud. The possible combinations that can be uploaded from robots 1 and 2 are shown as the shaded feasible action spaces (yellow and purple). This shaded region is determined by the robot's local data distribution and vision model accuracy. **_Greedy_** (black) individually calculates the projection of the target distribution onto each robot's feasible action space, but the sum of actions may not be optimal leading to a high error (red). However, **_Oracle_** accounts for the two robots' action spaces and this minimizes the error between the target dataset and the sum of actions (grey).


## A Game-Theoretic Solution

We frame the data collection problem as a *potential game* between networked AVs. Then, we show that this game reaches Nash equilibria based on the best-iterated response policy after only one message passings between the AVs. This equilibrium represents the collective optimization of data collection strategies, ensuring an optimal solution for the entire fleet.

### How Interactive Policy Works


<figure>
    <img src="{{site.baseurl}}/images/post/data_games_framework.png" alt="Game-Theoretic Data Collection">
   <figcaption>Game-Theoretic Data Collection</figcaption>
   <p></p>
</figure>

Each step in our cooperative algorithm is numbered in blue. First, each AV *i* observes a sequence of images in round *r* of data collection (*step 1*). Then, it classifies each image with a local vision model (*step 2*). Then it samples a limited set of images according to its action policy which governs what distribution of data points to upload. Crucially, the action to what data points to upload is chosen cooperatively with other AVs using a distributed optimization problem (*step 3*). Next, each AV transmits its local cache of data points to the cloud (*step 4*). The current cloud dataset is updated with the newly uploaded data points (*step 5*). The combined cloud dataset can be used to periodically retrain new model parameters (*step 6*), which are then downloaded by the AVs (*step 7*). All AVs share a goal of minimizing the distance between the collected cloud dataset and the target dataset. 

## Experimental Results 

We show that our **_Interactive_** approach is able to achieve superior performance to the traditional distributed approach and achieves the same performance as an optimal **_Oracle_** policy. Our **_Interactive_** approach achieves performance improvements by up to 21% in classification accuracy compared to the standard benchmarks.

<figure>
    <img src="{{site.baseurl}}/images/post/data_games_results.png" alt="Experimental Results">
   <figcaption>Experimental Results</figcaption>
   <p></p>
</figure>

In the figure above, each row represents a different dataset. *Column 1:* As expected by our theory, **_Interactive_** minimizes the L2-norm distance (optimization objective, y-axis) better than **_Greedy_** and matches the omniscient **_Oracle_**. *Column 2:* Clearly, **_Interactive_**  achieves a much more balanced distribution of classes (target distribution is uniform) than benchmarks. *Column 3:* Since **_Interactive_** achieves a more balanced dataset, this experimentally translates to a higher DNN accuracy (statistically significant) on a held-out test dataset.



## Conclusion

Our work "Decentralized Data Collection for Robotic Fleet Learning" introduces a novel, theoretically grounded, cooperative data sampling policy for networked robotic fleets, which converges to an Oracle policy upon termination. Additionally, it converges in a single iteration under mild practical assumption, which allows communication efficiency on real-world datasets. Our approach is a first step towards an increasingly timely problem as today's AV fleets measure terabytes of heterogeneous data in diverse operating contexts. 

