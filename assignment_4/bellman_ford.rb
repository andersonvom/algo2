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

def read_graph(input)
  info = input
  info = input.lines.to_a if input.is_a? File
  data = gets if input == STDIN
  data = info.shift if input != STDIN
  num_vertices, num_edges = data.split(" ").map { |i| i.to_i }

  edges = Hash.new { |hash, key| hash[key] = {} }
  in_edges = Hash.new { |hash, key| hash[key] = {} }
  graph = {num_vertices: num_vertices, num_edges: num_edges, edges: edges, in_edges: in_edges}
  num_edges.times do
    data = gets if input == STDIN
    data = info.shift if input != STDIN
    idx1, idx2, length = data.split(" ").map { |i| i.to_i }
    graph[:edges][idx1].store(idx2, length)
    graph[:in_edges][idx2].store(idx1, length)
  end

  graph
end

def generate_graph_input(num_vertices)
  data = []
  total_edges = 0
  num_vertices.times do |i|
    v1 = i+1
    num_edges = rand(num_vertices / 3)+1
    total_edges += num_edges
    num_edges.times do |j|
      v2 = rand(num_vertices)+1
      if v1 == v2
        total_edges -= 1
        next
      end
      length = rand(100) * ( (i==0 and j==0) ? -1 : 1 )
      data << "#{v1} #{v2} #{length}"
    end
  end
  data.sort.insert(0, "#{num_vertices} #{total_edges}")
end

if $0 == __FILE__
  require 'pry'
  input = $1 ? File.open($1) : STDIN
  graph = read_graph(input)
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

