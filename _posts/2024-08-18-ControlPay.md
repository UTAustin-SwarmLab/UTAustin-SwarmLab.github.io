---
title: 'ControlPay: An Adaptive Payment Controller for Blockchain Economies'
description: ICB 2024 paper
categories: blog
---

*By Oguzhan A.*

# ControlPay: An Adaptive Payment Controller for Blockchain Economies

Proceedings of the International Conference on Blockchain (ICB) 2024

## Introduction

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/controlpay_intro.png" alt="" width="30%" height="auto" style="margin: auto; display: block;">
   <figcaption></figcaption>
   <p></p>
</figure>

In recent years, decentralized platforms like Helium, BitTensor, and FileCoin have reshaped how services such as wireless networks, machine learning, and storage are provided. These platforms operate on a token-based economy, rewarding service providers with cryptocurrency tokens. However, managing these economies is a complex challenge, particularly when token supply strategies fail to account for market fluctuations. The collapse of Luna, for example, highlighted the devastating effects of inadequate token price stabilization, resulting in massive financial losses for users and raising concerns about the sustainability of blockchain economies. Our new paper, *ControlPay: An Adaptive Payment Controller for Blockchain Economies*, offers a solution by introducing a control-theoretic approach to stabilizing blockchain token economies.

## The Problem

Decentralized platforms rely on native tokens to incentivize service providers. These tokens are essential for maintaining and expanding network infrastructure, but current approaches to managing token supply—like the "burn-and-mint" model—are often rigid and vulnerable to market volatility. For instance, maintaining a fixed exchange rate between tokens and USD can lead to the depletion of reserves, destabilizing the entire network. While some platforms have implemented adaptive mechanisms, these are often reactive heuristics lacking the predictive capabilities needed to maintain stability in the long term.

Additionally, the presence of strategic behavior by market participants further complicates the management of token economies. Token holders may act strategically to maximize their profits, leading to price fluctuations and network instability. Traditional control mechanisms are ill-equipped to handle these challenges, resulting in suboptimal token supply strategies and increased network costs.

## Our Approach: ControlPay

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/controlpay_model.png" alt="ControlPay" height="auto" style="margin: auto; display: block;">
   <figcaption>ControlPay: Our Payment Controller for Blockchain Economies</figcaption>
   <p></p>
</figure>

To address these challenges, we introduce *ControlPay*, an adaptive payment controller for blockchain economies. ControlPay leverages advanced control theory and game-theoretic models to optimize token supply and stabilize token prices. Unlike traditional approaches, ControlPay is predictive, using forecasts of consumer demand and supplier growth to dynamically adjust token supply. By modeling the token economy as a dynamic system and incorporating strategic behavior, ControlPay provides a comprehensive solution for managing decentralized token economies. 

Specifically, ControlPay combines the following key features:

- **Modeling the Token Economy as a Dynamic System:** We develop a dynamic model of the token economy, integrating key variables such as token supply, price, reserves, income, and demand.
- **A Model Predictive Control Approach:** We design a control mechanism based on model predictive control (MPC) to manage token supply and price, optimizing control actions to stabilize the token economy.
- **Strategic Behavior and Game Theory:** We model the market as a Stackelberg game between token holders and the payment controller, anticipating strategic behavior and optimizing token supply to maximize overall welfare within the network.

In the following sections, we detail our approach to modeling the token economy, designing ControlPay, and incorporating strategic behavior through game theory.

### Modeling the Token Economy as a Dynamic System

We begin by modeling the token economy as a dynamic system, integrating various factors such as token supply, price, reserves, income, and demand. Specifically, we consider the following components:

**State Variables:**
- *Circulating Supply \\(S_t\\)*: The total number of tokens in circulation.
- *Reserves \\(R_t^{USD}\\), \\(R_t^{Tok}\\)*: The reserves in USD and tokens.
- *Price \\(p_t^{Tok}\\)*: The price of the token.

