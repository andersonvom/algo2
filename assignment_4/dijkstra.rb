require './graph.rb'

class Dijkstra
  attr_accessor :graph

  def initialize(a_graph)
    self.graph = a_graph.dup
  end

  def run(source)
    
  end
end

if $0 == __FILE__
  input = $1 ? File.open($1) : STDIN
  graph = Graph.read_input(input)
  d = Djikstra.new(graph)
  puts d.run(1)
end

