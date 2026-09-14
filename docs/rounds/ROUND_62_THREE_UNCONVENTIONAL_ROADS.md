# ROUND 62: THE THREE UNCONVENTIONAL ROADS OUTSIDE THE BARRIERS

**Date:** 2026-09-14  
**Author:** Yelena & Charles  
**Scope:** Deep-dive comparative architecture of the 3 barrier-evading pathways.

---

## 1. Pathway 1: The Algorithmic Method (Ryan Williams' Inversion)

### Core Thesis:
Lower bounds are equivalent to non-trivial algorithm design.
If there exists an algorithm $\mathcal{A}$ that solves Circuit-SAT for a circuit class $\mathcal{C}$ on $n$ variables with size $S(n)$ in time $O(2^n / n^{\omega(1)})$, then:
$$\mathsf{NEXP} \not\subseteq \mathcal{C}$$

### The Modern Front:
- **Known:** Proven for $\mathsf{ACC}^0$ (Williams 2011) and $\mathsf{ACC}^0 \circ \mathsf{THR}$ (Williams 2014) using the polynomial method over $\mathbb{Z}_m$ and fast matrix multiplication.
- **The Wall:** Majority gates in $\mathsf{TC}^0$ cannot be represented by low-degree polynomials over finite rings without degree $\Omega(\sqrt{n})$.
- **The Attack Vector:** Use Chebyshev polynomials over $\mathbb{R}$ or continuous optimization to count satisfying assignments for $\mathsf{TC}^0$ in sub-exponential time.

---

## 2. Pathway 2: Self-Referential Kolmogorov Diagonalization ($\mathsf{Gap\text{-}MKtP}$)

### Core Thesis:
Construct a language $L \in \mathsf{NP}$ that diagonalizes against all small circuits by using time-bounded Kolmogorov complexity $\mathsf{Kt}(x)$ as an explicit anti-checker.

### The Modern Front:
- **Known:** Oliveira-Santhanam (2018) & Chen-Jin-Williams (2019) proved that an $N^{1+\epsilon}$ lower bound on $\mathsf{Gap\text{-}MKtP}$ magnifies to $\mathsf{NP} \not\subseteq \mathsf{P/poly}$.
- **The Wall:** The Locality Barrier (McKay-Murray-Williams 2019): existing gate elimination techniques can only prove $O(N)$ bounds because local gate restrictions cannot feel the global Kolmogorov compressibility.
- **The Attack Vector:** Non-local diagonalization via pseudorandom generators seeded by incompressible truth-table prefixes.

---

## 3. Pathway 3: Non-Commutative Geometric Complexity Theory (GCT)

### Core Thesis:
Embed the Determinant and Permanent polynomials into coordinate rings of group varieties $GL_N(\mathbb{C})$, searching for multiplicity obstructions in the coordinate ring $\mathbb{C}[\overline{\mathcal{O}_{\mathrm{det}}}]$ versus $\mathbb{C}[\overline{\mathcal{O}_{\mathrm{perm}}}]$.

### The Modern Front:
- **Known:** Occurrence obstructions (0 vs >0 multiplicity) do not exist for the permanent vs determinant (Ikenmeyer-Panova-Weyman 2017).
- **The Wall:** Computing Kronecker coefficients $g(\lambda, \mu, \nu)$ is $\sharp\mathsf{P}$-hard.
- **The Attack Vector:** Shift from commutative polynomial orbits to non-commutative matrix invariant theory (Garg-Oliveira-Wigderson 2016), where operator scaling can be solved in polynomial time via deterministic geodesically convex optimization.
