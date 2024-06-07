---
title: 'Benchmarking Networked Robotics'
description:
categories: blog
---

*By Aditya*

# Profiling End-to-End Real-Time Networked Robotics

## Motivation

Wireless networks are an essential component of modern robotics, enabling computation offloading, distributed machine learning, and robotic teleoperation. When it comes to deploying such networked robotic systems in the real world, engineers are faced with a number of system-specific design choices, such as selecting Machine Learning (ML) models, network types, and edge hardware. To answer these questions in quantifiable ways, detailed profiling of all components of a networked robotic system is necessary. To meet this challenge, we propose PEERNet, the Profiler for End-to-end Real-time Networked robotic systems. PEERNet is easy to use and adaptable to a wide array of custom use cases, representing a significant step towards comprehensive benchmarking of networked robotics.

## Our Solution

PEERNet’s approach to benchmarking networked robotic systems invovles phrasing arbitrary systems as a combination of sensors, networks, and devices. PEERNet frames each component’s role as an input-output system, allowing for fast and modular implementation of robotic systems. In PEERNet, we implement a custom data logging scheme which allows data loggers to be coupled with data streams, enabling benchmarking across the entire flow of data. PEERNet pays special attention to benchmarking wireless networks, and implements a one-way network delay estimation algorithm, a crucial feature in modern robotic systems which exhibit asymmetric data transfer across networks. For the case of benchmarking offloaded inference, PEERNet exposes a Command Line Interface (CLI), enabling benchmarking of user-defined offloading systems in a single terminal command.

<figure>
    <img src="{{site.baseurl}}/images/post/peernet.png" alt="System Pipeline">
   <figcaption>PEERNet's benchmarking pipeline</figcaption>
   <p></p>
</figure>

## Experiments

We experimentally validate PEERNet by constructing and profiling three representative networked robotic systems. First, an offloaded inference example demonstrates how PEERNet can be used to intelligently select local and cloud ML models to balance accuracy and latency. Next, profiling Vision-Language Model (VLM) usage at the edge demonstrates that with detailed profiling, we identify and analyze non-intuitive behavior of ML models.

Finally, we demonstrate profiling of robotic teleoperation across wireless networks in a pick-and-place task on a Franka Emika robotic arm. We demonstrate how PEERNet quantifies and explains tradeoffs between network latency, sensing, ML inference, and compression.

In conclusion, our work both provides a capable solution to the problem of benchmarking networked robotics and puts forward a framework for continued exploration of the topic. We demonstrate PEERNet's usage across three robotic scenarios, showing that PEERNet is an effective solution to robotics profiling from offloaded inference to robotic teleoperation.