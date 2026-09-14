//! Exact Composition Falsifier: Holographic PCP Query Composition with TC^0 Gates
//! Measures whether composing linear error-correcting decoding parity checks with Majority gates
//! preserves low-degree polynomial representation over F_p or causes degree/monomial explosion.
//! Lead Architect: Charles | Systems Verifier: Yelena

const std = @import("std");

pub const CompositionFalsifier = struct {
    pub const MAX_VARS = 12;
    pub const MAX_DIM = 4096;

    /// Evaluates finite-field parity query map: q(r) = M * r (mod 2)
    pub fn evalPCPQuery(r: u32, generator_matrix_row: u32) u1 {
        const parity_bits = @popCount(r & generator_matrix_row);
        return @as(u1, @intCast(parity_bits % 2));
    }

    /// Evaluates composed verifier: MAJ( q_1(r), q_2(r), ..., q_k(r) )
    pub fn evalComposedVerifier(r: u32, gen_rows: []const u32) f64 {
        var ones_count: usize = 0;
        for (gen_rows) |row_mask| {
            if (evalPCPQuery(r, row_mask) == 1) {
                ones_count += 1;
            }
        }
        const thresh = (gen_rows.len + 1) / 2;
        return if (ones_count >= thresh) 1.0 else -1.0;
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

    /// Analyzes degree spectrum and L1 norm of composed function
    pub fn analyzeComposedSpectrum(f_hat: []const f64) struct { l1_norm: f64, max_degree: usize, high_deg_energy: f64 } {
        var l1_norm: f64 = 0.0;
        var max_deg: usize = 0;
        var high_energy: f64 = 0.0;

        for (f_hat, 0..) |c, idx| {
            const abs_c = @abs(c);
            l1_norm += abs_c;

            if (abs_c > 1e-4) {
                const deg = @popCount(@as(u32, @intCast(idx)));
                if (deg > max_deg) max_deg = deg;
                if (deg >= 4) {
                    high_energy += c * c;
                }
            }
        }
        return .{ .l1_norm = l1_norm, .max_degree = max_deg, .high_deg_energy = high_energy };
    }
};

test "Composition Falsifier: measure exact degree and L1 norm explosion under PCP parity queries" {
    std.debug.print("\n═══════════════════════════════════════════════════════════\n", .{});
    std.debug.print("   HOLOGRAPHIC PCP COMPOSITION FALSIFIER (BARE SILICON)   \n", .{});
    std.debug.print("═══════════════════════════════════════════════════════════\n", .{});

    var f_hat_buf: [4096]f64 = undefined;

    // Simulate 5 linear parity query checks (typical in BFLS low-degree extension test)
    const gen_rows = [_]u32{
        0b000000000001, // r_0
        0b000000000011, // r_0 + r_1
        0b000000000110, // r_1 + r_2
        0b000000001100, // r_2 + r_3
        0b000000011000, // r_3 + r_4
        0b000000110000, // r_4 + r_5
        0b000001100000, // r_5 + r_6
    };

    const test_dimensions = [_]u5{ 6, 8, 10, 12 };

    for (test_dimensions) |n| {
        const len = @as(usize, 1) << n;
        const f_slice = f_hat_buf[0..len];

        for (0..len) |r| {
            f_slice[r] = CompositionFalsifier.evalComposedVerifier(@as(u32, @intCast(r)), gen_rows[0..@min(gen_rows.len, n)]);
        }

        CompositionFalsifier.fastWalshHadamard(f_slice, n);
        const stats = CompositionFalsifier.analyzeComposedSpectrum(f_slice);

        std.debug.print("Random Coins m={d:2} (Dim={d:4}) | L1 Norm: {d:7.4} | Max Active Deg: {d:2} | High-Deg Energy (deg>=4): {d:5.2}%\n", .{
            n,
            len,
            stats.l1_norm,
            stats.max_degree,
            stats.high_deg_energy * 100.0,
        });

        // Invariant: Parseval must hold
        var total_energy: f64 = 0.0;
        for (f_slice) |c| total_energy += c * c;
        try std.testing.expectApproxEqAbs(1.0, total_energy, 1e-4);
    }
    std.debug.print("═══════════════════════════════════════════════════════════\n", .{});
}
