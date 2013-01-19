
class FloydWarshall
  attr_accessor :graph, :path_lengths

  def initialize(graph)
    self.graph = graph
  end

  def run
    num_vertices = graph.all_vertices.size
    self.path_lengths = Array.new(num_vertices) { Array.new(num_vertices) { Array.new(num_vertices) } }
    edges = graph.all_edges
    shortest_path = Float::INFINITY

    # Initialize
    num_vertices.times do |i|
      num_vertices.times do |j|
        length = Float::INFINITY
        length = 0 if i == j
        length = edges["#{i},#{j}"].length if edges["#{i},#{j}"]
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

