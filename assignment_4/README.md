## All-Pairs Shortest Path Problem

In this assignment you will implement one or more algorithms for the all-pairs shortest-path problem.

Your task is to compute the "shortest shortest path". Precisely, you must first identify which, if any, of the three graphs have no negative cycles. For each such graph, you should compute all-pairs shortest paths and remember the smallest one (i.e., compute `min d(u,v)`, where `{u,v} ∈ V` and `d(u,v)` denotes the shortest-path distance from `u` to `v`).

OPTIONAL: You can use whatever algorithm you like to solve this question. If you have extra time, try comparing the performance of different all-pairs shortest-path algorithms!

OPTIONAL: If you want a bigger data set to play with, try computing the shortest shortest path for the `glarge.txt` graph.


### Input

The first line indicates the number of vertices and edges, respectively. Each subsequent line describes an edge (the first two numbers are its tail and head, respectively) and its length (the third number). NOTE: some of the edge lengths are negative. NOTE: These graphs may or may not have negative-cost cycles.


### Output

If each of the three graphs has a negative-cost cycle, then enter "NULL" in the box below. If exactly one graph has no negative-cost cycles, then enter the length of its shortest shortest path in the box below. If two or more of the graphs have no negative-cost cycles, then enter the smallest of the lengths of their shortest shortest paths in the box below.


Example
-------

### Sample Input
    6 8
    1 2 5
    1 3 -10
    2 3 10
    2 4 15
    3 5 -10
    4 3 5
    4 6 10
    5 6 -10


### Sample Output
    -30

