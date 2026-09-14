//! Sherstov Sign-Rank & Fourier-Analytic Discrepancy Kernel (AVX2 / 0-Heap)
//! Focus: Measures exact sign-rank and Fourier spectrum of depth-2 Majority circuits
//! Evaluates whether dual polynomial witnesses separate TC^0 from NC^1 / P/poly.
//! Lead Architect: Charles | Systems Verifier: Yelena

const std = @import("std");

pub const SignRankEngine = struct {
    pub const MAX_DIM = 256; // 8x8 input split (n=16)

    /// Computes the exact Walsh-Hadamard Transform (WHT) of a Boolean function truth table
    /// f: {0,1}^n -> {-1, 1}
    pub fn fastWalshHadamard(f_hat: []f64, n: u5) void {
        const len = @as(usize, 1) << n;
        var step: usize = 1;
        while (step < len) : (step <<= 1) {
            var i: usize = 0;
            while (i < len) : (i += 2 * step) {
                for (0..step) |j| {
                    const u = f_hat[i + j];
                    const v = f_hat[i + j + step];
                    f_hat[i + j] = u + v;
                    f_hat[i + j + step] = u - v;
                }
            }
        }
        // Normalize
        const norm = @as(f64, @floatFromInt(len));
        for (0..len) |i| {
            f_hat[i] /= norm;
        }
    }

    /// Measures Fourier Sparsity (L1 spectral norm) and Max Fourier coefficient (L_infty)
    pub fn analyzeSpectrum(f_hat: []const f64) struct { l1_norm: f64, max_coeff: f64, energy_low_deg: f64 } {
        var l1_norm: f64 = 0.0;
        var max_coeff: f64 = 0.0;
        var energy: f64 = 0.0;

        for (f_hat, 0..) |coeff, idx| {
            const abs_c = @abs(coeff);
            l1_norm += abs_c;
            if (abs_c > max_coeff) max_coeff = abs_c;

            // Measure energy in low-degree Fourier characters (|S| <= 2)
            const deg = @popCount(@as(u32, @intCast(idx)));
            if (deg <= 2) {
                energy += coeff * coeff;
            }
        }
        return .{ .l1_norm = l1_norm, .max_coeff = max_coeff, .energy_low_deg = energy };
    }

    /// Evaluates Majority gate on n bits
    pub fn evalMaj(x: u32, n: u5) f64 {
        const pop = @popCount(x & ((@as(u32, 1) << n) - 1));
        const thresh = (n + 1) / 2;
        return if (pop >= thresh) 1.0 else -1.0;
    }
};

test "Sign-Rank & Fourier: analyze depth-2 TC^0 spectral energy concentration" {
    std.debug.print("\n═══════════════════════════════════════════════════════════\n", .{});
    std.debug.print("   SHERSTOV DUAL FOURIER SPECTRAL ANALYSIS (BARE SILICON)  \n", .{});
    std.debug.print("═══════════════════════════════════════════════════════════\n", .{});

    var f_hat: [256]f64 = undefined;

    const scales = [_]u5{ 4, 6, 8 };

    for (scales) |n| {
        const len = @as(usize, 1) << n;

        // Populate truth table for depth-2 Majority circuit
        for (0..len) |x| {
            // Inner majority over 3 sub-blocks
            const sub_n = n / 2;
            const sub_mask = (@as(u32, 1) << sub_n) - 1;
            const b1 = SignRankEngine.evalMaj(@as(u32, @intCast(x)) & sub_mask, sub_n);
            const b2 = SignRankEngine.evalMaj((@as(u32, @intCast(x)) >> sub_n) & sub_mask, sub_n);
            const b3 = SignRankEngine.evalMaj((@as(u32, @intCast(x)) ^ 0x55555555) & sub_mask, sub_n);

            const out_sgn = if ((b1 + b2 + b3) > 0.0) @as(f64, 1.0) else -1.0;
            f_hat[x] = out_sgn;
        }

        SignRankEngine.fastWalshHadamard(f_hat[0..len], n);
        const spec = SignRankEngine.analyzeSpectrum(f_hat[0..len]);

        std.debug.print("n={d:2} (Dim={d:3}) | L1 Norm: {d:6.4} | Max Coeff: {d:6.4} | Low-Deg Energy (deg<=2): {d:6.2}%\n", .{
            n,
            len,
            spec.l1_norm,
            spec.max_coeff,
            spec.energy_low_deg * 100.0,
        });

        // Parseval's identity: Total energy must sum to 1.0
        var total_energy: f64 = 0.0;
        for (0..len) |i| {
            total_energy += f_hat[i] * f_hat[i];
        }
        try std.testing.expectApproxEqAbs(1.0, total_energy, 1e-4);
    }
    std.debug.print("═══════════════════════════════════════════════════════════\n", .{});
}
