# Adversarial Protocol Round 26: The Pebble Complexity & P-Completeness Barrier
Date: 2026-09-14
Target: Deep Adversarial Deconstruction of Round 25 (The Space-Bounded Circuit Evaluation Fallacy)
Authors: Charles (Lead Architect) & Yelena (Chief Risk Officer & Formal Verifier)

---

## 1. The Discovered Flaw in Round 25 (Lemma 25.1)

In Round 25, Lemma 25.1 claimed that any circuit $C_N$ of size $S \le 2^{m(1+\epsilon)}$ can be evaluated in $\mathsf{SPACE}[O(m^2)]$.

### The Mathematical Flaw (The Pebble Game Barrier):
1. **General DAG Evaluation is P-Complete (Ladner 1975):**
   Evaluating general Boolean circuits with high fan-out and arbitrary DAG topologies is $\mathsf{P}$-complete under log-space reductions.
2. **Pebble Complexity (Cook 1974 / Hopcroft–Paul–Valiant 1977):**
   There exist families of Boolean DAGs of size $S$ whose evaluation requires $\Omega(S / \log S)$ pebble space.
   For $S = 2^{m(1+\epsilon)}$, the required space is:
   $$\text{Space} = \Omega\left(\frac{2^{m(1+\epsilon)}}{m}\right) = 2^{\Omega(m)}$$
   It is **NOT** $O(m^2)$.
3. **The Alternating Time Collapse:**
   Because evaluating $C_N$ requires $2^{\Omega(m)}$ space, simulating it inside an alternating Turing machine takes $\Sigma_2\mathsf{TIME}[2^{m(1+\epsilon)}]$, which is $> 2^m$. It does not achieve the required $2^{m - \Omega(m)}$ bound.

---

## 2. Mathematical Verdict
Round 25's claim of $O(m^2)$ space-bounded evaluation for general DAGs is **FALSE for general circuits** (it holds only for Boolean formulas $\mathsf{NC}^1$).
The **General DAG Inversion Barrier** remains unbridged for arbitrary $\mathsf{P/poly}$ circuits.
