# Class containing node data and allowing comparison between two nodes based on there data
class Node
  include Comparable
  attr_accessor :data, :left, :right
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
  def <=>(other)
    if other.nil?
      @data <=> other
    else
      @data <=> other.data
    end
  end
end

# Class containing tree data and functions
class Tree
  attr_accessor :root
  def initialize(array)
    @array = array.uniq.sort
    @queue = []
  end

  # Method to recursively build a tree from a sorted array containing unique values
  def build_tree(array = @array, start = 0, final = array.length)
    if start > final
      return nil
    else
      mid = (start + final) / 2
      root = Node.new(array[mid])
      root.left = build_tree(array, start, (mid - 1))
      root.right = build_tree(array, (mid + 1), final)
      @root = root
      return root
    end
  end

  # Takes a value, creates a node, and uses #place_node to find it's spot on the tree
  def insert(value)
    new_node = Node.new(value)
    place_node(new_node, @root)
  end

  def place_node(new_node, node)
    if new_node <= node
      if node.left == nil
        node.left = new_node
      else
        place_node(new_node, node.left)
      end
    else
      if node.right == nil
        node.right = new_node
      else
        place_node(new_node, node.right)
      end
    end
  end

  # Method for deleting items from the tree
  def delete(value, node = @root)
    # Searches left if valuse smaller than node data
    if value < node.data
      if node.left.data == value
        if node.left.left == nil && node.left.right == nil
          node.left = nil
        elsif node.left.left == nil && node.left.right != nil
          node.left = node.left.right
        elsif node.left.left != nil && node.left.right == nil
          node.left = node.left.left
        else
          node.left.data = find_next(node.left.right)
        end
      else
        delete(value, node.left)
      end
    # Searches right if value is larger that node data
    elsif value > node.data
      if node.right.data == value
        if node.right.left == nil && node.right.right == nil
          node.right = nil
        elsif node.right.left == nil && node.right.right != nil
          node.right = node.right.right
        elsif node.right.left != nil && node.right.right == nil
          node.right = node.right.left
        else
          node.right.data = find_next(node.right.right)
        end
      else
        delete(value, node.right)
      end
    else
      node.data = find_next(node.right)
    end
  end

  # Finds the next highest value node, used for deleting a node with two children
  def find_next(node)
    if node.left == nil
      next_value = node.data
      delete(node.data)
      return next_value
    else
      find_next(node.left)
    end
  end

  # Given a value returns the matching node, nil if no match
  def find(value, node = @root)
    if node == nil
      return nil
    else
      if value == node.data
        return node
      elsif value < node.data
        return find(value, node.left)
      else
        return find(value, node.right)
      end
    end
  end

  # Creates a level order array of the tree
  def level_order(node = @root)
    array = []
    if node.left == nil && node.right == nil
      return node.data
    else
      @queue.unshift(node.left) unless node.left == nil
      @queue.unshift(node.right) unless node.right == nil
      until @queue.empty?
        array.push(level_order(@queue.pop))
      end
      array.unshift(node.data)
    end
    array.flatten
  end

  # Method for preorder traversal of the tree
  def preorder(node = @root)
    array = []
    if node.left && node.right == nil
      return node.data
    else
      array.push(node.data)
      array.push(preorder(node.left)) unless node.left == nil
      array.push(preorder(node.right)) unless node.right == nil
    end
    array.flatten
  end

  # Method for inorder traversal of the tree
  def inorder(node = @root)
    array = []
    if node.left && node.right == nil
      return node.data
    else
      array.push(inorder(node.left)) unless node.left == nil
      array.push(node.data)
      array.push(inorder(node.right)) unless node.right == nil
    end
    array.flatten
  end

  # Method for postorder traversal of the tree
  def postorder(node = @root)
    array = []
    if node.left && node.right == nil
      return node.data
    else
      array.push(postorder(node.left)) unless node.left == nil
      array.push(postorder(node.right)) unless node.right == nil
      array.push(node.data)
    end
    array.flatten
  end

  # Method returns the height of a given node
  def height(node, height = 0)
    if node.left == nil && node.right == nil
      return height
    else
      left = 0
      right = 0
      left = height(node.left, height + 1) unless node.left == nil
      right = height(node.right, height + 1) unless node.right == nil
      if right == nil || left > right
        return left
      else
        return right
      end
    end
  end

  # Method that returns a nodes depth
  def depth(node)
    height(@root) - height(node)
  end

  # Boolean method, returns true if the binary tree is balanced
  def balanced?
    if (height(@root.left) - height(root.right)).abs <= 1
      true
    else
      false
    end
  end

  # Rebalances tree
  def rebalance
    build_tree(level_order.sort.uniq)
  end

  # Method creating a visual representation of the array, shared by another student
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

# Function that shows some of the functions of the tree class
def driver
  array = Array.new(25) { rand(1..100) }
  tree = Tree.new(array)
  tree.build_tree
  tree.pretty_print
  p tree.balanced?
  tree.insert(101)
  tree.insert(105)
  tree.insert(106)
  tree.insert(109)
  tree.pretty_print
  p tree.balanced?
  tree.rebalance
  tree.pretty_print
  p tree.balanced?
  p tree.preorder
  p tree.inorder
  p tree.postorder
end

driver
