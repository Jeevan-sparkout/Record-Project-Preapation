# Recrd LMSR Prediction Market: Buy & Sell Pricing Scenarios (`scenario.md`)

---

## 1. Scenario Setup

This document answers five questions with worked examples:

**Buy side:**
1. **When a user buys YES tokens, how much do they pay?**
2. **After that buy, what price will the next user see?**

**Sell side:**
3. **When a user sells YES tokens back to the pool, how much do they receive?**
4. **After that sell, what does the price drop to?**

**Liquidity side:**
5. **What happens to the price if liquidity is added or removed mid-market?** (see PART 3)

### The Assumptions

| Parameter | Value |
| :--- | :--- |
| Market | Binary (YES / NO) |
| Collateral | `FKToken` |
| Trading fee | **0%** (pure LMSR cost) |
| Initial marginal price | **0.50 FKToken per token** (both YES and NO) |
| Starting liabilities | $q_{\text{yes}} = 0$, $q_{\text{no}} = 0$ |
| Liquidity parameter $b$ | **1000**, **10,000**, **100,000** (3 cases) |
| Trade quantity (YES tokens) | **10**, **100**, **1,000** (3 cases per $b$) |

All 9 combinations are worked out for each side below.

---

## 2. The LMSR Formulas Used

### 2.1 Cost Function

$$C(q) = b \cdot \ln \Big( \exp(q_{\text{yes}} / b) + \exp(q_{\text{no}} / b) \Big)$$

The **net cost of a trade** is the *difference* between the cost function after and before the trade:

$$\text{Cost} = C(q_{\text{new}}) - C(q_{\text{old}})$$

### 2.2 Marginal Price (what the next user sees)

$$P(\text{YES}) = \frac{\exp(q_{\text{yes}} / b)}{\exp(q_{\text{yes}} / b) + \exp(q_{\text{no}} / b)}, \qquad P(\text{NO}) = 1 - P(\text{YES})$$

### 2.3 Initial State (before any trade)

With $q_{\text{yes}} = q_{\text{no}} = 0$:

$$P(\text{YES}) = \frac{e^0}{e^0 + e^0} = \frac{1}{2} = \mathbf{0.50}$$

So both outcomes always start at exactly **0.50** regardless of $b$ — the starting price is independent of liquidity. $b$ only controls *how fast* the price moves per token traded (slippage).

### 2.4 Buying $X$ YES (from the neutral start)

$$q_{\text{yes}}: 0 \to X \quad \Rightarrow \quad \text{Cost} = b \cdot \ln\!\Big(\exp(X/b) + 1\Big) - b \cdot \ln(2)$$

### 2.5 Selling $Y$ YES back

$$q_{\text{yes}}: q \to q - Y \quad \Rightarrow \quad \text{Payout} = b \cdot \ln\!\Big(\exp(q/b) + 1\Big) - b \cdot \ln\!\Big(\exp((q-Y)/b) + 1\Big)$$

### 2.6 Key Property: Path Independence

At 0% fee, LMSR is **path-independent** — the buy cost from $q=0$ to $q=X$ is *exactly* equal to the sell payout from $q=X$ back to $q=0$:

$$\text{Buy cost}(X) = \text{Sell payout}(X)$$

A full round-trip therefore nets **exactly zero** and returns the price to **0.50**. (This is why the pool only makes money from the trading fee, and why the bounded-loss math holds.)

---

## 3. PART 1 — BUY SIDE

### 3.1 Worked Example: $b = 1000$, Buying 100 YES

**Step 1 — Cost before the trade:**
$$C_0 = 1000 \cdot \ln(e^0 + e^0) = 1000 \cdot \ln(2) = 693.147181$$

**Step 2 — Cost after the trade** (the pool has now sold 100 YES, so $q_{\text{yes}} = 100$):
$$C_1 = 1000 \cdot \ln(e^{100/1000} + e^0) = 1000 \cdot \ln(e^{0.1} + 1) = 1000 \cdot \ln(2.1051709) = 744.396660$$

