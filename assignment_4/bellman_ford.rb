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
    shortest_path = Float::INFINITY

    # Initialize
    path_lengths[first_vertex][source] = 0
    improved_results = false
    shortest_path = Float::INFINITY

    ((first_vertex+1)..graph[:num_vertices]).each do |i|
      improved_results = false
      graph[:num_vertices].times do |j|
        v = j + first_vertex # vertices range from 1..n
        w_vertices = graph[:in_edges][v].keys
        min_w_length = w_vertices.map { |w| path_lengths[i-1][w] + graph[:edges][w][v] }.min
        min_w_length ||= Float::INFINITY # if no in-edges, cost is infinite

        path_lengths[i][v] = [ path_lengths[i-1][v], min_w_length ].min
        shortest_path = path_lengths[i][v] if path_lengths[i][v] < shortest_path
        improved_results = true if path_lengths[i][v] < path_lengths[i-1][v]
      end

      # shortest paths will be found at most at iteration n-1
      # last iteration (n) should not improve results, unless there is a negative-cost cycle
      unless improved_results
        shortest_path = path_lengths[i].min
        return shortest_path
      end
    end

    false # there is a negative-cost cycle
  end

  def negative_cycle?
    graph[:num_vertices] += 1
    negative_cycle = !(run(0, 0) and true)
    graph[:num_vertices] -= 1
    negative_cycle
  end

end

if $0 == __FILE__
  input = $1 ? File.open($1) : STDIN
  graph = Graph.read_graph(input)
  bf = BellmanFord.new(graph)
  shortest_shortest_path = Float::INFINITY
  (1..graph[:num_vertices]).each do |source|
    s = Time.now
    shortest_path = bf.run(source) || Float::INFINITY
    shortest_shortest_path = shortest_path if shortest_path < shortest_shortest_path
    e = Time.now
    puts "source ##{source}: #{shortest_path} in #{e-s} seconds"
  end
  puts "Shortest shortest path: #{shortest_shortest_path}"
end

