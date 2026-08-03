# LMSR Prediction Market Math: Explained Like You're 5! 🎈 (`formula.md`)

---

## 1. Welcome to LMSR Math Made Super Simple!

Imagine you are running a toy store that sells prediction tickets for a game: **Will it Rain Tomorrow? YES or NO?**

To run this store fairly without running out of money, we use a special mathematical system called **LMSR** (**L**ogarithmic **M**arket **S**coring **R**ule). 

This document explains **every single formula** step-by-step using simple stories, real numbers, and fun analogies!

---

## 2. Meet the Magic Building Blocks 🧮

Before we look at the formulas, let's meet the main characters:

| Character | Real Name | What it does in simple words |
| :--- | :--- | :--- |
| **$e$** | **Euler's Constant** | A magic fixed number ($\approx \mathbf{2.71828}$) that makes growth math smooth and saves gas fees on Ethereum. |
| **$\exp(x)$** | **Exponential Function** | The **"Growth Multiplier"** ($2.71828^x$). It blows numbers up into smooth positive numbers. |
| **$\ln(x)$** | **Natural Logarithm** | The **"Shrinking Machine"**. It asks *"What power brought us here?"* and shrinks big exponential numbers back into normal token amounts. |
| **$b$** | **Liquidity Depth** | The **"Pool Cushion Size"**. A bigger $b$ means deeper liquidity, so prices move smoothly without big jumps. |
| **$q_{\text{yes}}$ & $q_{\text{no}}$** | **Outcome Liabilities** | The **"Token Piggy Banks"**. The total number of YES and NO tickets sold so far. |

---

## 3. Formula 1: The Pool Vault Cost $C(q)$ 🏦

### 💡 What is it?
Think of **$C(q)$** as the **"Vault Safety Guard"**. It calculates **how much total collateral (FKToken) the pool must hold in its vault** to safely back all YES and NO tickets sold.

### 📐 The Formula
$$C(q_{\text{yes}}, q_{\text{no}}) = b \times \ln\left( \exp\left(\frac{q_{\text{yes}}}{b}\right) + \exp\left(\frac{q_{\text{no}}}{b}\right) \right)$$

---

### 🔢 Step-by-Step Example (Brand New Market)
Let's launch a pool with:
* Cushion size **$b = 100$ FKToken**
* No trades yet: **$q_{\text{yes}} = 0$** and **$q_{\text{no}} = 0$**

1. **Divide quantities by $b$:**  
   $0 / 100 = 0$
2. **Apply the Growth Multiplier $\exp(0)$:**  
   $2.71828^0 = 1$
3. **Add YES and NO together:**  
   $1 + 1 = 2$
4. **Pass through the Shrinking Machine $\ln(2)$:**  
   $\ln(2) = 0.693147$
5. **Multiply by Cushion Size $b$ ($100$):**  
   $$100 \times 0.693147 = \mathbf{69.31 \text{ FKToken}}$$

> 🎯 **Result:** When no trades have happened, the pool vault needs **69.31 FKToken** to launch!

---

## 4. Formula 2: The Trade Cost $\Delta C$ (How Much Do I Pay?) 💳

### 💡 What is it?
When a trader buys tickets, the vault requirement increases from $C_{\text{old}}$ to $C_{\text{new}}$.  
**The Trade Cost ($\Delta C$)** is simply the **difference between the new vault requirement and the old vault requirement**!

### 📐 The Formula
$$\Delta C = C(q_{\text{new}}) - C(q_{\text{old}})$$

---

### 🔢 Step-by-Step Example (Alice buys 50 YES tickets)
* Starting pool: $b = 100$, $q_{\text{yes}} = 0$, $q_{\text{no}} = 0$  
  Vault Requirement before trade ($C_{\text{old}}$) = **69.31 FKToken**

* Alice buys 50 YES tickets ($q_{\text{yes, new}} = 50$, $q_{\text{no, new}} = 0$):
  1. $\frac{q_{\text{yes}}}{b} = \frac{50}{100} = 0.5$
  2. $\exp(0.5) = 2.71828^{0.5} \approx 1.6487$
  3. $\exp(0) = 1.0$
  4. Sum = $1.6487 + 1.0 = 2.6487$
  5. Shrink with $\ln(2.6487) \approx 0.9741$
  6. New Vault Requirement ($C_{\text{new}}$) = $100 \times 0.9741 = \mathbf{97.41 \text{ FKToken}}$

