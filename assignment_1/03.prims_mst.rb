#!/usr/bin/ruby

require 'set'

=begin
class Vertex
  attr_accessor :id, :edge

  def initialize(id, edge=nil)
    self.id = id
    self.edge = edge
  end

  def to_s
    id.to_s
  end
end
=end

class Edge
  attr_accessor :v1, :v2, :cost

  def initialize(id1, id2, cost)
    #self.v1 = Vertex.new id1, self
    #self.v2 = Vertex.new id2, self
    self.v1 = id1
    self.v2 = id2
    self.cost = cost
  end

  def cross_cut?(x)
    (x.include? v1 and !x.include? v2) or (x.include? v2 and !x.include? v1)
  end

  def in_cut?(x)
    x.include? v1 and x.include? v2
  end

  def to_s
    "(#{v1}...#{cost}...#{v2})"
  end
end

class PrimsMST

  attr_accessor :vertices, :edges, :tree

  def initialize
    self.vertices = []
    self.edges = []
  end

  def add_edge(id1, id2, cost)
    e = Edge.new(id1, id2, cost)
    self.vertices << e.v1
    self.vertices << e.v2
    self.edges << e
  end

  def tree
    x = Set.new [self.vertices.first]
    v = Set.new self.vertices
    e = self.edges.dup.sort! { |e1, e2| e1.cost <=> e2.cost }
    t = []
    while x != v
      cheapest = nil

      e.each do |i|
        #e.delete i if i.in_cut? x
        if i.cross_cut? x
          cheapest = i
          e.delete i
          break
        end
      end

      t << cheapest
      x.add cheapest.v1
      x.add cheapest.v2
    end
    t
  end

  def tree_cost(t)
    t.reduce(0) { |sum, e| sum + e.cost }
  end

end

if __FILE__ == $0
  puts "Start"

  num_nodes, num_edges = gets.split(" ").map { |num| num.to_i }
  prims_mst = PrimsMST.new

  num_edges.times do |i|
    v1, v2, cost = gets.split(" ").map { |num| num.to_i }
    #puts "#{v1} #{v2} #{cost}"
    prims_mst.add_edge(v1, v2, cost)
  end

  tree = prims_mst.tree
  #puts tree
  puts prims_mst.tree_cost tree

  puts "End"
end