**Step 3 — Net cost (what the buyer pays):**
$$\text{Cost} = C_1 - C_0 = 744.396660 - 693.147181 = \mathbf{51.249480 \text{ FKToken}}$$

**Step 4 — Price the next user sees:**
$$P(\text{YES}) = \frac{e^{0.1}}{e^{0.1} + 1} = \frac{1.1051709}{2.1051709} = \mathbf{0.524979}$$

> **Answer:** The buyer paid **51.2495 FKToken** for 100 YES (average **0.5125 per token**). The next user who wants to buy YES will now pay **0.52498 FKToken per token** (marginal price rose from 0.50 → 0.52498). The next user who wants to buy NO would pay **0.47502** per token, because $P(\text{YES}) + P(\text{NO}) = 1$ always.

### 3.2 Buy Matrix (All 9 Cases)

In every row, the market starts at $P = 0.50$ and the user buys $X$ YES tokens.

#### Case A — Shallow Liquidity: $b = 1000$

| Buy quantity $X$ | Cost paid (FKToken) | Avg cost / token | New $P(\text{YES})$ | New $P(\text{NO})$ | Price change* | Slippage** |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10** | 5.012500 | 0.501250 | 0.502500 | 0.497500 | +0.25pp | 0.50% |
| **100** | 51.249480 | 0.512495 | 0.524979 | 0.475021 | +2.50pp | 5.00% |
| **1,000** | 620.114507 | 0.620115 | 0.731059 | 0.268941 | +23.11pp | 46.21% |

*\*Price change\* is in **percentage points** (YES goes from 50% → 50.25%, i.e. **+0.25pp**); **\*Slippage\*** is the **relative move** vs. the 0.50 starting price (0.0025 ÷ 0.50 = 0.5%).*

**Reading:** In a $b=1000$ pool, a 1,000-token buy is enormous relative to liquidity — the price of YES jumps from 50¢ to 73.1¢ in one shot. The buyer's spend (620.11 FKToken) is the integral of marginal prices across the whole move; the pool's actual loss at YES resolution would be `1000 payout − 620.11 received ≈ 380` FKToken, still below the 693 FKToken max-loss bound.

#### Case B — Medium Liquidity: $b = 10{,}000$

| Buy quantity $X$ | Cost paid (FKToken) | Avg cost / token | New $P(\text{YES})$ | New $P(\text{NO})$ | Price change* | Slippage** |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10** | 5.001250 | 0.500125 | 0.500250 | 0.499750 | +0.025pp | 0.05% |
| **100** | 50.124999 | 0.501250 | 0.502500 | 0.497500 | +0.25pp | 0.50% |
| **1,000** | 512.494795 | 0.512495 | 0.524979 | 0.475021 | +2.50pp | 5.00% |

**Reading:** With 10× the liquidity, the *same* 1,000-token buy now costs 512.49 FKToken (vs. 620.11) and only moves YES from 0.50 → 0.525. This is the sweet spot for most Recrd video markets.

#### Case C — Deep Liquidity: $b = 100{,}000$

| Buy quantity $X$ | Cost paid (FKToken) | Avg cost / token | New $P(\text{YES})$ | New $P(\text{NO})$ | Price change* | Slippage** |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10** | 5.000125 | 0.500013 | 0.500025 | 0.499975 | +0.0025pp | 0.005% |
| **100** | 50.012500 | 0.500125 | 0.500250 | 0.499750 | +0.025pp | 0.05% |
| **1,000** | 501.249995 | 0.501250 | 0.502500 | 0.497500 | +0.25pp | 0.50% |

**Reading:** At $b=100{,}000$ even a 1,000-token order barely moves the market (+0.5% slippage). Cost ≈ the buy quantity itself (1,000 tokens ≈ 501.25 FKToken ≈ 0.50/token average). Great UX for whale orders — but max loss is $b \cdot \ln 2 \approx 69{,}314$ FKToken, so Recrd bears deep-liquidity risk.

