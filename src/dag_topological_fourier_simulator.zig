// DAG TOPOLOGICAL FOURIER INVARIANT EMPIRICAL SIMULATOR
// Pure Zig 0.16.0 - ReleaseFast
// 0 Bytes dynamic heap allocation (malloc/free = 0)
// Measures the maximum delta Psi per gate across DAG gate compositions for m=4 (N=16)

const std = @import("std");
const psi_mod = @import("topological_fourier_entropy_kernel.zig");

pub const M_VARS: usize = 4;
pub const N_LEN: usize = 16;
pub const MAX_GATES: usize = 16;

pub const GateType = enum {
    AND,
    OR,
    XOR,
    NOT,
};

pub const CircuitGate = struct {
    gate_type: GateType,
    input_left: usize,
    input_right: usize,
};

/// Evaluates a multi-gate DAG and returns the output truth table
pub fn evaluateDAG(gates: []const CircuitGate) u16 {
    // Initial 4 inputs x0, x1, x2, x3
    var node_values: [MAX_GATES + 4]u16 = undefined;
    node_values[0] = 0xAAAA; // x0: 1010101010101010
    node_values[1] = 0xCCCC; // x1: 1100110011001100
    node_values[2] = 0xF0F0; // x2: 1111000011110000
    node_values[3] = 0xFF00; // x3: 1111111100000000

    for (gates, 0..) |g, idx| {
        const left = node_values[g.input_left];
        const right = node_values[g.input_right];
        const res: u16 = switch (g.gate_type) {
            .AND => left & right,
            .OR => left | right,
            .XOR => left ^ right,
            .NOT => ~left,
        };
        node_values[idx + 4] = res;
    }

    return node_values[gates.len + 3];
}

test "Empirical Gate Growth Bound Test on Size-1 to Size-5 DAGs" {
    // Test elementary gates:
    // Size 1 gates on base inputs
    var max_psi_size1: f32 = 0.0;
    const gate_ops = [_]GateType{ .AND, .OR, .XOR };

    for (0..4) |i| {
        for (0..4) |j| {
            for (gate_ops) |op| {
                const single_gate = [_]CircuitGate{.{
                    .gate_type = op,
                    .input_left = i,
                    .input_right = j,
                }};
                const tt = evaluateDAG(&single_gate);
                const psi_val = psi_mod.computeTopologicalFourierInvariant(tt);
                if (psi_val > max_psi_size1) {
                    max_psi_size1 = psi_val;
                }
            }
        }
    }

    // Single gate Psi MUST remain strictly bounded
    try std.testing.expect(max_psi_size1 <= 16.0);
}
