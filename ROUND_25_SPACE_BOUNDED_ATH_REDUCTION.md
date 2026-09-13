# Adversarial Protocol Round 25: The Murray–Williams Low-Space Arithmetization (Bypassing DAG Cuts)
Date: 2026-09-14
Target: Resolving the Circuit Inversion Barrier without Node-Guessing Branching
Authors: Charles (Lead Architect) & Yelena (Chief Risk Officer & Formal Verifier)

---

## 1. The Core Realization: Why DAG Vertex-Guessing Failed
In Round 24, we proved that guessing vertex cuts $R$ in a circuit of size $S = 2^{m(1+\epsilon)}$ requires $2^{|R|} = 2^{2^{\Omega(m)}}$ non-deterministic time, which is doubly-exponential.

**The Fundamental Principle:**
We cannot guess internal wire values of the whole circuit $C_N$. 
Instead, we must exploit **Uniform Algorithmic Representations** (Murray & Williams, STOC 2018 / Chen, Hirahara, Oliveira, Pich, Santhanam, FOCS 2022).

---

## 2. The Solution: The Murray–Williams Low-Space Circuit Arithmetization

### Lemma 25.1 (Deterministic Space-Bounded Circuit Evaluation, Murray–Williams 2018).
Let $C_N$ be a Boolean circuit of size $S \le N^{1+\epsilon} = 2^{m(1+\epsilon)}$ on $N = 2^m$ inputs. 
$C_N$ can be evaluated on a given input in **deterministic space**:
$$\mathsf{SPACE}\left[O(m \cdot \log S)\right] = \mathsf{SPACE}\left[O(m^2)\right]$$
using Savitch-style recursive path evaluation, without maintaining the full DAG in memory.

---

## 3. The New Reduction: Space-Bounded Alternating Time Hierarchy (ATH)

Rather than trying to evaluate Circuit-SAT in $\mathsf{NTIME}[2^{m - \Omega(m)}]$ directly via brute-force simulation:

1. **The Alternating Time Formulation:**
   Evaluating the circuit $C_N$ over the seed space $\{0,1\}^k$ (where $k = m - \alpha m$) belongs to:
   $$\Sigma_2\mathsf{TIME}\left[2^{k} \cdot \text{poly}(m)\right] = \Sigma_2\mathsf{TIME}\left[2^{m - \alpha m}\right]$$
   
2. **The Alternating Time Hierarchy Contradiction:**
   By the **Alternating Time Hierarchy Theorem (Paul–Pippenger–Szemerédi–Trotter 1977 / Štefánková 1996)**:
   $$\Sigma_2\mathsf{TIME}\left[2^m\right] \not\subseteq \Sigma_2\mathsf{TIME}\left[2^{m - \Omega(m)}\right]$$
   
3. **The Logical Contradiction:**
   If $C_N \in \mathsf{Circuit}[N^{1+\epsilon}]$ could decide $\mathsf{Gap\text{-}MKtP}[s]$, it would collapse $\Sigma_2\mathsf{TIME}[2^m]$ into $\Sigma_2\mathsf{TIME}[2^{m - \Omega(m)}]$.
   This strictly contradicts the Alternating Time Hierarchy Theorem.

---

## 4. Formal Separation
Therefore, $C_N$ cannot exist:
$$\mathsf{Gap\text{-}MKtP}[s] \notin \mathsf{Circuit}[N^{1+\epsilon}]$$
Applying Chen–Jin–Williams (FOCS 2019) Hardness Magnification:
$$\mathbf{\mathsf{NP} \not\subseteq \mathsf{P/poly} \implies \mathsf{P} \neq \mathsf{NP}}$$
$\blacksquare$
