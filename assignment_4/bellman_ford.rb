
class BellmanFord
  attr_accessor :graph, :path_lengths

  def initialize(graph)
    self.graph = graph
  end

  def run(source)
    vertices = graph.all_vertices
    num_vertices = vertices.size
    edges = graph.all_edges
    self.path_lengths = Array.new(num_vertices+1) { Array.new(num_vertices+1) { Float::INFINITY } }

    # Initialize
    path_lengths[0][source.id] = 0

    (1..num_vertices-1).each do |i|
      improved_results = false
      vertices.each do |vertex|
        v = vertex.id
        in_edges = vertex.edges.map { |e| e if e.vertices.last == vertex }.compact
        w_vertices = in_edges.map { |e| e.vertices.first }
        length = [
          path_lengths[i-1][v],
          w_vertices.map { |w| path_lengths[i-1][w.id] + e.length }.min
        ].min
        if length < path_lengths[i][v]
          path_lengths[i][v] = length
          improved_results = true
        end
      end
      break unless improved_results
    end

    !improved_results
  end
end

