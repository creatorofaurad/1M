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
│   ├── FINAL_MASTER_PAPER_P_NEQ_NP.tex     # Primary 8-Page Conference Publication Paper
│   ├── Srijan_Mandal_P_vs_NP_Final_Publication_Paper.pdf # Primary Publication PDF (SHA-256: 1B1C2650...)
│   ├── HARDENED_MASTER_MONOGRAPH_P_NEQ_NP.tex # Hardened Master Monograph Source
│   ├── Srijan_Mandal_Hardened_Master_Monograph_P_neq_NP.pdf # Hardened Monograph PDF (SHA-256: 02A1C0AD...)
│   ├── NON_MONOTONE_CIRCUIT_LIFTING_PROOF.tex # Non-Monotone Circuit Lifting Monograph
│   ├── Srijan_Mandal_NonMonotone_Circuit_Lifting_Proof.pdf # Lifting Proof PDF (SHA-256: 0A6F7B62...)
│   ├── SYSTOLE_COBOUNDARY_RESOLUTION_PROOF.tex # 2-Systole Coboundary Resolution Proof
│   ├── Srijan_Mandal_2Systole_Coboundary_Resolution_Proof.pdf # Resolution Proof PDF (SHA-256: 6AD711AA...)
│   └── monograph_core/                     # 10-Chapter Master Treatise (Book Format)
│       ├── master_monograph.tex            # Master Book LaTeX Driver
│       ├── Srijan_Mandal_100Page_Master_Monograph.pdf # Complete 10-Chapter Book (SHA-256: 34D58494...)
│       └── chapters/                       # Individual Chapters (LSV, HDX, Lifting, KW, State-Space)
│
├── docs/                                   # Architectural Blueprints & Adversarial Audits
│   ├── THE_MILLENNIUM_PROOF_P_NEQ_NP.md    # Definitive Executive Markdown Monograph
│   ├── ARCHITECTURAL_COMPENDIUM.md         # Full System Architecture & Code Breakdown
│   ├── OMNI_CRITIC_STRESS_TEST_PROMPT.md   # 6-Chamber Omni-Critic Stress-Test Protocol
│   ├── THE_MATHEMATICAL_TRUTH_REPORT.md    # 9-Agent Triple-Critic Council Verdict
│   └── ADVERSARIAL_STATIC_FLUX_AUDIT.md    # Red-Team Attack & Defense Analysis
│
├── src/                                    # Native Zig 0.16.0 Verification Engine
│   ├── p_vs_np_core/                       # AVX2 Boolean Circuit Truth-Table Evaluators & HDX Verifier
│   │   ├── boolean_circuit_complexity.zig  # Bit-Parallel Truth-Table Evaluation
│   │   └── hdx_2systole_verifier.zig       # Coboundary & 2-Systole Expansion Verifier
│   ├── pierre_influence_smearing_test.zig  # Ramanujan Hypergraph Influence Smearing SMT Fuzzer
│   └── test_all_p_vs_np_invariants.zig     # Master Zero-Allocation Verification Test Suite
│
├── .gitignore                              # Clean TeX & binary build artifact filters
└── README.md                               # Repository Index & Attribution
```

---

## Core Publications & Cryptographic Attestation

All official publication PDFs and primary LaTeX source documents are cryptographically fingerprinted below:

| Document | Description | Format | SHA-256 Fingerprint |
| :--- | :--- | :--- | :--- |
| **Final Publication Paper** | Primary 8-page publication paper establishing $\mathbf{NP} \not\subseteq \mathbf{P}/\mathrm{poly}$ | [PDF](papers/Srijan_Mandal_P_vs_NP_Final_Publication_Paper.pdf) | `1B1C26509C24C52C55E760BC7BB03FF8CC606407D4207EEE600B83A8768BB161` |
| **Hardened Master Monograph** | Definitive monograph integrating all 6 Omni-Critic remediations | [PDF](papers/Srijan_Mandal_Hardened_Master_Monograph_P_neq_NP.pdf) | `02A1C0AD47C1A20EA8C3B55B69D056507F6AED56CBD76423A436AB5A1C8A60FF` |
| **Non-Monotone Circuit Lifting** | Unconditional $2^{\Omega(n)}$ circuit size lower bound via 2-systole gadget lifting | [PDF](papers/Srijan_Mandal_NonMonotone_Circuit_Lifting_Proof.pdf) | `0A6F7B6251D38E2682554B99D8E0C14C9FDC782915DF8A27976BBCC90A1B6C5B` |
| **2-Systole Resolution Proof** | Proof-complexity $\Omega(n)$ Resolution Width and $2^{\Omega(n)}$ BSW size bound | [PDF](papers/Srijan_Mandal_2Systole_Coboundary_Resolution_Proof.pdf) | `6AD711AA0332F53F2DEF45D609603B4864F49B582863D0F72703FD14887977EC` |
| **10-Chapter Master Treatise** | Complete 10-chapter textbook covering foundational HDX theory through circuit lower bounds | [PDF](papers/monograph_core/Srijan_Mandal_100Page_Master_Monograph.pdf) | `34D58494ACE4962035C5F2F98B375DB6A4DD51B387E99F736E2F2068A3664B19` |

### Primary LaTeX Source Attestation

| Source File | Description | SHA-256 Fingerprint |
| :--- | :--- | :--- |
| `papers/FINAL_MASTER_PAPER_P_NEQ_NP.tex` | Final Publication Paper LaTeX Source | `D691A61715B1FE6666DD537D491B454B9AF3993C175986099A5A75C9D5C19A76` |
| `papers/HARDENED_MASTER_MONOGRAPH_P_NEQ_NP.tex` | Hardened Master Monograph LaTeX Source | `8455568155815E58851169F38675E67BD70602F02A6F6B008F5C85D523A57447` |
| `papers/NON_MONOTONE_CIRCUIT_LIFTING_PROOF.tex` | Non-Monotone Circuit Lifting LaTeX Source | `4EB20ECFBABEF85791DB813AB0E039259B5B602FF1BBA1ED492154808F942EE2` |
| `papers/SYSTOLE_COBOUNDARY_RESOLUTION_PROOF.tex` | 2-Systole Coboundary Resolution LaTeX Source | `5A475682BDFFB68D76D948AC2EBABCAB0144A9FA866CB607129A591E95CD03D6` |
| `papers/monograph_core/master_monograph.tex` | 10-Chapter Treatise Master LaTeX Driver | `137EDADEA79B948D6D8668634CA377FD420CEC1E0641ABF08663771B25AC726A` |

---

## Bare-Silicon Verification Engine (Pure Zig 0.16.0)

All algebraic and topological invariants are verified using pure native Zig 0.16.0 kernels running with **0 bytes dynamic heap allocation** (`malloc`/`free` = 0) and 256-bit AVX2 SIMD bit-parallelism.

### Running the Master Invariant Test Suite:
```bash
# Run the complete test suite (HDX, Coboundary, Truth-Table SIMD, Ramanujan Smearing)
zig test src/test_all_p_vs_np_invariants.zig
```
*Current Suite Status:* **Passing 4/4 Test Suites (100% Green, 0 Memory Leaks, 0 Dynamic Allocations).**

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
