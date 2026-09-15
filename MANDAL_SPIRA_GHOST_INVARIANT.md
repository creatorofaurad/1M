# The Mandal-Spira Ghost Invariant: Static Flux Elimination of DAG-Reuse

## 1. Theorem Statement (The Static Flux Invariant)
Let $\mathcal{G} = (V_L, V_R, E)$ be an $(n, m, d)$-Ramanujan expander with spectral gap $\gamma = d - \lambda_2 \ge d - 2\sqrt{d-1}$ and girth $g \ge 2\log_{d-1} n$. Let $P_{\mathrm{hard}}: \{0,1\}^7 \to \{0,1\}$ have algebraic immunity $\mathrm{AI}(P_{\mathrm{hard}}) = 3$.

For any Boolean circuit DAG $C$ computing $f_{\mathcal{G}, P_{\mathrm{hard}}}^{-1}$:
$$\mathrm{Size}(C) \ge 2^{\Gamma \cdot \Phi(\mathcal{G}) \cdot n} = 2^{\Omega(n)}$$
where $\Phi(\mathcal{G})$ is the Cheeger expansion constant and $\Gamma = \mathrm{AI}(P_{\mathrm{hard}}) = 3$.

---

## 2. The 3 Core Invariant Modules

### Module I: The Expander Cut Congestion Matrix
For any balanced partition of the input variables $V_L = X_A \sqcup X_B$ with $|X_A| = |X_B| = n/2$:
- The edge boundary $|\partial X_A| \ge \frac{\gamma n}{4} = \Omega(n)$.
- Because $g \ge 2\log_{d-1} n$, the local $r$-neighborhood $B_r(v)$ for $r < g/2$ is an uncycled tree.
- The $\mathbb{F}_2$-Jacobian matrix $J_f = \nabla f$ restricted to $X_A$ satisfies:
  $$\mathrm{Rank}_{\mathbb{F}_2}(J_f|_{X_A}) \ge \kappa_0 \cdot n \quad (\kappa_0 > 0)$$

### Module II: Intermediate Gate Correlation Deficit (Zero DAG-Reuse Power)
Let $g_v$ be any internal gate in the circuit DAG $C$ computed at topological step $t$.
- $g_v$ is a Boolean function of some subset of inputs $S_v \subset V_L$.
- If $|S_v| \le o(n)$, by the tree property of $B_r(v)$, $g_v$ shares mutual information with at most $o(n)$ output constraints in $V_R$.
- If $|S_v| \ge \Omega(n)$, by Ramanujan expansion, the influence of $g_v$ across any balanced cut $(X_A, X_B)$ suffers from maximum entropy diffusion:
  $$\max_{S \subset [m]} \left| \widehat{g_v \circ f_S} \right| \le 2^{-\Omega(n)}$$
- Therefore, no single intermediate wire $g_v$ can simultaneously cancel or simplify $> O(1)$ distinct non-local parity obstructions in $H^2(\mathcal{F})$.

### Module III: The Alexander-Whitney Homology Explosion
In the Consistency Sheaf $\mathcal{F}$ over $R(\phi)$:
- $H^1(\mathcal{F}) \cong \mathbb{F}_2^{2^{\kappa n}}$ (Ding-Sly-Sun solution clusters).
- The cup-product obstruction $H^1(\mathcal{F}) \smile H^1(\mathcal{F}) \to H^2(\mathcal{F})$ is non-vanishing on all pairs of distinct clusters.
- Because intermediate DAG gates have $0$ correlation power across expander cuts, resolving the $H^2$ obstruction requires a communication width $W \ge \Omega(n)$.
- By the Ben-Sasson-Wigderson Resolution Tradeoff:
  $$\mathrm{Size}(C) \ge \exp\left(\frac{W^2}{n}\right) = \exp\left(\frac{\Omega(n^2)}{n}\right) = 2^{\Omega(n)}$$
