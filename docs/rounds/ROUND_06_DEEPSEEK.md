# Adversarial Protocol Round 06: DeepSeek Output
Date: 2026-09-14
Status: De Morgan Formula Shrinkage Attack Proposed on MKtP.

Key Proposal:
- Target: De Morgan Formulas with shrinkage exponent $\Gamma = 2 - o(1)$.
- Strategy: Random restriction $\rho \sim \mathcal{R}_p$ reduces formula size $L(F \upharpoonright \rho) \le O(p^2 L) = o(N)$.
- Claimed Contradiction: Restricted MKtP still requires $\Omega(N^{1-\delta})$ size.

FATAL FLAW DISCOVERED BY YELENA:
- The "Constant Collapse Trap" of Random Restrictions on MKtP:
  When $p = N^{-\delta}$ (leaving $pN = N^{1-\delta}$ variables free), the restriction fixes $(1-p)N \approx N - N^{1-\delta}$ bits.
  If the fixed bits are chosen randomly, they contain $(1-p)N \approx N$ bits of Kolmogorov randomness.
  Since $(1-p)N \gg N/2$ (the threshold $\tau = N/2$), EVERY completion of the restricted truth table already has $Kt(f) > N/2$.
  Therefore, $(MKtP[s]) \upharpoonright \rho$ collapses to the CONSTANT FUNCTION 1!
  A constant function has formula size 1, completely resolving $L(F \upharpoonright \rho) \le o(N)$ with ZERO contradiction!
