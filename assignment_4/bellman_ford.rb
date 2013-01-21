require './graph.rb'

class BellmanFord
  attr_accessor :graph, :path_lengths

  def initialize(a_graph)
    self.graph = a_graph.dup

    # add dummy vertex with 0-length edges to all vertices to allow negative-cost cycle detection
    dummy_vertex = 0
    graph[:num_vertices].times do |i|
      v = i+1
      graph[:edges][dummy_vertex].store(v, 0)
      graph[:in_edges][v].store(dummy_vertex, 0)
    end
  end

  def run(source, first_vertex = 1)
    num_vertices = graph[:num_vertices]
    self.path_lengths = Array.new(num_vertices+1) { Array.new(num_vertices+1) { Float::INFINITY } } # +1 padding to optimize index resolution

    # Initialize
    path_lengths[first_vertex][source] = 0
    improved_results = false

    ((first_vertex+1)..graph[:num_vertices]).each do |i|
      improved_results = false
      graph[:num_vertices].times do |j|
        v = j + first_vertex # vertices range from 1..n
        w_vertices = graph[:in_edges][v].keys
        min_w_length = w_vertices.map { |w| path_lengths[i-1][w] + graph[:edges][w][v] }.min
        min_w_length ||= Float::INFINITY # if no in-edges, cost is infinite

        path_lengths[i][v] = [ path_lengths[i-1][v], min_w_length ].min
        improved_results = true if path_lengths[i][v] < path_lengths[i-1][v]
      end

      # shortest paths will be found at most at iteration n-1
      # last iteration (n) should not improve results, unless there is a negative-cost cycle
      return path_lengths[i] unless improved_results
    end

    false # there is a negative-cost cycle
  end

  def weight_shifts
    graph[:num_vertices] += 1
    weight_shifts = run(0, 0)
    graph[:num_vertices] -= 1
    weight_shifts
  end

  def negative_cycle?
    !(weight_shifts and true)
  end

end

if $0 == __FILE__
  input = $1 ? File.open($1) : STDIN
  graph = Graph.read_graph(input)
  bf = BellmanFord.new(graph)
  puts bf.run(source).inspect
end

