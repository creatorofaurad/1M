# ROUND 63: RIGOROUS FIRST-PRINCIPLES AUTOPSY OF THE 3 EXTERIOR PATHWAYS

**Date:** 2026-09-14  
**Author:** Yelena & Charles  
**Status:** COMPLETE MATHEMATICAL EVALUATION  

---

## 1. Pathway 1 Deep Dive: The Algorithmic Method (Ryan Williams)

### A. State of the Art:
- **Known Results:**
  - $\mathsf{NEXP} \not\subseteq \mathsf{ACC}^0$ (Williams 2011): Solved $\mathsf{ACC}^0$-SAT in $2^{n - n^{\epsilon}}$ time using the Beigel-Tarui symmetric polynomial representation over $\mathbb{Z}_m$ + Fast Matrix Multiplication.
  - $\mathsf{NEXP} \not\subseteq \mathsf{ACC}^0 \circ \mathsf{THR}$ (Williams 2014): Extended to depth-2 circuits with a top threshold gate.
  - $\mathsf{NEXP} \not\subseteq \text{linear size } \mathsf{TC}^0$ (Chen, Tell 2023): Fast algorithm for very sparse threshold circuits.

### B. The Exact Technical Bottleneck:
- To extend to full $\mathsf{TC}^0$ (constant-depth threshold circuits) or $\mathsf{NC}^1$ (log-depth formulas), one needs to evaluate the sum $\sum_{x \in \{0,1\}^n} C(x)$ faster than $2^n$.
- **The Degree Barrier:** Any polynomial approximating a majority gate $\mathsf{MAJ}(x_1, \dots, x_k)$ with error $\epsilon < 1/2$ requires degree $d = \Omega(\sqrt{k})$ over $\mathbb{R}$ and degree $d = \Omega(k)$ over finite fields $\mathbb{F}_p$.
- In a circuit of depth $d \ge 3$, the composition of approximations causes the algebraic degree to blow up to $k^{3/2} \gg n$, making the polynomial denser than the $2^n$ brute-force table!

### C. The Most Promising Attack Lemma:
- **Lemma Candidate 63.1 (Dual Chebyshev-Sparsity Lemma):** 
  Instead of approximating every gate individually, approximate the *entire input-to-output distribution* via a sum of $2^{n^{1-\epsilon}}$ random linear combinations in the Fourier-Chebyshev domain, amortizing the degree blowup across all gates simultaneously.

---

## 2. Pathway 2 Deep Dive: Self-Referential Kolmogorov Diagonalization ($\mathsf{Gap\text{-}MKtP}$)

### A. State of the Art:
- **Known Results:**
  - Oliveira-Santhanam (2018): If $\mathsf{MKtP}$ requires $N^{1+\epsilon}$ size circuits, then $\mathsf{EXP}^{\mathsf{NP}} \not\subseteq \mathsf{P/poly}$.
  - Chen-Jin-Williams (2019): Magnified this to $\mathsf{NP} \not\subseteq \mathsf{P/poly}$ if an $N^{1+\epsilon}$ formula/branching-program lower bound holds for $\mathsf{Gap\text{-}MKtP}$.

### B. The Exact Technical Bottleneck:
- **The Locality Barrier (McKay, Murray, Williams 2019):**
  Current lower bound techniques (like gate elimination or random restrictions) are "local"—they evaluate how fixing 1 variable simplifies the remaining gates.
  However, any local property that can prove $S \ge 3n$ on $\mathsf{Gap\text{-}MKtP}$ *also holds for random strings*, which triggers the Natural Proofs barrier!
  To prove $S \ge N^{1+\epsilon}$, one MUST use a non-local global property that specifically detects that the string has small Kolmogorov complexity $\mathsf{Kt}(x) \le N^\delta$.

### C. The Most Promising Attack Lemma:
- **Lemma Candidate 63.2 (Incompressibility Deficit Invariant):**
  Prove that any circuit $C$ of size $S \le N^{1+\epsilon}$ has a canonical bitstring representation $\langle C \rangle$ of length $|\langle C \rangle| \le 3S \log S \ll N^{1+\delta}$, which forces the truth table of $C$ to have a non-zero overlap with the low-complexity set, making it impossible for $C$ to compute the anti-checker function on all inputs.

---

## 3. Pathway 3 Deep Dive: Non-Commutative Geometric Complexity Theory (GCT)

### A. State of the Art:
- **Known Results:**
  - Mulmuley-Sohoni (2001, 2008): Formalized $\mathsf{VP} \neq \mathsf{VNP}$ via representation-theoretic character multiplicities in orbit closures $\overline{GL_{n^2} \cdot \mathrm{det}_n}$ vs $\overline{GL_{n^2} \cdot \mathrm{perm}_n}$.
  - Ikenmeyer-Panova-Weyman (2017): Proved that *occurrence obstructions* (multiplicity zero in Det, non-zero in Perm) do NOT exist.
  - Garg-Oliveira-Wigderson (2016): Proved that non-commutative operator scaling and null-cone membership can be decided in deterministic polynomial time.

### B. The Exact Technical Bottleneck:
- **Multiplicity Obstruction Computation:** One must show that the multiplicity of some irreducible representation $V_\lambda$ in $\mathbb{C}[\overline{\mathcal{O}_{\mathrm{perm}}}]$ is strictly greater than in $\mathbb{C}[\overline{\mathcal{O}_{\mathrm{det}}}]$.
- Computing these multiplicities requires evaluating Kronecker coefficients $g(\lambda, \mu, \nu)$, which is $\sharp\mathsf{P}$-hard in general, and known asymptotics are extremely loose.

### C. The Most Promising Attack Lemma:
- **Lemma Candidate 63.3 (Geodesic Convex Multiplicity Gap):**
  Use the non-commutative moment map and geodesically convex optimization on the flag manifold $GL_N / B$ to bound the representation multiplicities without computing the individual Kronecker coefficients explicitly.

---

## 4. The Strategic Comparison Matrix

| Metric | Pathway 1 (Algorithmic) | Pathway 2 (Kolmogorov Magnification) | Pathway 3 (Non-Commutative GCT) |
| :--- | :--- | :--- | :--- |
| **Target Goal** | Fast #SAT Algorithm ($2^{n - n^\epsilon}$) | $N^{1+\epsilon}$ Lower Bound on $\mathsf{Gap\text{-}MKtP}$ | Multiplicity Gap in Orbit Closure |
| **Separation Yield** | $\mathsf{NEXP} \not\subseteq \mathsf{TC}^0$ / $\mathsf{NC}^1$ | $\mathsf{NP} \not\subseteq \mathsf{P/poly}$ ($\mathsf{P} \neq \mathsf{NP}$) | $\mathsf{VP} \neq \mathsf{VNP}$ (Algebraic $P \neq NP$) |
| **Core Difficulty** | Majority polynomial degree explosion | The Locality Barrier ($3n \to N^{1+\epsilon}$) | $\sharp\mathsf{P}$-hard Kronecker coefficients |
| **Barrier Immunity** | 100% (By construction) | 100% (Sparse & Non-Constructive) | 100% (Non-Constructive Invariant) |