### 3.3 Buy Cheat Sheet

| If $b$ = | And user buys | They pay | Next user pays for YES |
| :---: | :---: | :---: | :---: |
| 1000 | 10 | 5.01 | 0.5025 |
| 1000 | 100 | 51.25 | 0.5250 |
| 1000 | 1,000 | 620.11 | 0.7311 |
| 10,000 | 10 | 5.00 | 0.5003 |
| 10,000 | 100 | 50.12 | 0.5025 |
| 10,000 | 1,000 | 512.49 | 0.5250 |
| 100,000 | 10 | 5.00 | 0.5000 |
| 100,000 | 100 | 50.01 | 0.5003 |
| 100,000 | 1,000 | 501.25 | 0.5025 |

---

## 4. PART 2 — SELL SIDE

### 4.1 Worked Example: $b = 1000$, Buying 100 Then Selling It Back

**Step 1 — User buys 100 YES** (from §3.1): pays **51.249480 FKToken**, price moves 0.50 → 0.524979.

**Step 2 — User sells the same 100 YES back** ($q_{\text{yes}}: 100 \to 0$):
$$\text{Payout} = 1000 \cdot \ln(e^{0.1} + 1) - 1000 \cdot \ln(2) = 744.396660 - 693.147181 = \mathbf{51.249480 \text{ FKToken}}$$

**Step 3 — Net result:** $51.249480$ paid in − $51.249480$ received out = **0 FKToken**. Price returns to **0.50**.

> **Answer:** At 0% fee, selling exactly what you bought returns **exactly what you paid** — the round-trip is free. Profit only comes from *price movement between buy and sell* (see §4.4).

### 4.2 Full Round-Trip Matrix (Buy $X$ → Sell $X$ Back)

Every row returns to $P = 0.50$ with a net cost of exactly **zero**.

| $b$ | Buy / Sell $X$ | Buy cost paid | Sell payout received | Net | Price after |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 1000 | 10 | 5.012500 | 5.012500 | 0.000000 | 0.5000 |
| 1000 | 100 | 51.249480 | 51.249480 | 0.000000 | 0.5000 |
| 1000 | 1,000 | 620.114507 | 620.114507 | 0.000000 | 0.5000 |
| 10,000 | 10 | 5.001250 | 5.001250 | 0.000000 | 0.5000 |
| 10,000 | 100 | 50.124999 | 50.124999 | 0.000000 | 0.5000 |
| 10,000 | 1,000 | 512.494795 | 512.494795 | 0.000000 | 0.5000 |
| 100,000 | 10 | 5.000125 | 5.000125 | 0.000000 | 0.5000 |
| 100,000 | 100 | 50.012500 | 50.012500 | 0.000000 | 0.5000 |
| 100,000 | 1,000 | 501.249995 | 501.249995 | 0.000000 | 0.5000 |

### 4.3 Partial Sell From the Deep State ($q_{\text{yes}} = 1000$ Already Sold)

The pool has already sold 1,000 YES (starting prices: **0.731059** at b=1000, **0.524979** at b=10,000, **0.502500** at b=100,000). A holder sells $Y$ YES back.

#### Case B1 — Shallow Liquidity: $b = 1000$ (start $P(\text{YES}) = 0.731059$)

| Sell $Y$ | Payout received | Avg payout / token | New $P(\text{YES})$ | New $P(\text{NO})$ | Price drop |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **10** | 7.3007 | 0.7301 | 0.729088 | 0.270912 | 0.197pp |
| **100** | 72.1078 | 0.7211 | 0.710950 | 0.289050 | 2.011pp |
| **1,000** | 620.1145 | 0.6201 | 0.500000 | 0.500000 | 23.106pp |

#### Case B2 — Medium Liquidity: $b = 10{,}000$ (start $P(\text{YES}) = 0.524979$)

