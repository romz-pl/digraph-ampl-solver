#
# Maximum weight of K paths problem in the directed graph 
#
# Author: Zbigniew Romanowski
#



# Set of vertices in the graph
set V;

# Source vertex in the graph
param S symbolic in V;

# Target vertex in the graph
param T symbolic in V, <> S;

# The set of edges.
# The set of edges must be a subset of the set of ordered pairs of vertices.
# This definition ensures that no edge begins at the target (T) or ends at the source (S).
set E within (V diff {T}) cross (V diff {S});

# The weight of the edge
param weight {E};

# Number of distinct paths required
param K integer, >= 1;


# Decision Variables
# There is X[i, j, k] = 1 iff edge (i, j) is used in path k
var X{(i, j) in E, 1..K} binary; 


# Objective function.
# The weight of the path
maximize sum_path_weight:
	sum {(i, j) in E, k in 1..K} weight[i, j] * X[i, j, k];


# Edge disjointness: each edge can be used in at most one path
subject to edge_disjoint{(i, j) in E}:
    sum{k in 1..K} X[i, j, k] <= 1;	

# Ensure that exactly one unit of flow is available at the entrance to the network.
subject to Start {k in 1..K}:
	sum {(S, j) in E} X[S, j, k] = 1;


# Network balance constraints described algebraically
subject to Balance {v in V diff {S, T}, k in 1..K}:
	sum {(i, v) in E} X[i, v, k] = sum {(v,j) in E} X[v, j, k];
     

# Symmetry breaking (optional): order paths by their total weights
# This helps reduce solution time by eliminating symmetric solutions
subject to path_ordering{k in 1..K-1}:
    sum{(i, j) in E} weight[i, j] * X[i, j, k] >= 
    sum{(i, j) in E} weight[i, j] * X[i, j, k + 1];

