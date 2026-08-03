# LMSR Prediction Market Math: Made Super Simple & Clear! 🎈 (`formula.md`)

---

## 1. Introduction: What is LMSR?

Imagine you are running a toy store that sells prediction tickets for a game: **Will it Rain Tomorrow? YES or NO?**

To run this store fairly without running out of money, we use a special math rule called **LMSR** (**L**ogarithmic **M**arket **S**coring **R**ule). 

This guide breaks down **every single formula** into simple stories, real numbers, and step-by-step calculations.

---

## 2. Meet the Core Math Characters 🧮

Before we look at the formulas, let's understand the building blocks:

| Character | What it is | What it does in simple words |
| :--- | :--- | :--- |
| **$e$** | Constant Number | A special fixed math number equal to **$2.71828$** (like $\pi \approx 3.14159$). |
| **$\exp(x)$** or **$e^x$** | Growth Multiplier | Raises $e$ to the power of $x$ (e.g. $2.71828^x$). It blows numbers up smoothly. |
| **$\ln(x)$** | Shrinking Machine | The natural logarithm. It asks: *"How many $e$'s did we multiply together to get $x$?"* It shrinks big numbers back to normal. |
| **$b$** | Pool Cushion | How deep the pool's liquidity is (e.g. $1000$ FKToken). Bigger cushion = smaller price shifts. |
| **$q_{\text{yes}}$ & $q_{\text{no}}$** | Quantity Sold | Piggy banks holding the count of YES and NO tickets sold so far. |

---

## 3. Formula 1: The Vault Cost $C(q)$ 🏦

### 💡 What is it?
The **Cost Function $C(q)$** calculates **how much total money (collateral) the pool must hold in its vault** to safely cover all tickets sold.

### 📐 The Formula
$$C(q_{\text{yes}}, q_{\text{no}}) = b \times \ln\left( e^{\left(\frac{q_{\text{yes}}}{b}\right)} + e^{\left(\frac{q_{\text{no}}}{b}\right)} \right)$$

### 🔢 Step-by-Step Example (Brand New Market)
Let's launch a pool with cushion size **$b = 1000$** and no tickets sold yet (**$q_{\text{yes}} = 0, q_{\text{no}} = 0$**):

1. **YES exponent part:** $e^{(0/1000)} = e^0 = 1$
2. **NO exponent part:** $e^{(0/1000)} = e^0 = 1$
3. **Add them together:** $1 + 1 = \mathbf{2}$
4. **Pass through the Shrinking Machine $\ln(2)$:** $\ln(2) \approx 0.693147$
5. **Multiply by Cushion $b$:** $1000 \times 0.693147 = \mathbf{693.15 \text{ FKToken}}$

> 🎯 **Starting Vault Cost:** **693.15 FKToken**

---

## 4. Formula 2: The Trade Cost $\Delta C$ (How Much Do I Pay?) 💳

### 💡 What is it?
When you buy tickets, the pool's vault requirement goes up.  
The **Trade Cost ($\Delta C$)** is simply: **(New Vault Requirement) - (Old Vault Requirement)**.

### 📐 The Formula
$$\Delta C = C(q_{\text{new}}) - C(q_{\text{old}})$$

### 🔢 Step-by-Step Example (Bob buys 100 YES tickets)
We start with $q_{\text{yes}}=0, q_{\text{no}}=0$ (Old Vault Cost = **693.15 FKToken**).  
Bob buys 100 YES tickets ($q_{\text{yes, new}} = 100, q_{\text{no, new}} = 0$):

1. **Calculate New Exponents:**  
   * YES: $e^{(100/1000)} = e^{0.1} \approx 1.10517$
   * NO: $e^{(0/1000)} = e^0 = 1.0$
2. **Add them together:** $1.10517 + 1.0 = \mathbf{2.10517}$
3. **Pass through Shrinking Machine:** $\ln(2.10517) \approx 0.744397$
4. **Multiply by Cushion $b=1000$:** $1000 \times 0.744397 = \mathbf{744.40 \text{ FKToken}}$ (New Vault Cost)
5. **Calculate Trade Cost:**  
   $$\text{Trade Cost} = 744.40 - 693.15 = \mathbf{51.25 \text{ FKToken}}$$

> 🎯 **Result:** Bob pays **51.25 FKToken** to buy 100 YES tickets.

---

## 5. Formula 3: The Spot Price $P(\text{YES})$ (The Price Tag) 🏷️

### 💡 What is it?
The **Spot Price** shows the **price tag of 1 extra ticket right now** (which is also the market's estimated chance of that outcome winning).

### 📐 The Formula
$$P(\text{YES}) = \frac{e^{\left(\frac{q_{\text{yes}}}{b}\right)}}{e^{\left(\frac{q_{\text{yes}}}{b}\right)} + e^{\left(\frac{q_{\text{no}}}{b}\right)}}$$

$$P(\text{NO}) = 1 - P(\text{YES})$$

### 🔢 Step-by-Step Example (After Bob's trade)
After Bob bought 100 YES tickets ($q_{\text{yes}}=100, q_{\text{no}}=0$, $b=1000$):

1. **YES exponent:** $e^{(100/1000)} = e^{0.1} \approx 1.10517$
2. **NO exponent:** $e^{(0/1000)} = e^0 = 1.0$
3. **Calculate Price:**  
   $$P(\text{YES}) = \frac{1.10517}{1.10517 + 1.0} = \frac{1.10517}{2.10517} \approx \mathbf{0.525 \text{ (52.5\% Chance)}}$$
   $$P(\text{NO}) = 1 - 0.525 = \mathbf{0.475 \text{ (47.5\% Chance)}}$$

> 🎯 **Result:** The price of YES moved from **$0.50** to **$0.525** because Bob bought tickets.

---

## 6. Formula 4: Maximum Bounded Loss Cap 🛡️

### 💡 What is it?
The maximum amount of money the pool can ever lose is mathematically capped. The pool owner (or stakers) can never lose more than this ceiling:

$$\text{Max Loss} = b \times \ln(2) \approx \mathbf{0.693147 \times b}$$

### 🔢 Step-by-Step Example
If the pool cushion $b = 1000$ FKToken:
$$\text{Max Loss} = 1000 \times 0.693147 = \mathbf{693.15 \text{ FKToken}}$$

> 🎯 **Result:** The pool's worst-case loss is capped at **693.15 FKToken**, no matter how much traders win.

---

## 7. Formula 5: Trading Fees & LP Rewards 💰

### 💡 What is it?
To reward stakers (Liquidity Providers) who help fund the pool, a small fee is charged on every trade and shared proportionally among LP token holders.

### 📐 The Step-by-Step Logic
1. **Trade Fee:**  
   $$\text{Fee Amount} = \frac{\text{Trade Cost} \times \text{feePercent}}{100}$$
2. **Accumulating Rewards:**  
   Fees are added to a global accumulator pool (`accFeePerShare`) whenever trades happen.
3. **LP Claim:**  
   LPs harvest their fee rewards based on their percentage share of the total LP pool tokens:
   $$\text{Your Reward} = \text{Your LP Tokens} \times (\text{New Fees Accumulated})$$