**Control Variables:**
- *Token Payments \\(u^P_t\\)*: The amount of tokens paid to service providers.
- *Token Buybacks \\(u^B_t\\)*: The amount of tokens bought back from the market to stabilize the price.
- *Incentive Price \\(\Delta p_t\\)*: The price difference between the token's market price and the buyback price.

**External Factors:**
- *Income \\(Inc_t\\)*: The income generated by the platform.
- *Demand \\(D_t\\)*: The demand for tokens.


Using these variables, we define the dynamics of the token economies as a set of equations that describe how the state variables evolve over time. More specifically, we model the change in circulating supply, reserves, and price as:

$$ S_{t+1} = S_t + u^P_t - \frac{u^B_t}{p_t^{Tok} +\Delta p_t}, $$

$$ R_{t+1}^{USD} = R_t^{USD} - u^B_t + Inc_t, $$

$$ R_{t+1}^{Tok} = R_t^{Tok} - u^P_t + \frac{u^B_t}{p_t^{Tok} +\Delta p_t}, $$

$$ p_{t+1}^{Tok} = \frac{D_{t+1}}{S_{t+1}}.$$

Here, circulating supply is updated based on token payments and buybacks, reserves are updated based on income and buybacks from the market, and the price is updated based on the demand and circulating supply of tokens. With these equations, we define the state \\(x_t\\), control \\(u_t\\), and forecasted external factors \\(s_t\\) as follows:

$$ x_t = [S_t, R_t^{USD}, R_t^{Tok}, p_t^{Tok}], $$

$$ u_t = [u^B_t, u^P_t, \Delta p_t], $$

$$ s_t = [\hat{D_t}, \hat{Inc_t}]. $$

Finally, we can express the dynamics of the token economy \\(f\\) as a function of the state, control, and external factors:

$$ x_{t+1} = f(x_t, u_t, s_t) = \begin{bmatrix} x_t(0) + u_t(1) - \frac{u_t(0)}{x_t(3)+u_t(2)} \\ x_{t}(1) - u_{t}(0) + s_{t}(1) \\ x_{t}(2) + \frac{u_t(0)}{x_t(3)+u_t(2)} - u_{t}(1) \\ \frac{s_{t+1}(0)}{x_{t+1}(0)}  \end{bmatrix}.$$

### ControlPay: A Model Predictive Control Approach

With the token economy modeled as a dynamic system, we can now design a control mechanism to manage token supply and price. Our approach, *ControlPay*, is based on model predictive control (MPC), a control strategy that uses a model of the system to predict future behavior and optimize control actions. In the context of token economies, ControlPay uses forecasts of consumer demand and supplier growth to optimize token supply dynamically, providing a robust solution that can significantly reduce network costs while maintaining price stability. To achieve this we define the following optimization problem:

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/controlpay_opt.png" alt="" width="30%" height="auto" style="margin: auto; display: block;">
   <figcaption></figcaption>
   <p></p>
</figure>

where \\(J\\) is the cost function, \\(x_{t+1} = f(x_t, u_t, s_t)\\) represents the dynamics of the token economy, and \\(\mathcal{X}\\) and \\(\mathcal{U}\\) are the state and control constraints, respectively. By solving this optimization problem, ControlPay can adaptively adjust token payments and buybacks to stabilize the token price and ensure the sustainability of the network.

An example cost function \\(J\\) could be:

$$ J(x_0, u_{0:H-1}) = \sum_{t=0}^{H-1} \begin{bmatrix} \beta_1 \\ \beta_2 \\ \beta_3 \end{bmatrix}^\top \begin{bmatrix} \left( x_{t+1}(3) - \bar{x}_{t+1}(3) \right)^2 \\ \left( u_t(0) - \bar{u}_t(0) \right)^2 \\ \left( u_{t}(1) - \bar{u}_t(1) \right)^2 \end{bmatrix},$$

where \\(\beta_1, \beta_2, \beta_3\\) are weighting factors. This cost function penalizes deviations of the token price from the USD price, control actions, and changes in control actions, ensuring that the token price remains stable and control actions are smooth.

