# Adversarial Protocol Round 07: DeepSeek Output
Date: 2026-09-14
Status: Nechiporuk Block-Entropy Partition on MKtP Proposed.

FATAL INFORMATION-THEORETIC HOLE CAUGHT BY YELENA:
- The "Zero-Prefix Compression Trap" in Nechiporuk on MKtP:
  DeepSeek sets block size $b = N^\alpha$ with $\alpha < 1$ (e.g. $\alpha = 0.5$).
  It fixes all variables in $[N] \setminus Y_i$ to 0.
  It claims $\mathrm{sub}_{Y_i}(F) \ge 2^{\Omega(b)}$.
  
  MATHEMATICAL REFUTATION:
  When $[N] \setminus Y_i$ is fixed to 0, the full $N$-bit truth table contains at most $b = N^\alpha$ non-zero bits.
  The Kolmogorov complexity of ANY string with only $N^\alpha$ non-zero bits is at most $N^\alpha \log N + O(1)$.
  Since $\alpha < 1$, $N^\alpha \log N \ll N/2$ (the MKtP threshold $\tau = N/2$).
  Therefore, $Kt_s(z) < N/2$ for EVERY SINGLE ONE of the $2^b$ assignments to $Y_i$!
  Thus, $\mathsf{MKtP}[s](z \oplus \mathrm{pad}_i) \equiv 0$ (IDENTICALLY CONSTANT ZERO) for ALL inputs on the subcube!
  The subfunction count is $\mathrm{sub}_{Y_i}(F) = 1$, NOT $2^{\Omega(b)}$!
