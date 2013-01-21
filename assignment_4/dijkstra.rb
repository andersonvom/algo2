require './graph.rb'
require './heap.rb'

class Distance
  attr_accessor :vertex, :distance

  def initialize(v, dist)
    self.vertex = v
    self.distance = dist
  end

  def <(d)
    self.distance < d.distance
  end

  def >(d)
    self.distance > d.distance
  end

  def <=>(d)
    self.distance <=> d.distance
  end
end

class Dijkstra
  attr_accessor :graph, :path_lengths, :previous_vertex

  def initialize(a_graph)
    self.graph = a_graph.dup
  end

  def run(source)
    self.previous_vertex = Array.new(graph[:num_vertices])
    vertices = (1..graph[:num_vertices]).to_a
    distances = {}
    vertices.each { |v| distances[v] = Distance.new v, Float::INFINITY }
    distances[source].distance = 0
    heap = Heap.new distances.values

    while heap_u = heap.delete_minimum
      u = heap_u.vertex
      dist_u = heap_u.distance
      break if dist_u == Float::INFINITY # no more reachable vertices

      graph[:edges][u].each do |v, length|
        total_distance = dist_u + length
        if total_distance < distances[v].distance
          heap.modify(distances[v]) { |e| e.distance = total_distance }
          previous_vertex[v] = u
        end
      end
    end
    distances
  end
end

if $0 == __FILE__
  require 'pry'
  input = $1 ? File.open($1) : STDIN
  graph = Graph.read_graph(input)
  d = Dijkstra.new(graph)
  d.run(1).map { |i| puts i.inspect}
end

