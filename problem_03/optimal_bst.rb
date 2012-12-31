class OptimalBST
  def self.cost(keys, frequencies)
    cost = Array.new(keys.size) { Array.new(keys.size) }
    (0..keys.size-1).each do |s|
      keys.size.times do |i|
        freq_sum = frequencies[i..i+s].reduce(0) { |sum, i| sum + i }
        values = []
        (i..i+s).each do |r|
          cost_t1 = cost[i][r-1] unless r-1 < 0
          cost_t2 = cost[r+1][i+s] if r+1 < keys.size
          cost_r = (freq_sum + cost_t1.to_f + cost_t2.to_f).round(5)
          values << cost_r
        end
        cost[i][i+s] = values.min
      end
    end
    cost[0][-1]
  end
end

if __FILE__ == $0
  keys  = [1, 2, 3, 4, 5, 6, 7]
  freqs = [0.05, 0.40, 0.08, 0.04, 0.10, 0.10, 0.23]
  puts OptimalBST.cost(keys, freqs)
end
