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
    start_vertex = graph.all_vertices.first
    x = Set.new [start_vertex]
    v = Set.new graph.all_vertices
    h = Heap.new start_vertex.edges
    mst = []
    while x != v
      cheapest = h.delete_minimum
      mst << cheapest
      vertex = (x.include? cheapest.v1) ? cheapest.v2 : cheapest.v1
      x.add vertex
      vertex.edges.each do |e|
        e.in_cut?(x) ? h.delete(e) : h.add(e)
      end
    end
    mst
  end

  def tree_cost(mst = nil)
    mst ||= tree
    mst.reduce(0) { |sum, e| sum + e.cost }
  end

end

if __FILE__ == $0

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

end

