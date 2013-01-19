#!/usr/bin/ruby

module CustomParams
  def method_missing(sym, *args, &block)
    return custom_params(sym, *args, &block) if params_method(sym)
    super(sym, *args, &block)
  end

  def custom_params(sym, *args, &block)
    sym_str = sym.to_s
    if sym_str =~ /=$/
      params[sym_str.gsub(/=$/,"").to_sym] = args.first
    else
      params[sym]
    end
  end

  def params_method(sym)
    sym.to_s =~ /.*/
  end
end

class Vertex
  attr_accessor :id, :edges, :params
  include CustomParams

  def initialize(id, params = {})
    self.id = id
    self.edges = []
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
  attr_accessor :v1, :v2, :params
  include CustomParams

  def initialize(v1, v2, params = {})
    self.v1 = v1.add_edge(self)
    self.v2 = v2.add_edge(self)
    self.params = params
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

  def to_s
    "(#{v1.id}...#{params}...#{v2.id})"
  end
end

class Graph
  attr_accessor :vertices

  # Usage:
  #   g = Graph.new
  #   g = Graph.new v
  #   g = Graph.new v1, v2, v3,...
  #   g = Graph.new [v1, v2, v3,...]
  def initialize(*ary)
    self.vertices = Hash.new
    vertices = ary
    vertices = ary.first if ary.count == 1 and ary.first.is_a? Array
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

