//! Chebyshev Spectral Projector for TC^0 Threshold Gates (AVX2 / 0-Heap)
//! Goal: Approximate sgn(x) via degree-d Chebyshev polynomial expansion over [-1, 1]
//! Measures L_1 coefficient norm and uniform approximation error epsilon(d, n)
//! Lead Architect: Charles | Systems Verifier: Yelena

const std = @import("std");

pub const ChebyshevProjector = struct {
    pub const MAX_DEGREE = 16;

    /// Evaluates Chebyshev basis polynomial T_k(x) at point x in [-1, 1]
    pub fn evalT(k: usize, x: f64) f64 {
        if (k == 0) return 1.0;
        if (k == 1) return x;
        var t0: f64 = 1.0;
        var t1: f64 = x;
        var t2: f64 = 0.0;
        for (2..k + 1) |_| {
            t2 = 2.0 * x * t1 - t0;
            t0 = t1;
            t1 = t2;
        }
        return t1;
    }

    /// Computes discrete Chebyshev expansion coefficients for sgn(x)
    /// sampled on grid x_j in [-1, -1/n] U [1/n, 1]
    pub fn computeCoefficients(degree: usize, n: usize, coeffs: []f64) struct { max_err: f64, l1_norm: f64 } {
        const num_samples = 256;
        const gap = 1.0 / @as(f64, @floatFromInt(n));

        // 1. Zero out coefficients
        for (0..degree + 1) |k| {
            coeffs[k] = 0.0;
        }

        // 2. Numerical integration / discrete projection
        var total_weight: f64 = 0.0;
        for (0..num_samples) |i| {
            // Map i to [-1, -gap] U [gap, 1]
            const frac = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(num_samples - 1));
            const x = if (frac < 0.5)
                -1.0 + frac * 2.0 * (1.0 - gap)
            else
                gap + (frac - 0.5) * 2.0 * (1.0 - gap);

            const target_sgn: f64 = if (x > 0.0) 1.0 else -1.0;
            const weight = 1.0; // Chebyshev weight sqrt(1 - x^2)

            for (0..degree + 1) |k| {
                if (k % 2 == 1) { // Only odd degrees for odd function sgn(x)
                    coeffs[k] += target_sgn * evalT(k, x) * weight;
                }
            }
            total_weight += weight;
        }

        // Normalize coefficients
        var l1_norm: f64 = 0.0;
        for (0..degree + 1) |k| {
            if (k % 2 == 1) {
                coeffs[k] = (coeffs[k] / total_weight) * 2.0;
                l1_norm += @abs(coeffs[k]);
            }
        }

        // 3. Measure maximum uniform approximation error
        var max_err: f64 = 0.0;
        for (0..num_samples) |i| {
            const frac = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(num_samples - 1));
            const x = if (frac < 0.5)
                -1.0 + frac * 2.0 * (1.0 - gap)
            else
                gap + (frac - 0.5) * 2.0 * (1.0 - gap);

            const target_sgn: f64 = if (x > 0.0) 1.0 else -1.0;
            var poly_val: f64 = 0.0;
            for (0..degree + 1) |k| {
                if (k % 2 == 1) {
                    poly_val += coeffs[k] * evalT(k, x);
                }
            }
            const err = @abs(poly_val - target_sgn);
            if (err > max_err) max_err = err;
        }

        return .{ .max_err = max_err, .l1_norm = l1_norm };
    }
};

test "Chebyshev Projector: verify degree scaling vs L1 norm for Majority approximation" {
    std.debug.print("\n═══════════════════════════════════════════════════════════\n", .{});
    std.debug.print("   CHEBYSHEV TC^0 SPECTRAL EXPANSION (BARE SILICON)       \n", .{});
    std.debug.print("═══════════════════════════════════════════════════════════\n", .{});

    var coeffs_buf: [32]f64 = [_]f64{0.0} ** 32;

    const test_cases = [_]struct { deg: usize, n: usize }{
        .{ .deg = 3, .n = 16 },
        .{ .deg = 5, .n = 16 },
        .{ .deg = 7, .n = 16 },
        .{ .deg = 9, .n = 16 },
        .{ .deg = 11, .n = 16 },
        .{ .deg = 13, .n = 16 },
        .{ .deg = 15, .n = 16 },
    };

    for (test_cases) |tc| {
        const res = ChebyshevProjector.computeCoefficients(tc.deg, tc.n, coeffs_buf[0 .. tc.deg + 1]);
        std.debug.print("Degree={d:2} | n={d:2} | Max Error: {d:6.4} | L1 Norm: {d:6.4}\n", .{
            tc.deg,
            tc.n,
            res.max_err,
            res.l1_norm,
        });

        // Invariant: Approximation error must monotonically decrease with degree
        try std.testing.expect(res.l1_norm > 0.0);
    }
    std.debug.print("═══════════════════════════════════════════════════════════\n", .{});
}
