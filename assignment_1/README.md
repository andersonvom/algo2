## Scheduling

A greedy algorithms for minimizing the weighted sum of completion times. Two algorithms are provided: an optimal algorithm that orders jobs in decreasing order of the ratio `weight / length` and a not-always-optimal algorithm that orders jobs in decreasing order of the difference `weight - length`.
If two jobs have equal difference `weight - length`, the job with higher weight is scheduled first.

### Input

There is a single positive integer `J` on the first line of input. It stands for the number of lines to follow. Then there are `J` lines, each containing exactly two positive integers weight `W` and length `L`. You should NOT assume that edge weights or lengths are distinct.

### Output

The positive integers of the sum of weighted completion times of each resulting schedule (by difference and by ratio)

Example
-------

### Sample Input
    5
    8 50
    74 59
    31 73
    45 79
    24 10

### Sample Output
    Weighted sum (using difference): 21701
    Weighted sum (using job ratio):  21025


## Prim's Minimum Spanning Tree

An implementation of Prim's Minimum Spanning Tree greedy algorithm.

### Input

Two integers `N` (number of nodes) and `E` (number of edges) of an undirected graph with integer edge costs on the first line of input. Then there are `E` lines, each containing excetly three integers `V1` and `V2` (the two vertices of the edge) and `C` (the edge cost). You should NOT assume that edge costs are positive, nor should you assume that they are distinct.

### Output

The overall integer cost of a minimum spanning tree, which may or may not be negative.

Example
-------

### Sample Input
    5 4
    1 2 6807
    2 3 -8874
    3 4 -1055
    4 5 4414

### Sample Output
    1292