| Sell $Y$ | Payout received | Avg payout / token | New $P(\text{YES})$ | New $P(\text{NO})$ | Price drop |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **10** | 5.2485 | 0.5249 | 0.524730 | 0.475270 | 0.025pp |
| **100** | 52.3732 | 0.5237 | 0.522485 | 0.477515 | 0.249pp |
| **1,000** | 512.4948 | 0.5125 | 0.500000 | 0.500000 | 2.498pp |

#### Case B3 — Deep Liquidity: $b = 100{,}000$ (start $P(\text{YES}) = 0.502500$)

| Sell $Y$ | Payout received | Avg payout / token | New $P(\text{YES})$ | New $P(\text{NO})$ | Price drop |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **10** | 5.0249 | 0.5025 | 0.502475 | 0.497525 | 0.0025pp |
| **100** | 50.2375 | 0.5024 | 0.502250 | 0.497750 | 0.025pp |
| **1,000** | 501.2500 | 0.5012 | 0.500000 | 0.500000 | 0.250pp |

### 4.4 Profit-Taking Example: Buy Low, Sell High ($b = 1000$)

The interesting case — the price **rose after the user bought** (because *other* traders bought too, pushing the pool's total sold YES from 100 up to 1,000). Start: user bought 100 YES at cost **51.2495** (avg **0.5125/token**, price 0.50 → 0.524979). Days later the market leans YES and the price is higher; the user sells their 100 YES from the deep state at $P(\text{YES}) = 0.731059$:

| Action | Amount |
| :--- | :--- |
| Bought 100 YES earlier | −51.25 FKToken (avg 0.5125/token) |
| Sells 100 YES now (avg 0.7211) | **+72.11 FKToken** |
| **Net profit** | **+20.86 FKToken** |

Selling the full position locks in the gain and drives the price back down (see Case B1 — selling 100 drops $P(\text{YES})$ by 2.0pp). The pool pays this out from its raw `FKToken` balance, automatically calling `mergePositions()` on `ConditionalTokens` if raw collateral runs low (see the sell-flow in `docs/lmsr_implementation_details.md`).

### 4.5 Sell Cheat Sheet

| If $b$ = | Pool has sold | And holder sells | They receive | New YES price |
| :---: | :---: | :---: | :---: | :---: |
| 1000 | 1,000 | 10 | 7.30 | 0.7291 |
| 1000 | 1,000 | 100 | 72.11 | 0.7110 |
| 1000 | 1,000 | 1,000 | 620.11 | 0.5000 |
| 10,000 | 1,000 | 10 | 5.25 | 0.5247 |
| 10,000 | 1,000 | 100 | 52.37 | 0.5225 |
| 10,000 | 1,000 | 1,000 | 512.49 | 0.5000 |
| 100,000 | 1,000 | 10 | 5.02 | 0.5025 |
| 100,000 | 1,000 | 100 | 50.24 | 0.5023 |
| 100,000 | 1,000 | 1,000 | 501.25 | 0.5000 |

> **Round-trip cheat:** buy $X$ → sell $X$ → net **0.00**, price back to **0.50**, for every $b$ and every $X$.

---

## 5. PART 3 — WHAT IF LIQUIDITY IS ADDED OR REMOVED MID-MARKET?

Everything so far assumed $b$ stays constant for the market's lifetime. But in the Recrd design, LPs can **deposit or withdraw liquidity mid-market** (and under the instant auto-allocation flow, every `depositLiquidity()` call immediately scales $b$ while trading is live). This section shows exactly what happens to prices when $b$ changes **after the market has already sold tokens** ($q_{\text{yes}} \ne 0$).

### 5.1 Starting State (Before the Change)

The pool has already sold **500 YES** ($q_{\text{yes}} = 500$, $q_{\text{no}} = 0$) at $b = 1000$:

$$P(\text{YES}) = \frac{e^{500/1000}}{e^{500/1000} + 1} = \frac{e^{0.5}}{e^{0.5} + 1} = \mathbf{0.622459}$$

### 5.2 Adding Liquidity Mid-Market: $b = 1000 \to 2000$

| Approach | $q_{\text{yes}}$ | $P(\text{YES})$ before | $P(\text{YES})$ after | Price change |
| :--- | :---: | :---: | :---: | :---: |
| **No rescale (naive)** | 500 (unchanged) | 0.622459 | **0.562177** | **−6.03pp ⚠️** |
| **Proportional rescale** ($q_{\text{yes}} = 500 \to 1000$) | 1000 | 0.622459 | **0.622459** | **0.00pp ✅** |

**The problem:** doubling $b$ while leaving $q_{\text{yes}} = 500$ intact drops the ratio $q/b$ from 0.5 to 0.25, so the price **instantly falls from 62.25¢ to 56.22¢ with no trading at all** — MEV bots can front-run the deposit and arbitrage the predictable jump.

**The fix:** rescale liabilities proportionally so the ratio $q/b$ (and therefore the price) never changes:

$$q_{i,\text{new}} = q_{i,\text{old}} \cdot \frac{b_{\text{new}}}{b_{\text{old}}}$$

With $q_{\text{yes}}$ scaled to 1000, $q/b = 0.5$ again and the price stays at exactly **0.622459**.

### 5.3 Removing Liquidity Mid-Market: $b = 1000 \to 500$

| Approach | $q_{\text{yes}}$ | $P(\text{YES})$ before | $P(\text{YES})$ after | Price change |
| :--- | :---: | :---: | :---: | :---: |
| **No rescale (naive)** | 500 (unchanged) | 0.622459 | **0.731059** | **+10.86pp ⚠️** |
| **Proportional rescale** ($q_{\text{yes}} = 500 \to 250$) | 250 | 0.622459 | **0.622459** | **0.00pp ✅** |

Removing liquidity has the mirror effect: the price **jumps up** (to 73.1¢ here) because the remaining pool is thinner. In the extreme, shrinking $b$ from 1000 to 200 without rescaling pushes the price to **0.924142** — a +30.17pp swing from a single admin/LP action.

### 5.4 After the Change — What Does the Next Trade Look Like?

Even when $b$ is rescaled price-neutrally, the *slippage curve* changes: deeper pools are flatter, shallower pools are steeper. The next user buys 100 YES:

| State | Cost paid (100 YES) | New $P(\text{YES})$ | Interpretation |
| :--- | :---: | :---: | :--- |
| $b = 1000$ (unchanged, $q = 500$) | 63.4110 | 0.645656 | Baseline |
| $b = 2000$ with rescale ($q = 1000$) | 62.8310 | 0.634136 | **Less slippage** (deeper pool) |
| $b = 500$ with rescale ($q = 250$) | 64.5545 | 0.668188 | **More slippage** (shallower pool) |

### 5.5 Bottom Line

- Changing $b$ while $q \ne 0$ **without rescaling liabilities creates an instant, risk-free price jump** that MEV/front-runners can exploit — this is why the reference Gnosis implementation only allows `changeFunding()` while the market is **Paused**.
- The correct behavior is **proportional liability rescaling** ($q_{i,\text{new}} = q_{i,\text{old}} \cdot b_{\text{new}} / b_{\text{old}}$), which keeps the price constant across the liquidity change.
- See **Concern 3** in `docs/Concerns.md` for the full risk analysis and mitigations.

---

## 6. Key Observations

**Buy side:**
1. **The starting price is always 0.50** — liquidity $b$ never changes the *initial* price, only the price *trajectory*.
2. **Cost is not `X × 0.5`.** Because the price rises *as you buy* (LMSR charges the marginal price for every token), the total cost for $X$ tokens is the **integral under the curve** — hence average cost per token is always **higher than the starting 0.50** and rises with $X$.
3. **Slippage scales inversely with $b$.** Rough rule visible in the tables (valid for small $X \ll b$):
   - $b = 1000$ → a buy of $X$ tokens moves the price by ~$\frac{X}{1000} \cdot 50\%$.
   - $b = 10{,}000$ → same buy moves price 10× less.
   - $b = 100{,}000$ → same buy moves price 100× less.

**Sell side:**
4. **Round-trips are free at 0% fee.** Buy $X$ then sell $X$ nets exactly zero and the price returns to 0.50 (path independence of the LMSR cost function).
5. **Sell payouts are priced from the *current* marginal price, not the purchase price.** The payout integrates the marginal prices across the sold range — for small sells the average ≈ the current marginal (e.g. avg 0.7301 vs. marginal 0.7311 at b=1000); for large sells it lands between the start and end price. In §4.3, a 10-token sell pays ≈ 0.73/token at b=1000 but ≈ 0.50/token at b=100,000 — the payout tracks where the market is *now*.
6. **Selling reduces the price (reverse of buying).** Every sell drops $P(\text{YES})$ and raises $P(\text{NO})$ by the mirror amount, keeping $P(\text{YES}) + P(\text{NO}) = 1$. Deeper liquidity = smaller price impact on sells too (selling 100 YES drops the price 2.01pp at b=1000, 0.25pp at b=10,000, 0.025pp at b=100,000).
7. **The `collateralLimit` on a sell acts as a *minimum* payout.** The user supplies a limit such that the actual payout must be ≥ the limit, or the trade reverts (protects against front-running on sells).
8. **The pool is always the buyer of last resort.** A user never needs to find a counterparty — the LMSR formula mathematically determines the payout the pool must return.

**Both sides:**
9. **The "next user's price"** after any trade is simply $P(\text{YES})$ with the updated $q_{\text{yes}}$: `e^(q/b) / (e^(q/b) + 1)`. The NO price is the mirror image `1 − P(YES)`.
10. **Max-loss cap:** the pool's worst-case loss per market is $b \cdot \ln(2)$: ≈ **693** (b=1000), ≈ **6,931** (b=10,000), ≈ **69,314** (b=100,000) FKToken. Bigger $b$ = deeper liquidity but larger maximum subsidized loss.
11. **0% fee assumption:** all figures are pure LMSR cost. With the blueprint's optional fee, the buyer's total spend becomes $\text{Cost} \times (1 + \text{fee})$ (e.g. ×1.02 for a 2% fee).

---

## 7. Combined Quick-Reference Cheat Sheet

| $b$ | Buy $X$ | Buy cost | Next YES price | Round-trip net | Sell $Y$ (pool sold 1,000) | Sell payout | New YES price |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 1000 | 10 | 5.01 | 0.5025 | 0.00 | 10 | 7.30 | 0.7291 |
| 1000 | 100 | 51.25 | 0.5250 | 0.00 | 100 | 72.11 | 0.7110 |
| 1000 | 1,000 | 620.11 | 0.7311 | 0.00 | 1,000 | 620.11 | 0.5000 |
| 10,000 | 10 | 5.00 | 0.5003 | 0.00 | 10 | 5.25 | 0.5247 |
| 10,000 | 100 | 50.12 | 0.5025 | 0.00 | 100 | 52.37 | 0.5225 |
| 10,000 | 1,000 | 512.49 | 0.5250 | 0.00 | 1,000 | 512.49 | 0.5000 |
| 100,000 | 10 | 5.00 | 0.5000 | 0.00 | 10 | 5.02 | 0.5025 |
| 100,000 | 100 | 50.01 | 0.5003 | 0.00 | 100 | 50.24 | 0.5023 |
| 100,000 | 1,000 | 501.25 | 0.5025 | 0.00 | 1,000 | 501.25 | 0.5000 |

> **Note:** buy-side columns start from $P = 0.50$; sell-side columns start from the deep state ($q_{\text{yes}} = 1000$). Round-trip net is always **0.00** at 0% fee.
