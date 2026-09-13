// KOLMOGOROV DEFICIT OPERATOR BARE-SILICON VERIFIER
// Pure Zig 0.16.0 - ReleaseFast
// 0 Bytes dynamic heap allocation (malloc/free = 0)
// Verifies circuit bit encoding lengths vs truth table Kolmogorov complexity

const std = @import("std");

pub const CircuitEncoding = struct {
    num_inputs: usize,
    num_gates: usize,

    /// Computes the exact maximum bit encoding length of a circuit of size S on m inputs
    pub fn computeEncodingBits(m: usize, s: usize) usize {
        // Opcode: 2 bits per gate
        // Predecessors: 2 * ceil(log2(m + s)) bits per gate
        const total_nodes = m + s;
        var node_bits: usize = 1;
        while ((@as(usize, 1) << @as(u6, @intCast(node_bits))) < total_nodes) : (node_bits += 1) {}
        return s * (2 + 2 * node_bits);
    }
};

test "Kolmogorov Deficit Circuit Encoding Bound Verification" {
    // 1. For m = 4, N = 16:
    // Threshold tau = N/2 = 8 bits (64 bits for N=128, etc.)
    // Test size S = 1 gate:
    const bits_s1 = CircuitEncoding.computeEncodingBits(4, 1);
    // 1 gate has 1 * (2 + 2 * 3) = 8 bits <= 16
    try std.testing.expect(bits_s1 <= 8);

    // 2. Test asymptotic separation for N = 1024 (m = 10):
    const m_10: usize = 10;
    const n_10: usize = 1 << m_10; // 1024
    const tau_10: usize = n_10 / 2; // 512 bits

    // Size S = N / (10 * log2(N)) = 1024 / (10 * 10) = 10 gates
    const s_10: usize = n_10 / (10 * m_10); // 10
    const enc_bits_10 = CircuitEncoding.computeEncodingBits(m_10, s_10);
    // enc_bits_10 = 10 * (2 + 2 * 5) = 120 bits
    // Because 120 bits << 512 bits (tau), the Kolmogorov deficit is:
    // Deficit = tau - enc_bits = 512 - 120 = 392 bits > 0!
    try std.testing.expect(enc_bits_10 < tau_10);
    try std.testing.expectEqual(@as(usize, 120), enc_bits_10);
}
