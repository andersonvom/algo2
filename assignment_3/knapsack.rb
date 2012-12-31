class Knapsack
  attr_accessor :items, :capacity, :results, :undefined

  def initialize(items, capacity)
    self.items = items.sort_by { |i| i[:weight] }
    self.capacity = capacity
    self.results = Hash.new { |hash, key| hash[key] = {} }
    self.undefined = Float::INFINITY * -1
  end

  def maximize_value(current_item = self.items.size-1, capacity = self.capacity)
    return undefined if capacity < 0
    return 0 if current_item < 0
    return results[current_item][capacity] if results[current_item][capacity]
    item = items[current_item]
    including_item = maximize_value(current_item-1, capacity-item[:weight]) + item[:value]
    excluding_item = maximize_value(current_item-1, capacity)
    results[current_item][capacity] = [including_item, excluding_item].max
  end

end

if $0 == __FILE__
  capacity, num_items = gets.split(" ").map { |i| i.to_i }

  items = []
  num_items.times do
    value, weight = gets.split(" ").map { |i| i.to_i }
    items << { value: value, weight: weight }
  end
  k = Knapsack.new(items, capacity)
  puts k.maximize_value
end

