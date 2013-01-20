require './graph.rb'

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
    shortest_path = Float::INFINITY

    # Initialize
    path_lengths[0][source.id] = 0
    improved_results = false

    (1..num_vertices-1).each do |i|
      improved_results = false
      vertices.each do |vertex|

        v = vertex.id
        in_edges = vertex.edges.map { |e| e if e.vertices.last == vertex }.compact
        w_vertices = in_edges.map { |e| e.vertices.first }
        min_w_length = w_vertices.map { |w| path_lengths[i-1][w.id] + edges["#{w.id},#{v}"].length }.min
        min_w_length ||= Float::INFINITY # if no in-edges, cost is infinite

        path_lengths[i][v] = [ path_lengths[i-1][v], min_w_length ].min
        shortest_path = path_lengths[i][v] if path_lengths[i][v] < shortest_path
        improved_results = true if path_lengths[i][v] < path_lengths[i-1][v]
      end
      break unless improved_results # found shortest paths sooner
    end

    return false if improved_results
    shortest_path
  end
end

def read_graph(input)
  info = input.lines.to_a if input.is_a? File
  data = gets if input == STDIN
  data = info.shift if input.is_a? File
  num_vertices, num_edges = data.split(" ").map { |i| i.to_i }

  graph = Graph.new
  num_edges.times do
    data = gets if input == STDIN
    data = info.shift if input.is_a? File
    idx1, idx2, length = data.split(" ").map { |i| i.to_i }
    v1 = graph.vertices[idx1] || Vertex.new(idx1)
    v2 = graph.vertices[idx2] || Vertex.new(idx2)
    e = Edge.new v1, v2, {length: length}
    graph.add_vertex v1, v2
  end

  graph
end

if $0 == __FILE__
  input = $1 ? File.open($1) : STDIN
  graph = read_graph(input)

  bf = BellmanFord.new(graph)
  source = graph.vertices[1]
  puts bf.run(source)
end

