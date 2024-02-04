---
title: 'Fleet Active Learning: A Submodular Maximization Approach'
description: CoRL 2023 paper
categories: blog
---

*By Oguzhan Akcin*

# Innovating Fleet Learning with Submodular Maximization

[Link to paper](https://openreview.net/forum?id=low-53sFqn)

The recent surge in the success and popularity of machine learning (ML) models provides unique opportunities for developing ML models. Today, we can collect more data from previously unseen diverse environments, which can be used to increase the robustness and overall performance of these ML models. This is especially true in the context of autonomous vehicles (AVs), where the collection and processing of diverse and informative data are pivotal for enhancing ML models. These models, integral to the vehicles' perception, prediction, and planning capabilities, thrive on varied datasets that enable them to generalize across different environments. However, the current methods for data collection are not efficient enough to utilize the full potential of the data collection. Addressing this gap, our novel "Fleet Active Learning" framework emerges as a solution to three pivotal challenges:

1. How do we efficiently gather diverse and informative data in a fleet of AVs?
2. How can we scale data collection methods to accommodate large fleets without overwhelming bandwidth and storage capacities?
3. How do we optimize the data collection process to enhance the performance of ML models?

<figure>
    <img src="{{site.baseurl}}/images/post/fal_framework.jpg" alt="Fleet Active Learning Framework">
   <figcaption>Fleet Active Learning Framework: A collaborative approach to data gathering.</figcaption>
   <p></p>
</figure>

## The Challenge of Redundancy in Data Collection**

When AVs operate independently to collect data, there's a significant risk of redundancy. Multiple vehicles may gather similar data points, which does not add value to the training models. This redundancy not only wastes resources but also fails to enrich the models' learning with new, diverse information. Given constraints like bandwidth and computational resources, it's crucial for these vehicles to prioritize the collection of unique and informative data points that can substantially improve their deep neural networks (DNNs).

<figure>
    <img src="{{site.baseurl}}/images/post/fal_toy_example.png" alt="Toy Example" width="50%" height="auto">
   <figcaption>Illustrative example of distributed (red) vs. interactive (blue) data selection in 2D space, showcasing the reduction in redundancy and broader data coverage. </figcaption>
   <p></p>
</figure>

# A Collaborative Solution through Submodular Maximization

Our work addresses these challenges by introducing a fleet active learning framework that leverages submodular maximization. This mathematical approach is adept at handling situations where the value of adding data points diminishes over time—a concept known as diminishing returns. In essence, the method prioritizes data points that offer the most significant incremental value, ensuring that the collected dataset is not just large but also highly informative.

## How Fleet Active Learning Works

The FAL framework operates on a simple yet effective principle: rather than working in isolation, robots (or AVs) coordinate to select the most valuable samples for data collection. This coordination minimizes communication overhead and emphasizes data privacy, as each vehicle shares only selected information. The process iteratively updates the actions of the AVs, with each vehicle's decision influenced by the selections of its predecessors. This ensures a collectively optimized set of diverse data points that cover a wide range of scenarios.

## Empirical Evidence of Success

With rigorous theoretical analysis and empirical results, we show that our proposed framework is superior to both fully distributed and centralized approaches. Experiments conducted on real-world datasets, including the Berkeley DeepDrive, showcase remarkable improvements. The framework achieved up to a 25.0% increase in classification accuracy, a 9.2% rise in mean average precision, and a whopping 48.5% boost in the submodular objective value compared to a completely distributed baseline. These numbers not only validate the effectiveness of the FAL approach but also highlight its potential to revolutionize data collection in multi-robot systems. 

<figure>
    <img src="{{site.baseurl}}/images/post/fal_results.jpg" alt="Fleet Active Learning Results">
   <figcaption>Quantitative results demonstrating the impact of Fleet Active Learning. Here, our proposed approach, <strong>Interactive</strong>, outperforms the traditional <strong>Distributed</strong> baseline and matches the performance of the upper bound <strong>Centralized</strong> approach.
    </figcaption>
   <p></p>
</figure>

# Conclusion: Revolutionizing Data Collection**

Our work "Fleet Active Learning: A Submodular Maximization Approach" offers a promising avenue for enhancing the capabilities of AVs through smarter data collection methods. By adopting the FAL framework, fleets of autonomous vehicles can efficiently gather diverse data essential for training robust ML models. This approach not only optimizes resource use but also paves the way for the development of more advanced, reliable, and safe autonomous driving technologies. As we stand on the cusp of fully autonomous transportation, innovations like FAL are instrumental in overcoming the hurdles of data collection and model training, marking a significant leap forward in the journey towards more intelligent, more autonomous vehicles.