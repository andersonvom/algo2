class UnionFind
  attr_accessor :groups, :elements

  def initialize
    self.elements = {}
    self.groups = {}
  end

  def add(*elems)
    elems.each do |elem|
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
    leader1 = elements[elem1.id]
    leader2 = elements[elem2.id]
    return self if leader1 == leader2

    # switch groups if groups2 if bigger than group1 to minimize operations
    if groups[leader1.id][:count] < groups[leader2.id][:count]
      leader1, leader2 = leader2, leader1
    end

    group2 = groups[leader2.id]
    group2.each do |elem|
      self.elements[elem.id] = leader1
      self.groups[leader1.id][:elements].push elem
    end
    self.groups.delete leader2.id
    self
  end

end

