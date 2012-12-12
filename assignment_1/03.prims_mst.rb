#!/usr/bin/ruby

require 'set'
require './03.heap.rb'

class Edge
  attr_accessor :v1, :v2, :cost

  def initialize(id1, id2, cost)
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

  def <(e)
    self.cost < e.cost
  end

  def >(e)
    self.cost > e.cost
  end

  def <=>(e)
    self.cost <=> e.cost
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
    h = Heap.new e
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

