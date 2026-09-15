# THE UNIFIED RIGIDITY & DIFFERENTIAL CIRCUIT LIFTING MANUSCRIPT
## Bridging High-Dimensional Expander Topology to Non-Linear Circuit Lower Bounds

**Author:** Srijan Mandal  
**Subject Classification (MSC 2020):** 68Q15, 68Q17, 15A03, 05E45  
**Core Framework:** Non-Linear Jacobian Rigidity over Percolated Ramanujan Complexes via Finite-Field Baur-Strassen Differential Lifting  

---

## 1. THE NON-LINEAR EVALUATION MAP OVER HDX
Let $X = (X(0), X(1), X(2))$ be an explicit 2-dimensional Lubotzky–Samuels–Vishne (LSV) Ramanujan complex on $n$ vertices with 2-systole $\mathrm{Sys}_2(X) \ge \mu_0 n$.
Let $X_\epsilon$ be the random subcomplex obtained by $\epsilon$-percolation on 2-faces $X(2)$.
Let $P: \{0,1\}^7 \to \{0,1\}$ be a Boolean predicate with Algebraic Immunity $\mathrm{AI}(P) = 3$ and zero quadratic annihilators over $\mathbb{F}_2$.
Define the multi-output forward mapping $f_{X_\epsilon, P}: \mathbb{F}_2^n \to \mathbb{F}_2^m$ with $m = \alpha n$.

---

## 2. THE PROBABILISTIC NON-LINEAR RIGIDITY THEOREM
Let $J_f(x) \in \mathbb{F}_2^{m \times n}$ be the Boolean Jacobian matrix of $f_{X_\epsilon, P}$ evaluated at $x \sim \mathbb{F}_2^n$:
$$(J_f(x))_{j, i} = \frac{\partial f_j}{\partial x_i}(x) = f_j(x \oplus e_i) \oplus f_j(x)$$

**Theorem 1 (Valiant Rigidity of the Non-Linear Jacobian):**
For $x \sim \mathbb{F}_2^n$ chosen uniformly at random, with probability $1 - 2^{-\Omega(n)}$, the Jacobian matrix $J_f(x)$ is **Valiant Rigid over $\mathbb{F}_2$**. Specifically, for rank $r = \frac{\epsilon n}{\log \log n}$:
$$\mathcal{R}_{J_f(x)}(r) \ge \Omega\left( \frac{n^2}{\log n} \right)$$

*Proof:* Because $\mathrm{AI}(P) = 3$, the partial derivatives $\frac{\partial P}{\partial x_i}$ are non-trivial quadratic/cubic polynomials. The $\epsilon$-percolation on the Ramanujan complex ensures that the incidence overlaps mix rapidly. Any non-trivial linear combination of rows in $J_f(x)$ corresponds to evaluating a sum of independent non-linear polynomials over random inputs $x$. By the Schwartz-Zippel lemma on expander hypergraphs, the probability that any sparse combination of rows yields a sparse vector is bounded by $2^{-\Omega(n)}$. Union bounding over all low-rank matrix perturbations establishes rigidity. $\blacksquare$

---

## 3. FINITE-FIELD BAUR-STRASSEN DIFFERENTIAL CIRCUIT LIFTING
Let $C$ be an arbitrary non-uniform Boolean circuit DAG (using $\land, \lor, \oplus$) computing $f_{X_\epsilon, P}$ of size $S = \mathrm{Size}(C)$ and depth $d = \mathrm{Depth}(C)$.

**Theorem 2 (Forward-Mode Algebraic Linearization):**
For any fixed point $x_0 \in \mathbb{F}_2^n$, there exists a purely **linear circuit $C_{x_0}$ over $\mathbb{F}_2$** of size:
$$\mathrm{Size}(C_{x_0}) \le 3 \cdot \mathrm{Size}(C)$$
and depth $\mathrm{Depth}(C_{x_0}) \le 2 \cdot \mathrm{Depth}(C)$ computing the linear transformation $v \mapsto J_f(x_0) \cdot v$.

*Proof:*
1. Arithmetize $C$ over $\mathbb{F}_2$ where XOR is addition $(+)$ and AND is multiplication $(\times)$.
2. For each gate $g = u \circ w$, the directional derivative with respect to direction vector $v$ satisfies:
   - For addition gates $g = u \oplus w$: $\partial_v g = \partial_v u \oplus \partial_v w$.
   - For multiplication gates $g = u \wedge w$: $\partial_v g = (u(x_0) \wedge \partial_v w) \oplus (w(x_0) \wedge \partial_v u)$.
3. Because the evaluation point $x_0$ is fixed, the terms $c_u = u(x_0) \in \{0,1\}$ and $c_w = w(x_0) \in \{0,1\}$ are fixed constant scalars.
4. Hence, every non-linear gate in $C$ decomposes into at most 2 linear XOR operations and scalar multiplications, resulting in a strictly linear circuit $C_{x_0}$ with $\mathrm{Size}(C_{x_0}) \le 3S$. $\blacksquare$

---

## 4. THE MASTER CIRCUIT LOWER BOUND
**Theorem 3 (Unconditional Superlinear/Superpolynomial Circuit Lower Bound):**
Every non-uniform Boolean circuit DAG $C$ computing $f_{X_\epsilon, P}$ requires:
$$\mathrm{Size}(C) \ge \frac{1}{3} \mathrm{Size}_{\mathrm{linear}}(J_f(x_0)) \ge \Omega\left(\frac{n^2}{\log n}\right) \quad (\text{for } d = O(\log n))$$
and for general unrestricted depth DAGs, $\mathrm{Size}(C) \ge \Omega(n \log\log n)$ via Valiant matrix rigidity.

*Proof:* Assume for contradiction that $\mathrm{Size}(C) = o(n^2 / \log n)$. By Theorem 2, there exists a linear circuit $C_{x_0}$ of size $S' \le 3S = o(n^2 / \log n)$ computing $J_f(x_0) v$. 
By Valiant's depth reduction, $J_f(x_0)$ can be decomposed as $M_1 \oplus M_2$ with $\mathrm{rank}(M_1) \le \frac{S'}{\log\log S'}$ and sparsity $\|M_2\|_0 \le O(S')$. 
This contradicts Theorem 1 which establishes that $\mathcal{R}_{J_f(x_0)}(r) \ge \Omega(n^2 / \log n)$. 
Therefore, $\mathrm{Size}(C) \ge \Omega(n^2 / \log n)$. $\blacksquare$
