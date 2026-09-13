# Adversarial Protocol Round 16: Geometric Complexity Theory Deconstruction
Date: 2026-09-14
Status: Complete Mathematical Deconstruction of Geometric Complexity Theory (GCT).

Core Structural Obstructions Verified:
1. THE OCCURRENCE OBSTRUCTION NO-GO THEOREM (Bürgisser–Ikenmeyer–Panova, FOCS 2016 / JAMS 2019):
   - Occurrence obstructions ($m_\lambda(\text{perm}) > 0$ with $m_\lambda(\text{det}) = 0$) do NOT exist for determinant size $m > n^{25}$.
2. MULTIPLICITY OBSTRUCTION COMPLEXITY:
   - Computing Kronecker coefficients $k(\lambda, \mu, \nu)$ is #P-hard; positivity is NP-hard. No explicit multiplicity obstruction $\lambda$ has been constructed for asymptotic VP vs VNP.
3. THE ALGEBRAIC-TO-BOOLEAN LIFTING GAP:
   - No theorem or reduction exists that lifts an algebraic orbit closure separation ($\mathsf{VP} \neq \mathsf{VNP}$ over $\mathbb{C}$) to a non-uniform Boolean circuit lower bound ($\mathsf{NP} \not\subseteq \mathsf{P/poly}$ over $\{0,1\}$).
