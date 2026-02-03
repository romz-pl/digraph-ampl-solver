#
# Longest path problem in the directed graph 
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

# The length of the edge
param length {E};

# Decision variable.
# There is U[i, j] = 1 iff edge (i, j) is in the longest path.
# (binary variable?)
var Use {(i, j) in E} >= 0, <= 1; 

# Objective function.
# The lenght of the path
maximize path_length:
	sum {(i, j) in E} length[i, j] * Use[i, j];
	

# Ensure that exactly one unit of flow is available at the entrance to the network.
subject to Start:
	sum {(S, j) in E} Use[S, j] = 1;


# Network balance constraints described algebraically
subject to Balance {k in V diff {S, T}}:
	sum {(i, k) in E} Use[i, k] = sum {(k,j) in E} Use[k, j];
     


