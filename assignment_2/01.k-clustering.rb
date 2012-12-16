require 'rspec'
require './01.graph.rb'
require './01.union-find.rb'

class KClustering
  attr_accessor :graph, :partitions

  def initialize(graph)
    self.graph = graph
    self.partitions = UnionFind.new
    self.partitions.add *self.graph.all_vertices
  end

  def different_partitions?(elem1, elem2)
    partitions.elements[elem1.id] != partitions.elements[elem2.id]
  end

  def run(num_clusters)
    edges = graph.all_edges.sort

    # Partition in `num_clusters` groups
    while partitions.groups.size > num_clusters do
      edge = edges.shift
      break unless edge

      v1, v2 = edge.vertices
      if different_partitions?(v1, v2)
        partitions.union v1, v2
      end
    end

    # Find minimum distance between groups
    minimum_distance = nil
    edges.each do |edge|
      edge = edges.shift
      break unless edge
      v1, v2 = edge.vertices
      if different_partitions?(v1, v2)
        minimum_distance = edge.cost if different_partitions?(v1, v2)
        break
      end
    end

    {partitions: partitions, distance: minimum_distance}
  end

end

describe KClustering do
  it "should initialize with a graph" do
    @graph = Graph.new
    @k = KClustering.new @graph
    @k.graph.should == @graph
  end

  it "should raise exeption if no graph is given" do
    lambda { KClustering.new }.should raise_error
  end

  it "should find clustering of empty graph" do
    @graph = Graph.new
    @k = KClustering.new @graph
    partitions = @k.partitions
    @k.run(3)[:partitions].should == partitions
  end

  it "should partition graph in n groups and calculate minimum distance" do
    v1, v2, v3, v4 = 4.times.map { |i| Vertex.new i }
    Edge.new v1, v2, 6
    Edge.new v1, v3, 5
    Edge.new v1, v4, 1
    Edge.new v2, v3, 4
    Edge.new v2, v4, 2
    Edge.new v3, v4, 3
    @graph = Graph.new v1, v2, v3, v4
    @k = KClustering.new @graph
    @k.run(2)[:partitions].groups.size.should == 2
    @k.run(2)[:distance].should == 3
 end

  it "should not find distance when there's only one cluster" do
    v1, v2, v3, v4 = 4.times.map { |i| Vertex.new i }
    Edge.new v1, v2, 6
    Edge.new v1, v3, 5
    Edge.new v1, v4, 1
    Edge.new v2, v3, 4
    Edge.new v2, v4, 2
    Edge.new v3, v4, 3
    @graph = Graph.new v1, v2, v3, v4
    @k = KClustering.new @graph
    @k.run(1)[:partitions].groups.size.should == 1
    @k.run(1)[:distance].should be_nil
  end

end

if $0 == __FILE__
  num_nodes = gets.to_i
  num_edges = (num_nodes * (num_nodes-1)) / 2

  graph = Graph.new
  num_edges.times do |i|
    idx1, idx2, cost = gets.split(" ").map { |num| num.to_i }
    v1 = graph.vertices[idx1] || Vertex.new(idx1)
    v2 = graph.vertices[idx2] || Vertex.new(idx2)
    e = Edge.new v1, v2, cost
    graph.add_vertex v1, v2
  end

  k_clustering = KClustering.new graph
  num_clusters = 4
  results = k_clustering.run(num_clusters)
  puts "Groups: #{results[:partitions].groups.size}"
  puts "Maximum distance for #{num_clusters} groups: #{results[:distance]}"
end

