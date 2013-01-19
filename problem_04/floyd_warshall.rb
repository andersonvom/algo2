
# Floyd-Warshall will compute the shortest path between any vertices u and v
def floyd_warshall()
  edges = %w( 0,1  1,2  2,3  1,3 )
  num = edges.join.gsub(",","").split("").uniq.size

  a = Array.new(num) { Array.new(num) { Array.new(num) } }
  
  # initialize
  num.times do |k|
    num.times do |i|
      num.times do |j|
        a[i][j][k] = Float::INFINITY
        a[i][j][k] = 0 if i == j
        a[i][j][k] = 1 if edges.include? "#{i},#{j}"
      end
    end
  end

  # run
  (1..num-1).each do |k|
    num.times do |i|
      num.times do |j|
        a[i][j][k] = [
          a[i][j][k-1],
          a[i][k][k-1] + a[k][j][k-1]
        ].min
      end
    end
  end

  # print
  num.times do |i|
    num.times do |j|
      puts "#{i},#{j}: #{a[i][j][num-1]}"
    end
  end

end


# What does this variation compute?
def floyd_warshall_variation()
  edges = %w( 0,1  1,2  2,3  1,3 )
  num = edges.join.gsub(",","").split("").uniq.size

  a = Array.new(num) { Array.new(num) { Array.new(num) } }
  
  # initialize
  num.times do |k|
    num.times do |i|
      num.times do |j|
        a[i][j][k] = Float::INFINITY
        a[i][j][k] = 0 if i == j
        a[i][j][k] = 1 if edges.include? "#{i},#{j}"
      end
    end
  end

  # run
  (1..num-1).each do |k|
    num.times do |i|
      num.times do |j|
        a[i][j][k] = [
          a[i][j][k-1] +
          a[i][k][k-1] * a[k][j][k-1]
        ].min
      end
    end
  end

  # print
  num.times do |i|
    num.times do |j|
      puts "#{i},#{j}: #{a[i][j][num-1]}"
    end
  end

end


