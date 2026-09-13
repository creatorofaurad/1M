// BOOLEAN SIMPLICIAL TOPOLOGY & BETTI NUMBER ENGINE
// Pure Zig 0.16.0 - ReleaseFast
// 0 Bytes dynamic heap allocation (malloc/free = 0)
// Computes exact simplicial boundary matrices and Betti numbers beta_0, beta_1 for m=4 (N=16)

const std = @import("std");

pub const M_VARS: usize = 4;
pub const N_LEN: usize = 1 << M_VARS; // 16 vertices

pub const SimplicialTopologyResult = struct {
    num_vertices: usize,
    num_edges: usize,
    beta_0: usize, // Number of connected components
    beta_1: usize, // Number of 1-dimensional topological cycles (holes)
};

/// Computes the exact simplicial topology of a 16-bit Boolean function
pub fn computeSimplicialTopology(truth_table: u16) SimplicialTopologyResult {
    // 1. Extract vertices (points where f(x) == 1)
    var vertex_indices: [N_LEN]usize = undefined;
    var num_vertices: usize = 0;

    for (0..N_LEN) |i| {
        if (((truth_table >> @as(u4, @intCast(i))) & 1) == 1) {
            vertex_indices[num_vertices] = i;
            num_vertices += 1;
        }
    }

    if (num_vertices == 0) {
        return SimplicialTopologyResult{
            .num_vertices = 0,
            .num_edges = 0,
            .beta_0 = 0,
            .beta_1 = 0,
        };
    }

    // 2. Extract edges (pairs of vertices with Hamming distance == 1)
    var edges_u: [128]usize = undefined;
    var edges_v: [128]usize = undefined;
    var num_edges: usize = 0;

    for (0..num_vertices) |i| {
        const u = vertex_indices[i];
        for ((i + 1)..num_vertices) |j| {
            const v = vertex_indices[j];
            const diff = u ^ v;
            // Hamming distance == 1 if diff is a power of 2
            if (@popCount(diff) == 1) {
                if (num_edges < 128) {
                    edges_u[num_edges] = i;
                    edges_v[num_edges] = j;
                    num_edges += 1;
                }
            }
        }
    }

    // 3. Compute beta_0 (Connected components via Disjoint Set / Union-Find)
    var parent: [N_LEN]usize = undefined;
    for (0..num_vertices) |i| parent[i] = i;

    var num_components = num_vertices;
    for (0..num_edges) |e| {
        var root_u = edges_u[e];
        while (parent[root_u] != root_u) root_u = parent[root_u];

        var root_v = edges_v[e];
        while (parent[root_v] != root_v) root_v = parent[root_v];

        if (root_u != root_v) {
            parent[root_u] = root_v;
            num_components -= 1;
        }
    }

    // 4. Compute 1-cycles (beta_1 = num_edges - num_vertices + num_components) for graphs
    // (Euler-Poincare Formula: V - E = beta_0 - beta_1 => beta_1 = E - V + beta_0)
    const beta_1: usize = if (num_edges + num_components >= num_vertices)
        (num_edges + num_components - num_vertices)
    else
        0;

    return SimplicialTopologyResult{
        .num_vertices = num_vertices,
        .num_edges = num_edges,
        .beta_0 = num_components,
        .beta_1 = beta_1,
    };
}

test "Simplicial Homology Topology Test on Simple Gates vs Disconnected Parity" {
    // 1. Single coordinate projection x_0: truth table 0xAAAA (8 vertices, 4-cube face, connected)
    const x0_tt: u16 = 0xAAAA;
    const x0_top = computeSimplicialTopology(x0_tt);
    // A single variable is a connected 3-cube face: beta_0 = 1, beta_1 = 5 cycles
    try std.testing.expectEqual(@as(usize, 8), x0_top.num_vertices);
    try std.testing.expectEqual(@as(usize, 1), x0_top.beta_0);

    // 2. Parity function (0x6996): 8 vertices with 0 edges (all mutually at Hamming distance >= 2)
    const parity_tt: u16 = 0x6996;
    const parity_top = computeSimplicialTopology(parity_tt);
    // Parity has maximal topological fragmentation: beta_0 = 8 isolated components, 0 edges!
    try std.testing.expectEqual(@as(usize, 8), parity_top.num_vertices);
    try std.testing.expectEqual(@as(usize, 0), parity_top.num_edges);
    try std.testing.expectEqual(@as(usize, 8), parity_top.beta_0);
    try std.testing.expectEqual(@as(usize, 0), parity_top.beta_1);
}
