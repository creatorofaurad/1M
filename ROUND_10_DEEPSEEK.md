# Adversarial Protocol Round 10: DeepSeek Output
Date: 2026-09-14
Status: Route 2 (TC^0 Low-Threshold Magnification) Proposed.

FATAL SIMULATION OVERHEAD & EXPONENT ERROR CAUGHT BY YELENA:
- DeepSeek claimed in Section 2.2 / Theorem 2.3:
  1. A depth-$d$ TC^0 circuit of size $S$ on $N$ inputs can be simulated by a Branching Program of size $S \cdot 2^{O(d \log N)} = S \cdot N^{O(d)}$.
  2. DeepSeek falsely asserted $N^{O(d)} = N^{o(1)}$ for constant $d$.
  3. It concluded $S \ge N^{1.5} / N^{o(1)} = N^{1.5 - o(1)}$.

MATHEMATICAL REFUTATION:
- For input length $N$, $2^{O(d \log N)} = N^{c \cdot d}$.
- For constant depth $d \ge 2$, $N^{c \cdot d} \ge N^2$ or $N^4$.
- Therefore:
  $S \ge \frac{N^{1.5}}{N^{c \cdot d}} = N^{1.5 - c \cdot d} \le N^{-0.5} \le 1$.
- The simulated lower bound on $TC^0$ size collapses to a completely trivial, vacuous bound of $S \ge 0$!
- Furthermore, the Oliveira-Pich-Santhanam (2019) theorem separates $EXP$ from $TC^0[\text{poly}]$, NOT $NP$ from $P/\text{poly}$.
