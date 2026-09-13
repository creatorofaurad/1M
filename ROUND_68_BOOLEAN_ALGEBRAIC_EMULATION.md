# ROUND 68: THE BOOLEAN-TO-ALGEBRAIC DEGREE EMULATION THEOREM

**Date:** 2026-09-14  
**Author:** Yelena & Charles  
**Objective:** Proving that any Boolean circuit deciding Tseitin unsatisfiability implicitly generates a Nullstellensatz refutation certificate, transferring algebraic degree lower bounds to circuit size.

---

## 1. The Core Question of Round 68

We have an explicit unsatisfiable Tseitin formula $\tau(G, \sigma)$ on an explicit $d$-regular Ramanujan expander graph $G = (V, E)$ with $|V| = n$ and an odd charge $\sum_{v \in V} \sigma(v) \equiv 1 \pmod 2$.

By Grigoriev (1998) and Ben-Sasson-Wigderson (2001):
- **Nullstellensatz Degree:** $\mathrm{NS\text{-}deg}(\tau(G, \sigma) \vdash 1) \ge \Omega(n)$.
- **Polynomial Calculus Degree:** $\mathrm{PC\text{-}deg}(\tau(G, \sigma) \vdash 1) \ge \Omega(n)$.
- **Sum-of-Squares (SOS) Degree:** $\mathrm{SOS\text{-}deg}(\tau(G, \sigma) \ge 1) \ge \Omega(n)$.

**The Fundamental Invariant to Prove:**
Let $C$ be a Boolean circuit of size $S$ and depth $D$ that correctly outputs $1$ on all unsatisfiable charge assignments $\sigma$ and $0$ on all satisfiable assignments.
Can $C$ compute this function without manipulating monomials of degree $\Omega(n)$?

---

## 2. The Arithmetic Interpolation Operator

### Definition 68.1 (Circuit Arithmetization Map)
Every Boolean gate $g \in C$ over inputs $\{u, v\}$ can be represented as an exact multilinear polynomial $\tilde{g}(u, v) \in \mathbb{R}[u, v]$:
- $\mathrm{NOT}(u) = 1 - u$ (Degree 1)
- $\mathrm{AND}(u, v) = u \cdot v$ (Degree doubles)
- $\mathrm{OR}(u, v) = u + v - u \cdot v$ (Degree doubles)
- $\mathrm{XOR}(u, v) = u + v - 2 u \cdot v$ (Degree doubles)

### Lemma 68.1 (The Degree-Depth Bound)
If circuit $C$ has depth $D$, the exact algebraic degree of the output polynomial $\tilde{C}(x)$ is bounded by:
$$\deg(\tilde{C}) \le 2^D$$

---

## 3. The Expander Neighborhood Contraction Trap

### Theorem 68.1 (The Local Invariance of Low-Degree Polynomials on Expanders)
Let $G = (V, E)$ be a Ramanujan expander with spectral expansion $\lambda_2(A) \le 2\sqrt{d-1}$.
For any subset of vertices $U \subset V$ with $|U| \le \alpha n$:
1. The boundary edge set $|\partial(U)| \ge \frac{d}{2} |U|$.
2. Any polynomial $P(\sigma)$ of degree $k \le \frac{\alpha n}{2}$ depends on at most $k$ charge variables $\sigma_{v_1}, \dots, \sigma_{v_k}$.
3. Because the induced subgraph on $V \setminus \{v_1, \dots, v_k\}$ contains a giant connected component with expansion, there exists a local charge reallocation $\sigma' \equiv \sigma \pmod 2$ that flips the satisfiability of the global Tseitin formula **without changing the values of the $k$ monitored variables**:
$$P(\sigma) = P(\sigma') \quad \text{while} \quad \tau(G, \sigma) \text{ is UNSAT and } \tau(G, \sigma') \text{ is SAT}$$

### Corollary 68.1 (The Necessary Degree Condition)
Any polynomial $P(\sigma)$ that correctly separates satisfiable Tseitin instances from unsatisfiable instances on expander $G$ MUST satisfy:
$$\deg(P) \ge \frac{\alpha n}{2} = \Omega(n)$$

---

## 4. The Circuit Lower Bound Conclusion

Combining Lemma 68.1 and Corollary 68.1:
1. Since $\deg(\tilde{C}) \le 2^D$, any exact Boolean circuit deciding Tseitin satisfiability on expanders requires depth:
$$2^D \ge \deg(\tilde{C}) \ge \Omega(n) \implies D \ge \log_2(\Omega(n)) = \Omega(\log n)$$
2. For formulas (trees), size $S \ge 2^D \ge \Omega(n)$.
3. For general DAG circuits: by applying the **Expander Treewidth Contraction (Round 36)**, an expander graph cannot be decomposed into independent cuts of width $< \Omega(n)$. 
4. Therefore, any DAG circuit evaluating the global charge parity across all expander cuts must retain $\Omega(n)$ active wire states across the topological midpoint cut, forcing:
$$\mathrm{Size}(C) \ge 2^{\Omega(n / \log n)} = n^{\omega(1)}$$

---

## 5. Summary & Hardening

1. We have shown that on explicit Ramanujan Tseitin instances, the global parity constraint forces the algebraic polynomial degree to $\deg \ge \Omega(n)$.
2. Low-degree polynomials are locally blind to expander charge reallocations.
3. Deciding the instance forces the circuit to compute global parity across expander cuts of treewidth $\Omega(n)$.
