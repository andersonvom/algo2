#!/usr/bin/ruby

class Scheduling

  attr_accessor :jobs

  def initialize
    self.jobs = []
  end

  def add_job(job)
    self.jobs << job
  end

  def job_score(job)
    job[:weight] - job[:length]
  end

  def job_ratio(job)
    job[:weight].to_f / job[:length]
  end

  def diff_weight_length(job1, job2)
    job_score(job2) - job_score(job1)
  end

  def heigher_weight(job1, job2)
    job2[:weight] - job1[:weight]
  end

  def run_score
    self.jobs.sort! do |job1,job2|
      comp = diff_weight_length(job1, job2)
      comp != 0 ? comp : heigher_weight(job1, job2)
    end
  end

  def run_ratio
    self.jobs.sort! do |job1,job2|
      job_ratio(job2) <=> job_ratio(job1)
    end
  end

  def result
    weighted_sum = 0
    completion_time = 0
    self.jobs.each do |j|
      completion_time += j[:length]
      weighted_sum += completion_time * j[:weight]
    end
    weighted_sum
  end

end

if __FILE__ == $0
  s = Scheduling.new
  jobs = gets.to_i
  jobs.times do |i|
    j = {}
    j[:weight], j[:length] = gets.split(" ").map { |num| num.to_i }
    s.add_job j
  end
  s.run_score
  puts "Weighted sum (using difference): #{s.result}"
  s.run_ratio
  puts "Weighted sum (using job ratio):  #{s.result}"
end

