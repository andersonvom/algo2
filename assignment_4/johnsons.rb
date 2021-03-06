require './graph.rb'
require './bellman_ford.rb'
require './dijkstra.rb'

class Johnsons
  attr_accessor :graph, :graph_shifted, :weight_shifts, :path_distances

  def initialize(a_graph)
    self.graph = a_graph.dup
    self.graph_shifted = Graph.empty_graph
    self.path_distances = {}
  end

  def shift_weight(u, v, length)
    length + weight_shifts[u] - weight_shifts[v]
  end

  def unshift_weights(u, distances)
    unshifted_distances = {}
    distances.each do |v, dist|
      unshifted_distances[v] = dist - weight_shifts[u] + weight_shifts[v] 
    end
    unshifted_distances
  end

  def run
    yield :bellman_ford if block_given?
    self.weight_shifts = BellmanFord.new(graph).weight_shifts
    return false unless weight_shifts # negative-cost cycle detected!

    # shift weights in G
    yield :shift_weights if block_given?
    graph_shifted[:num_vertices] = graph[:num_vertices]
    graph_shifted[:num_edges] = graph[:num_edges]
    graph[:edges].each do |u, edges|
      edges.each do |v, length|
        graph_shifted[:edges][u].store(v, shift_weight(u, v, length))
      end
    end

    yield :dijkstra if block_given?
    vertices = (1..graph_shifted[:num_vertices]).to_a
    vertices.each do |u|
      distances = Dijkstra.new(graph_shifted).run(u)
      path_distances[u] = unshift_weights(u, distances)
    end

    yield :done if block_given?
    path_distances
  end

end

if $0 == __FILE__
  input = $1 ? File.open($1) : STDIN
  graph = Graph.read_graph(input)
  results = Johnsons.new(graph).run { |e| puts e.to_s; system "date" }
  shortest_shortest = results.map { |v, dist| dist.values.min }.min if results
  puts shortest_shortest
end