* Calculate trade cost ($\Delta C$):
  $$\Delta C = 97.41 - 69.31 = \mathbf{28.10 \text{ FKToken}}$$

> 🎯 **Result:** Alice pays **28.10 FKToken** to buy 50 YES tickets (average price = $\$0.562$ per ticket)!

---

## 5. Formula 3: The Spot Price $P(\text{YES})$ (The Price Tag) 🏷️

### 💡 What is it?
The **Spot Price** is like the **speedometer** of the market. It shows the **exact price tag for 1 extra ticket right now** (which also equals the market's current estimated chance of winning!).

### 📐 The Formula
$$P(\text{YES}) = \frac{\exp\left(\frac{q_{\text{yes}}}{b}\right)}{\exp\left(\frac{q_{\text{yes}}}{b}\right) + \exp\left(\frac{q_{\text{no}}}{b}\right)}$$

$$P(\text{NO}) = 1 - P(\text{YES})$$

---

### 🔢 Step-by-Step Example
1. **Before any trades ($q_{\text{yes}}=0, q_{\text{no}}=0$):**
   $$P(\text{YES}) = \frac{1}{1 + 1} = \frac{1}{2} = \mathbf{0.50 \text{ (50\% Chance)}}$$

2. **After Alice bought 50 YES tickets ($q_{\text{yes}}=50, q_{\text{no}}=0$):**
   * $\exp(50/100) = 1.6487$
   * $\exp(0/100) = 1.0$
   $$P(\text{YES}) = \frac{1.6487}{1.6487 + 1.0} = \frac{1.6487}{2.6487} = \mathbf{0.622 \text{ (62.2\% Chance)}}$$

> 🎯 **Result:** After buying YES tickets, the spot price of YES increased from **$0.50** to **$0.622**!

---

## 6. Formula 4: Maximum Bounded Loss Cap ($\text{Max Loss}$) 🛡️

### 💡 What is it?
LMSR is famous because the pool owner (or LP stakers) can **never lose an infinite amount of money**. The worst-case loss is strictly capped by a mathematical ceiling!

### 📐 The Formula
$$\text{Max Loss} = b \times \ln(2) \approx \mathbf{0.693147 \times b}$$

---

### 🔢 Step-by-Step Example
If a market has cushion size $b = 1000$ FKToken:
$$\text{Max Loss} = 1000 \times 0.693147 = \mathbf{693.15 \text{ FKToken}}$$

> 🎯 **Result:** No matter how heavily traders buy winning tokens, the pool can **never lose more than 693.15 FKToken**!

---

## 7. Formula 5: Trading Fees & LP Rewards 💰

### 💡 What is it?
To reward Liquidity Providers (LPs) who deposit funds into the pool, a small fee (e.g., 2%) is charged on every trade.

### 📐 The Formulas

1. **Trade Fee Collected:**
   $$\text{Fee Amount} = \frac{|\Delta C| \times \text{feePercent}}{10^{18}}$$

2. **Accumulated LP Fee per Share ($accFeePerShare$):**
   $$\Delta accFeePerShare = \frac{\text{Fee Amount} \times \text{lpRewardRatio}}{\text{totalLPTokenSupply}}$$

3. **Staker Fee Reward Claim:**
   $$\text{Pending Reward} = \frac{\text{stakerLPBalance} \times (accFeePerShare - userFeePerSharePaid)}{10^{18}}$$

---

## 8. Master Summary Cheat Sheet 📋

| Formula Name | Math Formula | What it tells you in 1 sentence |
| :--- | :--- | :--- |
| **Vault Cost $C(q)$** | $b \cdot \ln( \sum \exp(q_i/b) )$ | Total money required in the pool's vault right now. |
| **Trade Cost $\Delta C$** | $C(q_{\text{new}}) - C(q_{\text{old}})$ | Exact amount of FKToken a trader pays to buy tickets. |
| **Spot Price $P(\text{YES})$** | $\frac{\exp(q_{\text{yes}}/b)}{\sum \exp(q_i/b)}$ | The price tag of 1 ticket right now (Implied probability). |
| **Max Bounded Loss** | $b \cdot \ln(2) \approx 0.693147 \cdot b$ | The maximum possible money the pool can lose in worst-case. |
| **LP Fee Share** | $\frac{\text{Fee} \cdot \text{lpRewardRatio}}{\text{totalLPSupply}}$ | Extra fee earnings distributed to LP stakers. |
