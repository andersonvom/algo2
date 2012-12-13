#!/usr/bin/ruby

class Heap
  attr_accessor :tree

  def initialize(*ary)
    self.tree = [nil] # first element is padded w/nil to speed calculations
    elems = ary
    elems = ary.first if ary.count == 1
    add *elems
  end

  def add(*elems)
    elems.each do |elem|
      self.tree << elem
      bubble_up elem, tree.size-1
    end
    self
  end

  def delete_minimum
    delete_at(1)
  end

  def delete_at(idx)
    return unless tree[idx]
    return tree.delete_at(idx) if idx == tree.count - 1

    elem = self.tree[idx]
    last = self.tree.delete_at -1
    self.tree[idx] = last if self.tree[idx]
    bubble_up tree[idx], idx
    bubble_down tree[idx], idx
    elem
  end

  def swap(idx1, idx2, next_operation)
    self.tree[idx1], self.tree[idx2] = [tree[idx2], tree[idx1]]
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

