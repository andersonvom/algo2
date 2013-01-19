require './graph.rb'

class FloydWarshall
  attr_accessor :graph, :path_lengths

  def initialize(graph)
    self.graph = graph
  end

  def run
    vertices = graph.all_vertices
    num_vertices = vertices.size
    edges = graph.all_edges
    self.path_lengths = Array.new(num_vertices) { Array.new(num_vertices) { Array.new(num_vertices) } }
    shortest_path = Float::INFINITY

    # Initialize
    num_vertices.times do |i|
      num_vertices.times do |j|
        vi, vj = vertices[i], vertices[j]
        length = Float::INFINITY
        length = 0 if i == j
        length = edges["#{vi.id},#{vj.id}"].length if edges["#{vi.id},#{vj.id}"]
        path_lengths[i][j][0] = length
        shortest_path = length if length < shortest_path
      end
    end

    # Run
    (1..num_vertices-1).each do |k|
      num_vertices.times do |i|
        num_vertices.times do |j|
          length = [
            path_lengths[i][j][k-1],
            path_lengths[i][k][k-1] + path_lengths[k][j][k-1]
          ].min
          path_lengths[i][j][k] = length
          shortest_path = length if length < shortest_path
          return false if i == j and length < 0 # negative-cost cycle
        end
      end
    end
    
    shortest_path
  end
end

if $0 == __FILE__
  num_vertices, num_edges = gets.split(" ").map { |i| i.to_i }

  graph = Graph.new
  num_edges.times do
    idx1, idx2, length = gets.split(" ").map { |i| i.to_i }
    v1 = graph.vertices[idx1] || Vertex.new(idx1)
    v2 = graph.vertices[idx2] || Vertex.new(idx2)
    e = Edge.new v1, v2, {length: length}
    graph.add_vertex v1, v2
  end

  apsp = FloydWarshall.new(graph)
  puts apsp.run
end

