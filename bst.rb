class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    data <=> other.data
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    array = array.uniq.sort
    @root = build_tree(array)
  end

  def insert(value)
    @root = insert_rec(@root, value)
  end

  def delete(value)
    @root = delete_rec(@root, value)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def build_tree(array, start = 0, stop = array.length - 1)
    return nil if start > stop

    mid = (start + stop) / 2

    root = Node.new(array[mid])
    root.left = build_tree(array, start, mid - 1)
    root.right = build_tree(array, mid + 1, stop)

    root
  end

  def insert_rec(node, value)
    return Node.new(value) if node.nil?

    if value < node.data
      node.left = insert_rec(node.left, value)
    elsif value > node.data
      node.right = insert_rec(node.right, value)
    end

    node
  end

  def delete_rec(node, value)
    return nil if node.nil?

    if value < node.data
      node.left = delete_rec(node.left, value)
    elsif value > node.data
      node.right = delete_rec(node.right, value)
    else
      # Node with only one child or no child
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      # Node with two children: get the inorder successor (smallest in right subtree)
      min_larger_node = find_min(node.right)
      node.data = min_larger_node.data
      node.right = delete_rec(node.right, min_larger_node.data)
    end

    node
  end

  def find_min(node)
    node = node.left while node.left

    node
  end
end
