require 'rspec'
require './01.graph.rb'
require './01.union-find.rb'

class HammingCluster
  attr_accessor :graph, :partitions, :num_bits, :all_masks, :min_distance

  def initialize(graph, num_bits, min_distance)
    self.graph = graph
    self.partitions = UnionFind.new
    self.partitions.add *self.graph.all_vertices
    self.num_bits = num_bits
    self.min_distance = min_distance
    generate_masks
  end

  def generate_masks
    self.all_masks = {}
    (min_distance-1).downto(1) do |dist|
      indices = (num_bits-1).downto(0).to_a
      all_masks[dist] = indices.combination(dist)
    end
  end

  def neighbors(v)
    vertice_ids = []
    all_masks.each do |dist, masks|
      masks.each do |mask|
        bits = v.params[:bits].dup
        mask.each { |idx| bits[idx] = 1 - bits[idx] }
        vertice_ids << bits.join
      end
    end
    vertice_ids
  end

  def run
    vertices = graph.all_vertices

    while vertices[0]
      v = vertices.shift
      neighbors(v).each do |id2|
        v2 = graph.vertices[id2]
        if v2
          partitions.union v, v2
        end
      end
    end

    {partitions: partitions}
  end

end


describe HammingCluster do

  it "should generate masks" do
    num_bits = 4
    min_distance = 2
    h = HammingCluster.new Graph.new, num_bits, min_distance
    h.generate_masks
  end

  it "should generate neighbor ids"

end


if $0 == __FILE__
  num_nodes, num_bits = gets.split(" ").map { |num| num.to_i }

  graph = Graph.new
  index = Hash.new
  num_nodes.times do |i|
    bits = gets.split(" ").map { |num| num.to_i }
    id = bits.join
    v = graph.vertices[id] || Vertex.new(id, :bits => bits)
    graph.add_vertex v
  end

  min_distance = 3
  k_clustering = HammingCluster.new graph, num_bits, min_distance
  results = k_clustering.run
  puts "Groups: #{results[:partitions].groups.size}"
end

