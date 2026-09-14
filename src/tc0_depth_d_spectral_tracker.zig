//! Depth-d TC^0 Spectral Energy & L1 Norm Growth Tracker (AVX2 / 0-Heap)
//! Measures exact Fourier L1 norm ||C_d||_1 and low-degree energy concentration
//! across depths d = 1, 2, 3, 4 for n in [4, 12] on bare silicon.
//! Lead Architect: Charles | Systems Verifier: Yelena

const std = @import("std");

pub const DepthDEngine = struct {
    pub const MAX_N = 12;
    pub const MAX_DIM = 4096;

    /// Evaluates Majority on an arbitrary bitmask
    pub fn evalMaj(x: u32, mask: u32) f64 {
        const pop = @popCount(x & mask);
        const count = @popCount(mask);
        const thresh = (count + 1) / 2;
        return if (pop >= thresh) 1.0 else -1.0;
    }

    /// Evaluates a multi-layer depth-d Majority circuit on input x in {0,1}^n
    pub fn evalDepthD(x: u32, n: u5, depth: usize) f64 {
        if (depth <= 1) {
            const mask = (@as(u32, 1) << n) - 1;
            return evalMaj(x, mask);
        }

        // Depth 2: Outer MAJ of 3 sub-block MAJ gates
        const sub_n = @max(1, n / 2);
        const sub_mask = (@as(u32, 1) << @intCast(sub_n)) - 1;
        const b1 = evalMaj(x & sub_mask, sub_mask);
        const b2 = evalMaj((x >> @intCast(sub_n)) & sub_mask, sub_mask);
        const b3 = evalMaj((x ^ 0x55555555) & sub_mask, sub_mask);
        const d2_out: f64 = if ((b1 + b2 + b3) > 0.0) @as(f64, 1.0) else -1.0;

        if (depth == 2) return d2_out;

        // Depth 3: Outer MAJ of 3 depth-2 circuits with perturbed input wire masks
        const b3_1 = evalDepthD(x ^ 0x00000000, n, 2);
        const b3_2 = evalDepthD(x ^ 0x33333333, n, 2);
        const b3_3 = evalDepthD(x ^ 0x0F0F0F0F, n, 2);
        const d3_out: f64 = if ((b3_1 + b3_2 + b3_3) > 0.0) @as(f64, 1.0) else -1.0;

        if (depth == 3) return d3_out;

        // Depth 4: Outer MAJ of 3 depth-3 circuits
        const b4_1 = evalDepthD(x ^ 0x00000000, n, 3);
        const b4_2 = evalDepthD(x ^ 0x5A5A5A5A, n, 3);
        const b4_3 = evalDepthD(x ^ 0xA5A5A5A5, n, 3);
        return if ((b4_1 + b4_2 + b4_3) > 0.0) @as(f64, 1.0) else -1.0;
    }

    /// Fast Walsh-Hadamard Transform
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
        const norm = @as(f64, @floatFromInt(len));
        for (0..len) |i| f_hat[i] /= norm;
    }

    pub fn measureL1AndEnergy(f_hat: []const f64) struct { l1_norm: f64, low_deg_energy: f64, max_coeff: f64 } {
        var l1_norm: f64 = 0.0;
        var low_deg_energy: f64 = 0.0;
        var max_coeff: f64 = 0.0;

        for (f_hat, 0..) |c, idx| {
            const abs_c = @abs(c);
            l1_norm += abs_c;
            if (abs_c > max_coeff) max_coeff = abs_c;

            const deg = @popCount(@as(u32, @intCast(idx)));
            if (deg <= 2) {
                low_deg_energy += c * c;
            }
        }
        return .{ .l1_norm = l1_norm, .low_deg_energy = low_deg_energy, .max_coeff = max_coeff };
    }
};

test "Depth-d TC0: sweep depths d=1,2,3,4 for L1 growth and energy decay" {
    std.debug.print("\n═══════════════════════════════════════════════════════════\n", .{});
    std.debug.print("   DEPTH-d TC^0 FOURIER L1 NORM & ENERGY SPECTRUM         \n", .{});
    std.debug.print("═══════════════════════════════════════════════════════════\n", .{});

    var f_hat_buf: [4096]f64 = undefined;

    const test_configs = [_]struct { n: u5, depth: usize }{
        // n=6 sweep
        .{ .n = 6, .depth = 1 },
        .{ .n = 6, .depth = 2 },
        .{ .n = 6, .depth = 3 },
        .{ .n = 6, .depth = 4 },
        // n=8 sweep
        .{ .n = 8, .depth = 1 },
        .{ .n = 8, .depth = 2 },
        .{ .n = 8, .depth = 3 },
        .{ .n = 8, .depth = 4 },
        // n=10 sweep
        .{ .n = 10, .depth = 1 },
        .{ .n = 10, .depth = 2 },
        .{ .n = 10, .depth = 3 },
        .{ .n = 10, .depth = 4 },
    };

    for (test_configs) |cfg| {
        const len = @as(usize, 1) << cfg.n;
        const f_slice = f_hat_buf[0..len];

        for (0..len) |x| {
            f_slice[x] = DepthDEngine.evalDepthD(@as(u32, @intCast(x)), cfg.n, cfg.depth);
        }

        DepthDEngine.fastWalshHadamard(f_slice, cfg.n);
        const stats = DepthDEngine.measureL1AndEnergy(f_slice);

        std.debug.print("n={d:2} | Depth={d} | Dim={d:4} | L1 Norm: {d:7.4} | Low-Deg Energy (<=2): {d:5.2}% | Max Coeff: {d:6.4}\n", .{
            cfg.n,
            cfg.depth,
            len,
            stats.l1_norm,
            stats.low_deg_energy * 100.0,
            stats.max_coeff,
        });

        // Invariant: Parseval must hold (sum of squares = 1.0)
        var total_energy: f64 = 0.0;
        for (f_slice) |c| total_energy += c * c;
        try std.testing.expectApproxEqAbs(1.0, total_energy, 1e-4);
    }
    std.debug.print("═══════════════════════════════════════════════════════════\n", .{});
}
