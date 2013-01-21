#!/usr/bin/ruby

class Heap
  attr_accessor :tree, :indices

  def initialize(*ary)
    self.tree = [nil] # first element is padded w/nil to speed calculations
    self.indices = {}
    elems = ary
    elems = ary.first if ary.count == 1
    add *elems
  end

  def add(*elems)
    elems.each do |elem|
      self.tree << elem
      indices[elem] = tree.size-1
      bubble_up elem, tree.size-1
    end
    self
  end

  def delete_minimum
    delete_at(1)
  end

  def delete(elem)
    return unless elem
    delete_at( indices[elem] ) if indices[elem]
  end

  def delete_at(idx)
    return unless tree[idx] # no such element

    elem = tree[idx]
    indices.delete(elem)

    # removing last element, nothing special to do
    return tree.delete_at(idx) if idx == tree.size - 1

    # removing someone in the middle
    last = tree.delete_at -1
    tree[idx] = last
    indices[last] = idx
    bubble_up tree[idx], idx
    bubble_down tree[idx], idx
    elem
  end

  def swap(idx1, idx2, next_operation)
    elem1, elem2 = tree[idx1], tree[idx2]
    indices[elem1], indices[elem2] = idx2, idx1
    tree[idx1], tree[idx2] = elem2, elem1
    send(next_operation, tree[idx2], idx2)
  end

  def bubble_up(elem, idx)
    return self if idx == 1
    parent_idx = idx/2
    swap(idx, parent_idx, :bubble_up) if tree[parent_idx] > tree[idx]
    self
  end

  def bubble_down(elem, idx)
    children_indices = [idx*2, idx*2+1].sort do |x, y|
      tree[y] ? (tree[x] <=> tree[y]) : -1
    end
    children_indices.each do |child_idx|
      next unless tree[child_idx]
      if tree[idx] > tree[child_idx]
        swap(idx, child_idx, :bubble_down)
        break
      end
    end
    self
  end

end

