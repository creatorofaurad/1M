// TOPOLOGICAL FOURIER ENTROPY & HOMOLOGY DUAL KERNEL
// Pure Zig 0.16.0 - ReleaseFast
// 0 Bytes dynamic heap allocation (malloc/free = 0)
// Computes combined invariant Psi(f) = max(0, chi(Sigma_f)) * H(f_hat) for m=4 (N=16)

const std = @import("std");
const top_mod = @import("boolean_simplicial_topology_engine.zig");

pub const M_VARS: usize = 4;
pub const N_LEN: usize = 1 << M_VARS; // 16

/// Computes the exact Walsh-Hadamard Fourier spectrum and Fourier entropy
pub fn computeFourierEntropy(truth_table: u16) f32 {
    // 1. Convert truth table to +/- 1 signed vector (-1 if f(x)=1, +1 if f(x)=0)
    var f_signed: [N_LEN]f32 = undefined;
    for (0..N_LEN) |i| {
        const bit = (truth_table >> @as(u4, @intCast(i))) & 1;
        f_signed[i] = if (bit == 1) -1.0 else 1.0;
    }

    // 2. Fast Walsh-Hadamard Transform in-place
    var step: usize = 1;
    while (step < N_LEN) : (step <<= 1) {
        var i: usize = 0;
        while (i < N_LEN) : (i += step << 1) {
            for (0..step) |j| {
                const u = f_signed[i + j];
                const v = f_signed[i + step + j];
                f_signed[i + j] = u + v;
                f_signed[i + step + j] = u - v;
            }
        }
    }

    // 3. Normalize Fourier coefficients: f_hat(s) = f_signed[s] / N
    // Parseval's identity: sum_s f_hat(s)^2 = 1
    var entropy: f32 = 0.0;
    const eps: f32 = 1e-7;

    for (0..N_LEN) |s| {
        const coeff = f_signed[s] / @as(f32, @floatFromInt(N_LEN));
        const p = coeff * coeff;
        if (p > eps) {
            entropy -= p * @log2(p);
        }
    }

    return entropy;
}

/// Computes the combined Topological-Fourier Invariant Psi(f) = max(0, chi) * H(f_hat)
pub fn computeTopologicalFourierInvariant(truth_table: u16) f32 {
    const chi = top_mod.computeEulerCharacteristic(truth_table);
    const chi_pos: f32 = if (chi > 0) @as(f32, @floatFromInt(chi)) else 0.0;
    const fourier_ent = computeFourierEntropy(truth_table);
    return chi_pos * fourier_ent;
}

test "Topological Fourier Dual Invariant Test on Projections vs Parity vs Non-Linear Dispersion" {
    // 1. Single coordinate projection x_0 (0xAAAA):
    const x0_tt: u16 = 0xAAAA;
    const x0_psi = computeTopologicalFourierInvariant(x0_tt);
    // Simple 1-gate function has Psi = 0.0
    try std.testing.expectEqual(@as(f32, 0.0), x0_psi);

    // 2. Linear Parity function (0x6996):
    const parity_tt: u16 = 0x6996;
    const parity_psi = computeTopologicalFourierInvariant(parity_tt);
    // CRITICAL TRIUMPH: Parity has high chi (+8) but ZERO Fourier entropy (single spike)
    // Therefore, Psi(Parity) = 8.0 * 0.0 = 0.0! The Parity trap is 100% neutralized!
    try std.testing.expectEqual(@as(f32, 0.0), parity_psi);

    // 3. Non-Linear Bent / Max-Entropy Inner Product mod 2:
    // IP(u0, u1, v0, v1) = (u0 & v0) ^ (u1 & v1) -> truth table 0x8E8E or bent function
    // Bent functions have completely flat Fourier spectrum (H = 4.0 bits) and positive chi
    // Constructing a bent function on 4 variables: f(x) = x0*x1 ^ x2*x3
    var bent_tt: u16 = 0;
    for (0..16) |x| {
        const x0 = (x >> 0) & 1;
        const x1 = (x >> 1) & 1;
        const x2 = (x >> 2) & 1;
        const x3 = (x >> 3) & 1;
        const bit = (x0 & x1) ^ (x2 & x3);
        bent_tt |= (@as(u16, @intCast(bit)) << @as(u4, @intCast(x)));
    }

    const bent_ent = computeFourierEntropy(bent_tt);
    // Bent function has maximal Fourier entropy = 4.0 bits (log2(16))
    try std.testing.expect(bent_ent >= 3.9);
}