Unlike traditional approaches like PID controllers, which are reactive, ControlPay is predictive. It uses forecasts of consumer demand and supplier growth to dynamically optimize token supply, providing a robust solution that can significantly reduce network costs while maintaining price stability.

### Strategic Behavior and Game Theory

A unique aspect of our approach is the incorporation of strategic behavior by market participants. We model the market as a Stackelberg game between token holders and the payment controller. Token holders, seeking to maximize the value of their tokens, may act strategically, affecting the stability of the token economy. ControlPay anticipates these actions and adjusts its strategy accordingly, ensuring that both token holders and the network benefit.

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/controlpay_stackelberg.png" alt="Token Economy Model with Rational Market" height="auto" width="80%" style="margin: auto; display: block;">
   <figcaption></figcaption>
   <p></p>
</figure>

In this game, the payment controller acts as the leader, setting incentive price and buybacks to stabilize the token price. Token holders, acting as followers, adjust their behavior based on the controller's actions. By modeling the token economy as a Stackelberg game, ControlPay can anticipate strategic behavior and optimize token supply to maximize overall welfare within the network. We also show that ControlPay achieves the Stackelberg equilibrium, where the payment controller maximizes the utility of token holders while minimizing control costs.

## Experiments and Results

We validated ControlPay through extensive simulations using both synthetic and real-world data from the Helium network. We compared ControlPay with traditional methods like the "burn-and-mint" (No Control) model, which simply buys back and pays out the same amount of tokens, and the proportional integral derivative (PID) controller, which adjusts token payments and buybacks based on past data on token price and reserves. Here are some example simulation results for comparison:

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/controlpay_exp.png" alt="Some Simulation Results" height="auto" style="margin: auto; display: block;">
   <figcaption>Some example simulation results for comparison.</figcaption>
   <p></p>
</figure>

The two left columns show trajectories using real Helium data, demonstrating that *ControlPay* (green) closely follows the reference (purple), while the reactive PID (blue) is highly oscillatory. The right columns validate our approach's adaptability using synthetic data, showing how *ControlPay* adjusts to a decreasing price trajectory. Unlike PID, *ControlPay* avoids overshooting, maintaining price stability even as demand shifts.

Below are the network cost and control effort comparisons for the three methods:

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/controlpay_exp_boxplot.png" alt="Network Cost and Control Effort as a box-plot" width="50%" height="auto" style="margin: auto; display: block;">
   <figcaption>Network cost and control effort comparison.</figcaption>
   <p></p>
</figure>

*ControlPay* outperforms traditional methods by reducing network costs by up to 2.4× while using similar control effort. This demonstrates the effectiveness of our approach in stabilizing token prices and reducing network costs.

Additionally, we conducted experiments to evaluate ControlPay’s performance in environments with strategic behavior. Our results show that ControlPay effectively balances the interests of token holders and the payment controller, maximizing overall welfare within the token economy. The figure below illustrates how ControlPay finds a game strategy to sell only \\(\alpha^*_t\\) tokens to maximize node utility and minimize control cost, compared to simply holding (\\(\alpha_t = 0\\)) or selling all tokens (\\(\alpha_t = 1\\)).

<figure style="text-align: center;">
    <img src="{{site.baseurl}}/images/post/controlpay_exp_game.png" alt="Stackelberg Game Plot" height="auto" width="50%" style="margin: auto; display: block;">
   <figcaption>Network cost and utility of token owners.</figcaption>
   <p></p>
</figure>

## Conclusion

As blockchain infrastructures continue to grow, the need for adaptive control mechanisms like ControlPay will become increasingly critical. By integrating advanced control theory and game-theoretic models, ControlPay provides a comprehensive solution for managing decentralized token economies. We are excited to present our findings at the International Conference on Blockchain (ICB) 2024 and look forward to further discussions on how ControlPay can help shape the future of blockchain economies.