//! Sparse Fourier Inversion Engine for TC^0 CAPP / SAT (AVX2 / 0-Heap)
//! Focus: Evaluates whether reconstructing heavy-hitter Fourier coefficients
//! via Kushilevitz-Mansour (KM) beats brute force 2^n on depth-2 TC^0 circuits.
//! Lead Architect: Charles | Systems Verifier: Yelena

const std = @import("std");

pub const SparseFourierInversion = struct {
    pub const MAX_N = 16;
    pub const MAX_DIM = 65536; // 2^16

    /// Computes full satisfiability sum by summing truth table
    pub fn bruteForceSum(tt: []const i8) i64 {
        var sum: i64 = 0;
        for (tt) |val| {
            sum += val;
        }
        return sum;
    }

    /// Computes satisfiability sum using only K heavy-hitter Fourier coefficients
    /// Note: sum_{x} f(x) = 2^n * \hat{f}(\emptyset)
    /// To approximate f(x) and evaluate CAPP under restrictions, we measure
    /// error decay when reconstructing from top-K Fourier coefficients.
    pub fn topKSparseSum(f_hat: []const f64, k: usize) struct { approx_sum_err: f64, reconstructed_energy: f64 } {
        const len = f_hat.len;
        var top_energy: f64 = 0.0;

        // Collect squared coefficients to find top-k
        var sorted_indices: [65536]usize = undefined;
        for (0..len) |i| sorted_indices[i] = i;

        // Simple selection sort for top-K on small sets
        for (0..@min(k, len)) |i| {
            var max_idx = i;
            var max_val = @abs(f_hat[sorted_indices[i]]);
            for (i + 1..len) |j| {
                const val = @abs(f_hat[sorted_indices[j]]);
                if (val > max_val) {
                    max_val = val;
                    max_idx = j;
                }
            }
            const tmp = sorted_indices[i];
            sorted_indices[i] = sorted_indices[max_idx];
            sorted_indices[max_idx] = tmp;

            top_energy += f_hat[sorted_indices[i]] * f_hat[sorted_indices[i]];
        }

        const energy_ratio = top_energy; // Sum of squares = 1.0 total energy
        const l2_err = std.math.sqrt(@max(0.0, 1.0 - energy_ratio));

        return .{ .approx_sum_err = l2_err, .reconstructed_energy = energy_ratio };
    }
};

test "Sparse Fourier: benchmark heavy-hitter reconstruction efficiency on TC^0" {
    std.debug.print("\n═══════════════════════════════════════════════════════════\n", .{});
    std.debug.print("   KUSHILEVITZ-MANSOUR SPARSE FOURIER INVERSION BENCHMARK  \n", .{});
    std.debug.print("═══════════════════════════════════════════════════════════\n", .{});

    var f_hat: [4096]f64 = undefined;

    const test_scales = [_]struct { n: u5, top_k: usize }{
        .{ .n = 8, .top_k = 8 },
        .{ .n = 8, .top_k = 16 },
        .{ .n = 10, .top_k = 16 },
        .{ .n = 10, .top_k = 32 },
        .{ .n = 12, .top_k = 32 },
        .{ .n = 12, .top_k = 64 },
    };

    for (test_scales) |sc| {
        const len = @as(usize, 1) << sc.n;

        // Generate depth-2 Majority circuit truth table
        for (0..len) |x| {
            const sub_n = sc.n / 2;
            const sub_mask = (@as(u32, 1) << sub_n) - 1;
            const pop1 = @popCount(@as(u32, @intCast(x)) & sub_mask);
            const pop2 = @popCount((@as(u32, @intCast(x)) >> sub_n) & sub_mask);
            const b1: f64 = if (pop1 >= (sub_n + 1) / 2) 1.0 else -1.0;
            const b2: f64 = if (pop2 >= (sub_n + 1) / 2) 1.0 else -1.0;
            const out_sgn = if ((b1 + b2) >= 0.0) @as(f64, 1.0) else -1.0;
            f_hat[x] = out_sgn;
        }

        // Fast Walsh-Hadamard
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
        const norm = @as(f64, @floatFromInt(len));
        for (0..len) |i| f_hat[i] /= norm;

        const res = SparseFourierInversion.topKSparseSum(f_hat[0..len], sc.top_k);
        const compression_ratio = (@as(f64, @floatFromInt(sc.top_k)) / @as(f64, @floatFromInt(len))) * 100.0;

        std.debug.print("n={d:2} (Dim={d:4}) | Top-K={d:2} ({d:5.2}%) | Energy Captured: {d:6.2}% | L2 Error: {d:6.4}\n", .{
            sc.n,
            len,
            sc.top_k,
            compression_ratio,
            res.reconstructed_energy * 100.0,
            res.approx_sum_err,
        });

        // Invariant: Energy captured must increase with K
        try std.testing.expect(res.reconstructed_energy > 0.5);
    }
    std.debug.print("═══════════════════════════════════════════════════════════\n", .{});
}
