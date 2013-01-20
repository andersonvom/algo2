require './graph.rb'

class FloydWarshall
  attr_accessor :graph, :path_lengths

  def initialize(graph)
    self.graph = graph
  end

  def run(first_vertex = 1)
    num_vertices = graph[:num_vertices]
    vertices = (first_vertex..num_vertices)
    self.path_lengths = Array.new(num_vertices+1) { Array.new(num_vertices+1) { Array.new(num_vertices+1) } } # padding
    shortest_path = Float::INFINITY

    # Initialize
    vertices.each do |i|
      vertices.each do |j|
        length = Float::INFINITY
        length = 0 if i == j
        length = graph[:edges][i][j] if graph[:edges][i][j]
        path_lengths[i][j][0] = length
        shortest_path = length if length < shortest_path
      end
    end

    # Run
    (1..num_vertices-1).each do |k|
      vertices.each do |i|
        vertices.each do |j|
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
  input = $1 ? File.open($1) : STDIN
  graph = Graph.read_graph(input)
  apsp = FloydWarshall.new(graph)
  puts apsp.run
end

