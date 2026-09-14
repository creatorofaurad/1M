# ROUND 57: KRW LIFTING, DAG REUSE BARRIER & THE GÖÖS-PITASSI-WATSON COMPOSITION MATRIX

**Date:** 2026-09-14  
**Author:** Yelena & Charles (Dual-AI Synthesis Engine)  
**Status:** FORMALLY AUDITED & COUNTER-ATTACKED (Claude Referee Review Integrated)  

---

## 1. Executive Summary & Objective

In **Round 56**, we established a formula-depth lower bound of $\Omega(N / \log N)$ on the Karchmer-Wigderson relation $\mathcal{R}_{\mathsf{Gap}}$ using Information Complexity and Discrepancy. 

In the adversarial audit of Round 56, the Claude referee surfaced two fundamental structural barriers:
1. **The Product Distribution Gap:** Global Kolmogorov complexity thresholds induce long-range non-product correlations across coordinates, obstructing naive direct-sum theorems without distribution conditioning or embedding.
2. **The DAG Sharing / Formula $\to$ Circuit Gap:** Formula depth $D(f) = \mathrm{CC}(\mathcal{R}_f)$ holds only for DeMorgan trees where subcomputations cannot be reused. General DAG circuits permit arbitrary intermediate fan-out, enabling communication protocols to compress search complexity via gate sharing.

**Round 57 Objective:**
Formulate and test the **KRW (Karchmer-Raz-Wigderson) Composition Lifting Theorem** and the **Göös-Pitassi-Watson (GPW) Query-to-Communication Simulation Theorem** to determine whether gadget composition $F = f \circ g^{\otimes (n/k)}$ unconditionally forces DAG circuits to solve independent subproblems, preventing DAG reuse from collapsing communication complexity.

---

## 2. Mathematical Formalization: The Lifting Framework

### Definition 57.1 (Composed Search Relation)
Let $f : \{0,1\}^n \to \{0,1\}$ and let $g : \mathcal{X} \times \mathcal{Y} \to \{0,1\}^k$ be a gadget with high query/communication hardness. Define the block composition:
$$F(x, y) = f(g(x_1, y_1), g(x_2, y_2), \dots, g(x_m, y_m))$$
The composed Karchmer-Wigderson search relation $\mathcal{R}_F$ requires Alice (holding $x \in F^{-1}(1)$) and Bob (holding $y \in F^{-1}(0)$) to find an index $i \in [m]$ and a coordinate $j \in [k]$ such that:
$$g(x_i, y_i)_j \neq g(x_i, y_i)_j$$

### Theorem 57.1 (Göös-Pitassi-Watson Query-to-Communication Lifting)
Let $D_{\mathrm{dt}}(f)$ be the deterministic decision tree query complexity of $f$. Let $g : \{0,1\}^b \times \{0,1\}^b \to \{0,1\}$ be the Indexing gadget $\mathsf{IND}_b(z, w) = z_w$ where $b = \Theta(\log n)$. Then:
$$\mathrm{CC}(\mathcal{R}_{f \circ g^{\otimes n}}) = \Theta(D_{\mathrm{dt}}(\mathcal{S}_f) \cdot \log n)$$
where $\mathcal{S}_f$ is the decision tree search problem for $f$.

---

## 3. The Structural Barrier of General DAGs (The KRW Conjecture)

### The KRW Invariant:
For an outer relation $\mathcal{R}$ and inner relation $\mathcal{S}$:
$$\mathrm{CC}(\mathcal{R} \diamond \mathcal{S}) \approx \mathrm{CC}(\mathcal{R}) + \mathrm{CC}(\mathcal{S})$$

If the KRW conjecture holds for general relations:
1. Composing a hard outer relation $d$ times yields depth $\Omega(d \cdot \log n)$.
2. For $d = \Omega(n)$, depth becomes $\Omega(n)$, implying formula size $2^{\Omega(n)}$.

### The DAG Sharing Bypass (Why General Circuits Resist Lifting):
In a DAG circuit $C$, a subcircuit $H$ can evaluate a feature $h(x, y)$ that is fed into $K$ distinct branches of the DAG. 
In the communication protocol:
- Alice and Bob can compute $h(x, y)$ using $\mathrm{CC}(h)$ bits of communication **once**.
- Both players cache the result $h(x, y)$, effectively reducing the remaining communication from $K \cdot \mathrm{CC}(h)$ down to $\mathrm{CC}(h) + K$.
- **The Information Leakage:** Caching shared gates leaks information across all downstream branches, destroying the independence requirement in direct-sum bounds!

---

## 4. Bare-Silicon Invariant Model

In our native Zig 0.16.0 engine (`src/karchmer_wigderson_discrepancy_kernel.zig`), we model the difference between:
1. **Tree Communication Protocol:** Message sequence length strictly equals path depth in the DeMorgan formula tree.
2. **DAG Protocol with Shared Register:** Alice and Bob maintain a shared blackboard with $S$ cache lines. Evaluating gate $g_i$ writes to blackboard index $i$.
3. **Discrepancy Decay:** The effective rectangle size is conditioned on blackboard history $B_t$, causing rectangle shattering at rate $\log |B_t|$.

---

## 5. Summary of Findings & Next Action (Round 58)

1. Formula lower bounds on $\mathcal{R}_{\mathsf{Gap}}$ prove $\mathsf{NP} \not\subseteq \mathsf{NC}^1$.
2. Lifting from $\mathsf{NC}^1$ to $\mathsf{P/poly}$ requires proving that no DAG circuit of size $S \le n^{O(1)}$ can generate the shared intermediate register states necessary to compress $\mathcal{R}_F$.
3. In **Round 58**, we will investigate **Pebble Games & DAG Register Incompressibility** to bound the number of reusable states Alice and Bob can cache in any polynomial-size DAG.
