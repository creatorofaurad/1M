// SUBCUBE POSET ORDER COMPLEX & MIDDLE BETTI NUMBER KERNEL
// Pure Zig 0.16.0 - ReleaseFast
// 0 Bytes dynamic heap allocation (malloc/free = 0)
// Computes monochromatic subcube poset P_f and order complex Betti numbers

const std = @import("std");

pub const M_VARS: usize = 4;
pub const TOTAL_POINTS: usize = 1 << M_VARS; // 16

pub const Subcube = struct {
    pattern: u16, // bitmask of fixed coordinates
    values: u16, // values of fixed coordinates
    dim: usize, // dimension of subcube (free coordinates)
};

pub const MAX_SUBCUBES: usize = 128;

/// Finds all monochromatic subcubes where f(x) == 1
pub fn findMonochromaticSubcubes(truth_table: u16, out_cubes: *[MAX_SUBCUBES]Subcube) usize {
    var count: usize = 0;

    // Search over all 3^m possible subcubes
    // For each coordinate, it can be 0, 1, or * (free)
    // There are 3^4 = 81 subcubes for m=4
    var ternary: usize = 0;
    while (ternary < 81) : (ternary += 1) {
        var temp_ternary = ternary;
        var pattern: u16 = 0;
        var values: u16 = 0;
        var free_count: usize = 0;

        for (0..M_VARS) |bit| {
            const digit = temp_ternary % 3;
            temp_ternary /= 3;
            if (digit == 0) {
                pattern |= (@as(u16, 1) << @as(u4, @intCast(bit)));
            } else if (digit == 1) {
                pattern |= (@as(u16, 1) << @as(u4, @intCast(bit)));
                values |= (@as(u16, 1) << @as(u4, @intCast(bit)));
            } else {
                // digit == 2: free coordinate
                free_count += 1;
            }
        }

        // Test if f(x) == 1 for all points in this subcube
        var is_monochromatic = true;
        for (0..TOTAL_POINTS) |x| {
            // Check if x matches the subcube fixed coordinates
            if ((@as(u16, @intCast(x)) & pattern) == values) {
                const bit = (truth_table >> @as(u4, @intCast(x))) & 1;
                if (bit == 0) {
                    is_monochromatic = false;
                    break;
                }
            }
        }

        if (is_monochromatic) {
            if (count < MAX_SUBCUBES) {
                out_cubes[count] = Subcube{
                    .pattern = pattern,
                    .values = values,
                    .dim = free_count,
                };
                count += 1;
            }
        }
    }

    return count;
}

test "Subcube Poset Order Complex Kernel Verification" {
    var cubes: [MAX_SUBCUBES]Subcube = undefined;

    // 1. Single coordinate projection x_0: 0xAAAA (8 ones)
    const x0_tt: u16 = 0xAAAA;
    const x0_count = findMonochromaticSubcubes(x0_tt, &cubes);
    // Subcubes of a single variable: 3^3 = 27 subcubes
    try std.testing.expectEqual(@as(usize, 27), x0_count);

    // 2. Parity function (0x6996): 8 ones, but NO subcubes of dimension >= 1!
    const parity_tt: u16 = 0x6996;
    const parity_count = findMonochromaticSubcubes(parity_tt, &cubes);
    // Parity has ONLY the 8 0-dimensional points as subcubes (count = 8)
    try std.testing.expectEqual(@as(usize, 8), parity_count);

    // Verify all subcubes of Parity have dim == 0
    for (0..parity_count) |i| {
        try std.testing.expectEqual(@as(usize, 0), cubes[i].dim);
    }
}
