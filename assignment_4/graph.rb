class Graph

  def self.read_graph(input)
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

  def self.generate_input(num_vertices)
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

end

