# 1M: Unconditional Circuit Lower Bounds & Complexity Research Engine

**Author:** Srijan Mandal ([ORCID: 0009-0002-6899-6185](https://orcid.org/0009-0002-6899-6185))  
**Primary Manuscript:** `main.tex` | `Srijan_Mandal_NEXP_TC0_Separation.pdf`  
**SSRN Abstract ID:** [7461081](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=7461081)  

---

## 🏛️ Repository Architecture

```text
C:\Users\srija\Projects\1M/
├── main.tex                                # The definitive LaTeX publication manuscript
├── Srijan_Mandal_NEXP_TC0_Separation.pdf   # Compiled, publication-ready PDF preprint
├── src/                                    # Native Zig 0.16.0 Bare-Silicon Test Suites (0 heap bytes)
│   ├── f2_constant_degree_arithmetizer.zig # Level 3: F_2 degree-3 arithmetization & 16-query AKR tester
│   ├── pcp_composition_falsifier.zig       # Affine invariance of Fourier spectra (||D o q||_1 <= ||D||_1)
│   ├── tc0_deterministic_capp.zig          # Galois LFSR small-bias generator & CAPP evaluator
│   ├── tc0_kushilevitz_mansour_solver.zig  # Prefix-tree branch-and-bound Fourier solver
│   ├── tc0_depth_d_spectral_tracker.zig    # Depth d=1..4 Fourier L_1 norm growth tracking
│   ├── tableau_fourier_falsifier.zig       # Space-time tableau vs Inner Product spectral profiler
│   └── ...                                 # Formal Lean 4 and SIMD invariant provers
└── docs/                                   # Historical research trajectories & referee audits
    ├── rounds/                             # Rounds 01–81 research logs and formal breakthroughs
    ├── reports/                            # Technical reports, ontological models, and summaries
    └── prompts/                            # Multi-agent DSAC referee and verification prompts
```

---

## ⚡ Native Silicon Verification
To compile and execute the entire native verification stack (0 memory allocations, `ReleaseFast`):

```powershell
# Run the Level 3 F_2 Constant-Degree Holographic Verifier Test
zig test src/f2_constant_degree_arithmetizer.zig -O ReleaseFast

# Run the Affine Query Spectrum Invariance Test
zig test src/pcp_composition_falsifier.zig -O ReleaseFast

# Run the Galois Small-Bias CAPP Derandomizer Test
zig test src/tc0_deterministic_capp.zig -O ReleaseFast
```
