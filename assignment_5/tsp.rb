require './graph.rb'
require 'pry'

class TSP
  attr_accessor :graph, :path_costs

  def initialize(a_graph)
    self.graph = a_graph.dup
  end
  
  def generate_sets(start, last, size)
    # sequences must contain `start`
    # so we remove `start`, choose `size-1`
    (start+1..last).to_a.combination(size-1)
  end
  
  def combine(set, first, last, max_level, &block)
    i = first
    while (i <= last-max_level+1)
      set[i] = 1
      if max_level == 1
        yield set
      else
        combine(set, i+1, last, max_level-1, &block)
      end
      set[i] = 0
      i += 1
    end
  end
  
  def combine_binary(num, first, last, max_level, &block)
    i = first
    while (i <= last-max_level+1)
      mask = 1 << i
      num |= mask # set i-th bit to 1 (or)
      if max_level == 1
        yield num
      else
        combine_binary(num, i+1, last, max_level-1, &block)
      end
      num ^= mask # set i-th bit to 0 (xor)
      i += 1
    end
  end
  
  def run
    num_vertices = graph[:num_vertices]
    set = 0b10
    
    self.path_costs = Hash.new { |hash, key| hash[key] = Hash.new { |hash, key| hash[key] = Array.new(num_vertices+1) { Float::INFINITY } } }
    path_costs[1][set][1] = 0
    
    (2..num_vertices).each do |m|
      puts "#{m}: #{Time.now}"
      combine_binary(set, 2, num_vertices, m-1) do |set|
        j = 1
        while j < num_vertices
          j += 1
          mask_j = 1 << j
          next if (set & mask_j) == 0
          min_cost = Float::INFINITY
          k = 0
          while k < num_vertices
            k += 1
            mask_k = 1 << k
            next if (set & mask_k) == 0 or k == j
            previous_set = set ^ mask_j # set j-th bit to zero (xor)
            cost = path_costs[m-1][previous_set][k] + graph[:edges][k][j]
            min_cost = cost if cost < min_cost
          end
          path_costs[m][set][j] = min_cost
        end
      end
      path_costs.delete(m-1)
    end
    
    final_set = ("1" * num_vertices + "0").to_i(2)
    results = []
    (2..num_vertices).each do |j|
      results << path_costs[num_vertices][final_set][j] + graph[:edges][j][1]
    end
    
    results.min
  end

end

if $0 == __FILE__
  input = ARGV[0] ? File.open(ARGV[0]) : STDIN
  lines = input.lines.to_a
  num_cities = lines.shift.to_i
  cities = lines.map { |i| i.split(" ").map { |j| j.to_f } }
  cities.insert(0, [0,0]) # padding to ease calculations
  num_edges = (1..num_cities).to_a.combination(2).to_a.size * 2
  
  data = []
  data << [num_cities, num_edges].join(" ")
  (1..num_cities).to_a.combination(2) do |i, j|
    euclidean_distance = Math.sqrt((cities[i][0] - cities[j][0])**2 + (cities[i][1] - cities[j][1])**2)
    data << [i, j, euclidean_distance].join(" ")
    data << [j, i, euclidean_distance].join(" ")
  end
  
  graph = Graph.read_graph(data)
  results = TSP.new(graph).run
  puts results
end

