#!/usr/bin/ruby

class PrimsMST

end

if __FILE__ == $0

  num_nodes, num_edges = gets.split(" ").map { |num| num.to_i }
  puts "#{num_nodes} #{num_edges}"

  num_edges.times do |i|
    v1, v2, cost = gets.split(" ").map { |num| num.to_i }
    puts "#{v1} #{v2} #{cost}"
  end

end

