require 'rspec'
require './01.graph.rb'

class UnionFind
  attr_accessor :groups, :elements

  def initialize
    self.elements = {}
    self.groups = {}
  end

  def add(*elems)
    elems.each do |elem|
      next unless elem
      leader = elem
      self.elements[elem.id] = leader
      self.groups[leader.id] = { elements: [elem], count: 1 }
    end
  end
  
  def find(elem)
    return unless elem
    elements[elem.id]
  end

  def union(elem1, elem2)
    return self if elem1.nil? or elem2.nil?

    leader1 = elements[elem1.id]
    leader2 = elements[elem2.id]
    return self if leader1 == leader2
    return self if leader1.nil? or leader2.nil?

    # switch groups if groups2 if bigger than group1 to minimize operations
    if groups[leader1.id][:count] < groups[leader2.id][:count]
      leader1, leader2 = leader2, leader1
    end

    group2 = groups[leader2.id][:elements]
    group2.each do |elem|
      self.elements[elem.id] = leader1
      self.groups[leader1.id][:elements].push elem
      self.groups[leader1.id][:count] += 1
    end
    self.groups.delete leader2.id
    self
  end

end

describe UnionFind do

  before :each do
    @u = UnionFind.new
    @v1, @v2, @v3, @v4 = 4.times.map { Vertex.new rand(100) }
  end

  it "should initialize empty elements" do
    @u.elements.should be_empty
  end

  it "should initialize empty groups" do
    @u.groups.should be_empty
  end

  it "should add a new element to a new group" do
    @u.add @v1
    @u.groups[@v1.id].should == { elements: [@v1], count: 1 }
    @u.elements[@v1.id].should == @v1
  end

  it "should add several elements to new groups" do
    @u.add @v1, @v2, @v3
    @u.groups.size.should == 3
    @u.elements.size.should == 3
  end

  it "should not add nil elements" do
    @u.add nil
    @u.elements.should be_empty
    @u.groups.should be_empty
  end

  it "should find the group of a certain element" do
    @u.add @v1
    @u.find(@v1).should == @v1
  end

  it "should return nil when element not found" do
    @u.find(@v1).should be_nil
  end

  it "should be able to merge groups" do
    @u.add @v1, @v2, @v3
    @u.union @v1, @v2
    @u.groups.size.should == 2
  end

  it "should update group count when merging" do
    @u.add @v1, @v2, @v3
    @u.union @v1, @v2
    @u.groups[@v1.id][:count].should == 2
    @u.groups[@v3.id][:count].should == 1
  end

  it "should not merge nil groups" do
    @u.union nil, nil
    @u.elements.should be_empty
    @u.groups.should be_empty
  end

  it "should not merge inexistent elements" do
    @u.add @v1, @v2, @v3
    @u.union @v1, @v4
    @u.elements.size.should == 3
    @u.groups.size.should == 3
  end

  it "should find the same leader for elements in the same group" do
    @u.add @v1, @v2
    @u.union @v1, @v2
    @u.find(@v1).should == @u.find(@v2)
  end

  it "should find different leaders for elements in different groups" do
    @u.add @v1, @v2, @v3
    @u.union @v1, @v2
    @u.find(@v1).should_not == @u.find(@v3)
  end

end

