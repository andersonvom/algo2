#!/usr/bin/ruby

require 'set'
require './03.heap.rb'
require './03.graph.rb'

class PrimsMST

  attr_accessor :graph

  def initialize(graph)
    self.graph = graph
  end

  def tree
    x = Set.new [graph.all_vertices.first]
    v = Set.new graph.all_vertices
    e = graph.all_edges.sort { |e1, e2| e1.cost <=> e2.cost }
    t = []
    while x != v
      cheapest = nil
      in_cut = []
      e.each do |i|
        in_cut << i if i.in_cut? x
        if i.cross_cut? x
          cheapest = i
          in_cut << i
          break
        end
      end
      e -= in_cut

      t << cheapest
      x.add cheapest.v1
      x.add cheapest.v2
    end
    t
  end

  def tree_cost(t = nil)
    t ||= tree
    t.reduce(0) { |sum, e| sum + e.cost }
  end

end

if __FILE__ == $0
  puts "Start"

  num_nodes, num_edges = gets.split(" ").map { |num| num.to_i }
  graph = Graph.new

  num_edges.times do |i|
    idx1, idx2, cost = gets.split(" ").map { |num| num.to_i }
    v1 = graph.vertices[idx1] || Vertex.new(idx1)
    v2 = graph.vertices[idx2] || Vertex.new(idx2)
    e = Edge.new v1, v2, cost
    graph.add_vertex v1, v2
  end

  prims_mst = PrimsMST.new graph
  puts prims_mst.tree_cost

  puts "End"
end

