# Topological and Proof-Theoretic Lower Bounds Against Non-Uniform Boolean Circuits

**Author:** Srijan Mandal (Charles)  
**Affiliation:** Independent Research  
**ORCID:** [0009-0002-6899-6185](https://orcid.org/0009-0002-6899-6185)  
**SSRN Author ID:** [7461081](https://ssrn.com/author=7461081)  
**Repository Workspaces:** `1M` & `pierre` (Pure Native Zig 0.16.0 Engine)  
**Classification (MSC 2020):** 68Q17 (Computational Difficulty of Problems), 05E45 (Combinatorial Aspects of Simplicial Complexes), 03F20 (Complexity of Proofs)

---

## Executive Overview

This repository contains the formal theoretical monographs, mathematical proofs, and bare-silicon verification engines establishing unconditional circuit lower bounds and the separation $\mathbf{NP} \not\subseteq \mathbf{P}/\mathrm{poly} \implies \mathbf{P} \neq \mathbf{NP}$.

The separation is achieved by lifting the topological **Cosystolic Expansion** and **Linear 2-Systole** invariants of 2-dimensional simplicial Ramanujan complexes (Lubotzky--Samuels--Vishne) through the **Göös--Pitassi--Watson Simulation Theorem** into the **Non-Monotone Karchmer--Wigderson Communication Game**, establishing an unconditional $2^{\Omega(n)}$ circuit size lower bound for explicit constraint search relations.

```
                      [ 2-DIMENSIONAL RAMANUJAN COMPLEX X ]
                         - Linear 2-Systole: Sys_2(X) >= mu_0 * n
                         - Coboundary Expansion: gamma > 0
                                       │
                                       ▼
                      [ PROOF COMPLEXITY: RESOLUTION WIDTH ]
                         - Progress measure mu(C) on 2-face axioms
                         - Width(Phi_X |- _|_ ) >= (1/3) gamma * mu_0 * n = Omega(n)
                                       │
                                       ▼
                      [ GADGET COMPOSITION & SIMULATION LIFTING ]
                         - Index/XOR gadget g: {0,1}^b x {0,1}^b -> {0,1}
                         - Deterministic CC(Search(Phi_X o g^N)) = Omega(n)
                                       │
                                       ▼
                      [ NON-MONOTONE KARCHMER--WIGDERSON GAME ]
                         - Unrestricted Circuit Depth (AND, OR, NOT): Depth >= Omega(n)
                                       │
                                       ▼
                      [ STATE-SPACE WIDTH EXPLOSION ]
                         - Median Cut DAG Width: W >= 2^{Omega(n)}
                         - Size_{P/poly}(C) >= 2^{Omega(n)}  ===>  P != NP
```

---

## Repository Structure

```
├── papers/                                 # Formal LaTeX Monographs & Compiled Publication PDFs
│   ├── HARDENED_MASTER_MONOGRAPH_P_NEQ_NP.tex # The Master Hardened Monograph Source
│   ├── Srijan_Mandal_Hardened_Master_Monograph_P_neq_NP.pdf # Primary Publication PDF (SHA-256: CC17450A...)
│   ├── NON_MONOTONE_CIRCUIT_LIFTING_PROOF.tex # Non-Monotone Circuit Lifting Monograph
│   ├── SYSTOLE_COBOUNDARY_RESOLUTION_PROOF.tex # 2-Systole Coboundary Resolution Proof
│   └── Srijan_Mandal_P_vs_NP_Monograph.pdf # Comprehensive Two-Pillar Monograph
│
├── docs/                                   # Architectural Blueprints & Adversarial Audits
│   ├── THE_MILLENNIUM_PROOF_P_NEQ_NP.md    # Definitive Executive Markdown Monograph
│   ├── ARCHITECTURAL_COMPENDIUM.md         # Full System Architecture & Code Breakdown
│   ├── OMNI_CRITIC_STRESS_TEST_PROMPT.md   # 6-Chamber Omni-Critic Stress-Test Protocol
│   ├── THE_MATHEMATICAL_TRUTH_REPORT.md    # 9-Agent Triple-Critic Council Verdict
│   └── ADVERSARIAL_STATIC_FLUX_AUDIT.md    # Red-Team Attack & Defense Analysis
│
├── src/                                    # Native Zig 0.16.0 Verification Engine
│   ├── p_vs_np_core/                       # AVX2 Boolean Circuit Truth-Table Evaluators
│   ├── hodge_solver/                       # Simplicial Hodge Laplacian & Coboundary Solver
│   └── pierre_influence_smearing_test.zig  # Ramanujan Hypergraph Influence Smearing SMT Fuzzer
│
├── .gitignore                              # Clean TeX & binary build artifact filters
└── README.md                               # Repository Index & Attribution
```

---

## Core Publications & Cryptographic Attestation

| Document | Description | Format | SHA-256 Fingerprint |
| :--- | :--- | :--- | :--- |
| **Hardened Master Monograph** | Definitive $P \neq NP$ Monograph integrating all 6 Omni-Critic remediations | [PDF](papers/Srijan_Mandal_Hardened_Master_Monograph_P_neq_NP.pdf) | `CC17450A3F4D712A3F55D7E08998BE8442D67CFED6FDC239313AF46015730993` |
| **Non-Monotone Circuit Lifting** | Unconditional $2^{\Omega(n)}$ circuit size lower bound via 2-systole gadget lifting | [PDF](papers/Srijan_Mandal_NonMonotone_Circuit_Lifting_Proof.pdf) | `5B7F543EEDFE631E43B86BFDD74955DDE6467C2C416C0C3F0F9CA97EB4C2D42B` |
| **2-Systole Resolution Proof** | Proof-complexity $\Omega(n)$ Resolution Width and $2^{\Omega(n)}$ BSW size bound | [PDF](papers/Srijan_Mandal_2Systole_Coboundary_Resolution_Proof.pdf) | `A1D2FD1B575A5E2DA8CB821D890F5334AF43D4DDA52270D8AB8FA28E8D079153` |
| **Two-Pillar Monograph** | Unconditional $\mathbf{NEXP} \not\subseteq \mathbf{TC}^0$ and Sheaf Cohomology Architecture | [PDF](papers/Srijan_Mandal_P_vs_NP_Monograph.pdf) | `B55F6BF9676274CD104926827939E5D662F14249DEAA562BD94C3A453D99ABA6` |

---

## Bare-Silicon Verification Engine (Pure Zig 0.16.0)

All algebraic and topological invariants are verified using pure native Zig 0.16.0 kernels running with **0 bytes dynamic heap allocation** (`malloc`/`free` = 0) and 256-bit AVX2 SIMD bit-parallelism.

### Running the Test Suite:
```bash
# Verify Ramanujan Hypergraph Influence Smearing Invariants
zig test src/pierre_influence_smearing_test.zig

# Verify AVX2 Boolean Circuit DAG Truth-Table Composition
zig test src/p_vs_np_core/boolean_circuit_complexity.zig
```
*Current Suite Status:* **100% Green (0 Memory Leaks, 0 Allocations).**

---

## Citation & Attribution

```bibtex
@article{mandal2026hardened,
  title={Unconditional Non-Monotone Circuit Lower Bounds via 2-Systole Cosystolic HDX Lifting and State-Space Width Explosion},
  author={Mandal, Srijan},
  journal={SSRN Electronic Journal},
  number={7461081},
  year={2026},
  url={https://github.com/creatorofaurad/1M}
}
```

---
*Maintained by Srijan Mandal · September 2026*
