#!/usr/bin/ruby

class Vertex
  attr_accessor :id, :edges, :params

  def initialize(id, params = {})
    self.id = id
    self.params = params
  end

  def neighbors
    self.edges.map { |e| e.vertices - self }
  end

  def add_edge(e)
    self.edges << e
    self
  end

  def to_s
    "#{id}: [ #{edges.join(", ")} ]"
  end

end

class Edge
  attr_accessor :v1, :v2, :cost

  def initialize(v1, v2, cost)
    self.v1 = v1.add_edge(self)
    self.v2 = v2.add_edge(self)
    self.cost = cost
  end

  def vertices
    [v1, v2]
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
    "(#{v1.id}...#{cost}...#{v2.id})"
  end
end

class Graph
  attr_accessor :vertices

  def initialize(*ary)
    self.vertices = Hash.new
    vertices = ary
    vertices = ary.first if ary.count == 1
    vertices.each do |v|
      add_vertex v
    end
  end

  def add_vertex(*vertices)
    vertices.each do |v|
      self.vertices[v.id] = v
    end
  end

  def all_edges
    edges = []
    all_vertices.each do |v|
      edges += v.edges
    end
    edges.uniq
  end

  def all_vertices
    self.vertices.values
  end

end

