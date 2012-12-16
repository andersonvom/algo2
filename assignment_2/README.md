## Max-Spacing k-Clustering

A clustering algorithm for computing a max-spacing k-clustering (4 clusters in this example).

### Input

A distance function (equivalently, a complete graph with edge costs). There is a single positive integer `N` on the first line standing for the number of nodes. Then there are `n(n-1)/2` lines , each containing exactly three positive integers `I` (node 1), `J` (node 2), `D` (distance), where `1 <= I <= J <= N`. Distances are positive but may not be distinct.

### Output

A positive integer of the maximum spacing of a 4-clustering.

Example
-------

### Sample Input
    4
    1 2 6808
    1 3 5250
    1 4 74
    2 3 4902
    2 4 812
    3 4 3782


### Sample Output
   74


## Max-Spacing k-Clustering on HUGE graphs

Run the clustering algorithm from lecture, but on a MUCH bigger graph. So big, in fact, that the distances (i.e., edge costs) are only defined implicitly, rather than being provided as an explicit list. The distance between two nodes `u` and `v` in this problem is defined as the Hamming distance -- the number of differing bits -- between the two nodes' labels. For example, the Hamming distance between `0 1 1 0 0 1 1 0 0 1 0 1 1 1 1 1 1 0 1 0 1 1 0 1` and `0 1 0 0 0 1 0 0 0 1 0 1 1 1 1 1 1 0 1 0 0 1 0 1` is 3 (since they differ in the 3rd, 7th, and 21st bits).

### Input

The first line contains two positive integers `N` and `B` for the number of nodes and the number of bits per node, respectively. Then there are `N` lines containing each node's bits.

### Output

The largest value of k such that there is a k-clustering with spacing at least 3. That is, how many clusters are needed to ensure that no pair of nodes with all but 2 bits in common get split into different clusters?

Example
-------

### Sample Input
    3 24
    1 1 1 0 0 0 0 0 1 1 0 1 0 0 1 1 1 1 0 0 1 1 1 1
    0 1 1 0 0 1 1 0 0 1 0 1 1 1 1 1 1 0 1 0 1 1 0 1
    0 1 1 1 0 0 0 0 0 0 0 1 0 0 1 0 1 1 1 0 0 1 0 1


### Sample Output
   3

