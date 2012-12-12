#!/usr/bin/ruby

require 'set'

class Heap
  attr_accessor :tree

  def initialize(*ary)
    self.tree = [nil] # first element is padded w/nil to speed calculations
    elems = ary
    elems = ary.first if ary.count == 1
    add *elems
  end

  def add(*elems)
    elems.each do |elem|
      self.tree << elem
      bubble_up elem, tree.size-1
    end
    self
  end

  def delete_minimum
    delete_at(1)
  end

  def delete_at(idx)
    return unless tree[idx]
    elem = self.tree[idx]
    last = self.tree.delete_at -1
    self.tree[idx] = last if self.tree[idx]
    bubble_up tree[idx], idx
    bubble_down tree[idx], idx
    elem
  end

  def swap(idx1, idx2, next_operation)
    self.tree[idx1], self.tree[idx2] = [tree[idx2], tree[idx1]]
    send(next_operation, tree[idx2], idx2)
  end

  def bubble_up(elem, idx)
    return self if idx == 1
    parent_idx = idx/2
    swap(idx, parent_idx, :bubble_up) if tree[parent_idx] > tree[idx]
    self
  end

  def bubble_down(elem, idx)
    children_indices = [idx*2, idx*2+1].sort do |x, y|
      tree[y] ? (tree[x] <=> tree[y]) : -1
    end
    children_indices.each do |child_idx|
      next unless tree[child_idx]
      if tree[idx] > tree[child_idx]
        swap(idx, child_idx, :bubble_down)
        break
      end
    end
    self
  end

end

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

