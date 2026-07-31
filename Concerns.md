# Recrd LMSR Prediction Market: Active Technical Concerns & Risk Analysis (`Concerns.md`)

---

## 1. Executive Summary

This document maintains the active, unresolved technical and economic concerns of the **Recrd LMSR Prediction Market Protocol**. 

It focuses specifically on the inherent trade-offs, financial risks, and pricing behavior associated with integrating **User-Provided Liquidity (LPs)** into an **LMSR Automated Market Maker (`LMSRMarketMaker.sol`)**.

---

## 2. Active & Unresolved System Concerns

### ⚠️ Concern 1: LMSR Bounded Loss vs. LP Principal Risk (Who Pays for the Loss?)

- **Context & Mechanics:**
  Under the LMSR mathematical formulation, the AMM operates with a capped theoretical maximum loss:
  $$\text{Max Loss} = b \cdot \ln(2) \approx 0.693147 \cdot b$$
  This loss occurs when traders overwhelmingly buy the winning outcome (e.g., YES) and the market resolves to YES. The AMM pays out 1.0 `FKToken` per winning share, which can exceed the net trade costs collected.
  In our delegated flow, retail LPs stake `FKToken` collateral directly into the pool. If a market suffers its maximum directional loss and trading volume/fees are low, the pool's total collateral balance will decline below total LP deposits.

- **Impact on System:**
  LPs could experience **principal loss** upon withdrawing their staked collateral if accumulated trading fees do not cover the directional LMSR loss.

- **Status / Ongoing Consideration:**
  LPs accept directional market risk in exchange for earned trading fees (collected on both buy and sell trades). A higher fee percentage or platform volume is required to ensure LP profitability across volatile markets.

---

### ⚠️ Concern 2: Mid-Market Liquidity Additions & Spot Price Shift Dynamics

- **Context & Mechanics:**
  The LMSR marginal price formula for outcome $i$ is:
  $$P(i) = \frac{\exp(q_i / b)}{\sum_{j=1}^N \exp(q_j / b)}$$
  When a user deposits new liquidity mid-market during active trading, $b$ expands directly ($b_{\text{new}} = b_{\text{old}} + \Delta b$). 
  Because net outcome liabilities $q_{\text{yes}}$ and $q_{\text{no}}$ are currently **not rescaled**, expanding $b$ mid-market naturally alters the spot price ratio $q_i / b$.

- **Impact on System:**
  Depositing liquidity mid-market causes an **instant spot price shift** (flattening the price curve toward 0.50) without any trading volume taking place.

- **Status / Ongoing Consideration:**
  This natural price shift behavior is retained for the current implementation. If price-invariance rescaling ($q_{\text{new}} = q_{\text{old}} \cdot \frac{b_{\text{new}}}{b_{\text{old}}}$) is required in the future to prevent price jumps on deposit, it can be introduced in a protocol upgrade.

---

### ⚠️ Concern 3: Capital Fragmentation Across Isolated Video Pools

- **Context & Mechanics:**
  Because each video market is deployed as an isolated `LMSRMarketMaker` EIP-1167 proxy clone, LP funds deposited into Video Market A cannot back or earn fees from Video Market B.

- **Impact on System:**
  If a specific video receives low trading volume, LP capital staked in that market sits idle and earns zero fee yield, leading to sub-optimal capital efficiency across niche markets.

- **Status / Ongoing Consideration:**
  Per-market isolation isolates financial risk per video, but requires LPs to choose active markets. A global automated liquidity vault router (`LiquidityVault.sol`) may be introduced in a future phase to dynamically route capital across trending video markets.

---

## 3. Summary Matrix of Active System Concerns

| Concern # | Risk / Edge Case | System Impact | Current Handling / Status |
| :--- | :--- | :--- | :--- |
| **1** | **LMSR Bounded Loss vs. LP Principal** | LPs absorb directional pool loss if fees < max loss | Unresolved / Active: LPs earn buy & sell fees, but bear principal market risk. |
| **2** | **Mid-Market $b$ Scaling Price Shift** | Mid-market deposits shift spot price $P(\text{YES})$ | Unresolved / Active: $b$ expands directly; price shifts naturally without rescaling for now. |
| **3** | **Capital Fragmentation Across Pools** | Idle LP capital on low-volume video markets | Unresolved / Active: Per-market isolation retained; global router planned for future phase. |
