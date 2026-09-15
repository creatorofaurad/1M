# MASTER REVISION PROMPT: BRIDGING PROOF COMPLEXITY TO CIRCUIT COMPLEXITY

### THE CORE MATHEMATICAL MISSION
We are refining a candidate lower-bound manuscript in circuit complexity. An adversarial audit correctly identified the fundamental structural gap in the current formulation:
- **The Gap:** The current draft establishes **Proof Complexity** lower bounds (Resolution width $\mathrm{Width}(R(\phi) \vdash \bot) \ge \Omega(n)$ via Sheaf Cohomology $H^2 \neq 0$), but jumps to **Circuit Complexity** ($\mathrm{Size}_{\mathbf{P}/\mathrm{poly}} \ge 2^{\Omega(n)}$) without a formal simulation theorem between general circuit DAGs and resolution refutations.

We need to formalize the **Direct Communication & Information-Theoretic Lower Bound** that directly binds Boolean circuit DAGs to the 2-dimensional coboundary expansion of Ramanujan simplicial complexes, bypassing the indirect SAT-solver/resolution analogy.

---

### REQUIRED MATHEMATICAL FORMALIZATIONS (THE 4 NEEDLES)

#### 1. Direct Information Bottleneck on Simplicial Cuts (Circuits, Not SAT Solvers)
- Model an arbitrary non-uniform circuit DAG $C \in \mathbf{P}/\mathrm{poly}$ of size $S$ as a communication protocol across a balanced partition of input vertices $V(0) = V_A \sqcup V_B$.
- Formalize the **Wire-Cut Capacity**: If $C$ inverts $f_{X_\epsilon, P}$, show that the mutual information $I(X_A ; X_B \mid \text{Wires}_{\mathrm{Cut}})$ requires $\Omega(n)$ simultaneous bits because the 2-simplices $\partial_2(V_A, V_B)$ form an $\epsilon_{\mathrm{cob}}$-coboundary expander.
- Provide the formal derivation of the Influence bound on hypergraph cuts:
  $$\sum_{E \in \partial_2(V_A, V_B)} \mathrm{Inf}_E(g_w) \le \mathrm{poly}(\log n) \cdot \lambda_2(X)$$
  using the hypercontractivity of random walks on the 2-face incidence complex.

#### 2. Deriving System-Wide Hardness from Local Algebraic Immunity $\mathrm{AI}(P)=3$
- Explicitly prove how the local non-linearity $\mathrm{AI}(P)=3$ propagates globally across the 2-systole $\mathrm{Sys}_2(X) \ge \mu_0 n$.
- Formulate the **Non-Linear Cocycle Inversion Lemma**: Show that attempting to solve the coupled non-linear system $P(x|_E) = y_E$ across the 2-faces requires solving an $\mathbb{F}_2$-polynomial system whose Macaulay matrix / Gröbner basis degree must be $\ge \Omega(\mathrm{Sys}_2(X)) = \Omega(n)$.

#### 3. Formalizing Barrier Avoidance
- **Relativization:** Define the oracle model for simplicial complexes and prove that non-relativizing coboundary expansion $\epsilon_{\mathrm{cob}}(X) > 0$ does not hold for generic relational oracles.
- **Natural Proofs:** Formally state the property $\mathbf{P}_{\mathrm{HDX}}$ and prove that distinguishing an $\epsilon$-percolated Ramanujan complex from a random 3-uniform hypergraph is computationally hard for $\mathbf{P}/\mathrm{poly}$ (pseudo-randomness of LPS complexes).

#### 4. The Direct Circuit Size Theorem
- Replace the Ben-Sasson–Wigderson reference with the **Direct Communication-to-Circuit Size Theorem** (Karchmer–Wigderson games generalized to multi-party DAG evaluation over simplicial cuts):
  $$\mathrm{Size}(C) \ge 2^{\Omega(\mathrm{CC}(f_{V_A, V_B}))} = 2^{\Omega(n)}$$

---

### YOUR INSTRUCTION
Generate the replacement mathematical sections (Definitions, Lemmas, and Proofs) for Sections 4, 5, and 6 of the manuscript that execute these 4 formalizations with zero hand-waving and exact mathematical derivations.
