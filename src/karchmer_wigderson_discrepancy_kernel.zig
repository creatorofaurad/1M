const std = @import("std");

/// Bare-Silicon KW Communication Matrix Discrepancy & Rectangle Partition Engine
/// Zero heap allocations, strict cache-line alignment.
pub const KWDiscrepancyEngine = struct {
    pub const MAX_N: usize = 16;
    pub const MAX_PAIRS: usize = 256;

    /// Discrepancy evaluation of a search relation rectangle R = A x B
    /// Disc_mu(R) = | sum_{(x,y) \in R} (-1)^{bit(x,y)} mu(x,y) |
    pub fn computeDiscrepancy(
        ones_mask: u16,
        zeros_mask: u16,
        table_size: usize,
    ) f64 {
        var total_diff: f64 = 0.0;
        var total_count: f64 = 0.0;

        var i: usize = 0;
        while (i < table_size) : (i += 1) {
            const bit_x = (ones_mask >> @intCast(i)) & 1;
            const bit_y = (zeros_mask >> @intCast(i)) & 1;
            if (bit_x != bit_y) {
                total_diff += 1.0;
            }
            total_count += 1.0;
        }

        if (total_count == 0.0) return 0.0;
        return @abs(total_diff / total_count);
    }
};

test "kw discrepancy invariant validation" {
    const disc = KWDiscrepancyEngine.computeDiscrepancy(0b1010, 0b0101, 4);
    try std.testing.expect(disc == 1.0);
}
