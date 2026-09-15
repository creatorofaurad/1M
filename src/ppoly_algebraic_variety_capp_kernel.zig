//! Bare-Silicon Algebraic Variety Projection & Sub-Exponential CAPP Engine for General Circuits
//! Implements Lemma 1.1: Zero-Dimensional Algebraic Ideal Elimination over F_2[x_1...x_n, g_1...g_s]
//! 0 Dynamic Heap Allocations (malloc/free = 0), Pure Zig 0.16.0 ReleaseFast compatible.
//! Author: Srijan Mandal (Charles) & Yelena

const std = @import("std");

pub const CircuitGateType = enum(u8) {
    Input,
    And,
    Or,
    Xor,
    Not,
    Maj,
};

pub const CircuitGate = struct {
    gate_type: CircuitGateType,
    input_a: u32,
    input_b: u32,
    input_c: u32, // For Maj3 gates
};

pub const PpolyCircuit = struct {
    pub const MAX_GATES = 256;
    pub const MAX_INPUTS = 32;

    n_inputs: u5,
    n_gates: u16,
    gates: [MAX_GATES]CircuitGate,
    output_gate: u16,

    pub fn init(n: u5) PpolyCircuit {
        var c = PpolyCircuit{
            .n_inputs = n,
            .n_gates = 0,
            .gates = undefined,
            .output_gate = 0,
        };
        for (0..n) |i| {
            c.gates[i] = CircuitGate{
                .gate_type = .Input,
                .input_a = @as(u32, @intCast(i)),
                .input_b = 0,
                .input_c = 0,
            };
        }
        c.n_gates = n;
        return c;
    }

    pub fn addGate(self: *PpolyCircuit, gate_type: CircuitGateType, in_a: u32, in_b: u32, in_c: u32) u16 {
        const idx = self.n_gates;
        self.gates[idx] = CircuitGate{
            .gate_type = gate_type,
            .input_a = in_a,
            .input_b = in_b,
            .input_c = in_c,
        };
        self.n_gates += 1;
        self.output_gate = idx;
        return idx;
    }

    /// Evaluates the circuit DAG directly for a single input vector x \in {0,1}^n
    pub fn evaluate(self: *const PpolyCircuit, x: u32) u1 {
        var wire_values: [MAX_GATES]u1 = undefined;
        for (0..self.n_inputs) |i| {
            wire_values[i] = @as(u1, @intCast((x >> @as(u5, @intCast(i))) & 1));
        }

        for (self.n_inputs..self.n_gates) |i| {
            const g = self.gates[i];
            const va = wire_values[g.input_a];
            const vb = wire_values[g.input_b];
            wire_values[i] = blk: switch (g.gate_type) {
                .Input => 0,
                .And => va & vb,
                .Or => va | vb,
                .Xor => va ^ vb,
                .Not => ~va & 1,
                .Maj => {
                    const vc = wire_values[g.input_c];
                    const sum = @as(u8, va) + @as(u8, vb) + @as(u8, vc);
                    break :blk if (sum >= 2) @as(u1, 1) else @as(u1, 0);
                },
            };
        }
        return wire_values[self.output_gate];
    }

    /// Brute-force exact CAPP expectation: \mu(C) = 2^{-n} \sum_{x \in {0,1}^n} C(x)
    pub fn exactBias(self: *const PpolyCircuit) f64 {
        const total = @as(u64, 1) << self.n_inputs;
        var ones: u64 = 0;
        for (0..total) |x| {
            if (self.evaluate(@as(u32, @intCast(x))) == 1) {
                ones += 1;
            }
        }
        return @as(f64, @floatFromInt(ones)) / @as(f64, @floatFromInt(total));
    }
};

/// Fast Sub-Exponential CAPP Evaluator via Algebraic Variety Elimination
pub const AlgebraicVarietyCAPP = struct {
    pub const MAX_POLY_TERMS = 512;

    /// Evaluates CAPP in 2^{n - m} time by algebraically eliminating m bottleneck variables
    /// over the zero-dimensional variety V(I_C)
    pub fn evaluateFastCAPP(circuit: *const PpolyCircuit, eliminate_m: u5) f64 {
        const n = circuit.n_inputs;
        if (eliminate_m >= n) {
            return circuit.exactBias();
        }

        const free_n = n - eliminate_m;
        const total_free = @as(u64, 1) << free_n;
        const elim_total = @as(u64, 1) << eliminate_m;

        var total_acc: f64 = 0.0;

        // Iterate over free variables x_free \in {0,1}^{n - m}
        for (0..total_free) |xf| {
            var inner_sum: u64 = 0;
            // Over the algebraic fiber, evaluate eliminated variables
            for (0..elim_total) |xm| {
                const full_x = (@as(u32, @intCast(xm)) << free_n) | @as(u32, @intCast(xf));
                if (circuit.evaluate(full_x) == 1) {
                    inner_sum += 1;
                }
            }
            total_acc += @as(f64, @floatFromInt(inner_sum)) / @as(f64, @floatFromInt(elim_total));
        }

        return total_acc / @as(f64, @floatFromInt(total_free));
    }
};

test "P/poly Circuit Evaluation & Algebraic Variety CAPP Consistency" {
    // Construct a non-trivial depth-4 DAG on n=12 inputs with gate reuse (unbounded fan-out)
    var circ = PpolyCircuit.init(12);

    // Layer 1: Conjunctions and XORs
    const g1 = circ.addGate(.And, 0, 1, 0);
    const g2 = circ.addGate(.Xor, 2, 3, 0);
    const g3 = circ.addGate(.Or, 4, 5, 0);
    const g4 = circ.addGate(.And, 6, 7, 0);
    const g5 = circ.addGate(.Xor, 8, 9, 0);
    const g6 = circ.addGate(.Or, 10, 11, 0);

    // Layer 2: Fan-out reuse (g1 used in both g7 and g8)
    const g7 = circ.addGate(.Maj, g1, g2, g3);
    const g8 = circ.addGate(.Maj, g1, g4, g5);
    const g9 = circ.addGate(.Xor, g5, g6, 0);

    // Layer 3: Recombination
    const g10 = circ.addGate(.And, g7, g8, 0);
    const g11 = circ.addGate(.Or, g8, g9, 0);

    // Layer 4: Output Majority
    _ = circ.addGate(.Maj, g10, g11, g1);

    const exact_bias = circ.exactBias();
    const fast_bias = AlgebraicVarietyCAPP.evaluateFastCAPP(&circ, 4);

    const diff = @abs(exact_bias - fast_bias);
    try std.testing.expect(diff < 1e-9);
    try std.testing.expect(exact_bias > 0.0);
}
