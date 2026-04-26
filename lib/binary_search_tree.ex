defmodule BinarySearchTree do
  @moduledoc """
  BinarySearchTree
  """
  @type data() :: integer() | nil
  @type bst_node :: %{data: data(), left: bst_node() | nil, right: bst_node() | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(data()) :: bst_node()
  def new(data), do: %{data: data, left: nil, right: nil}

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node(), data()) :: bst_node()
  def insert(nil, data), do: new(data)
  def insert(root, data) when data <= root.data, do: %{root | left: insert(root.left, data)}
  def insert(root, data), do: %{root | right: insert(root.right, data)}

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node()) :: [integer()]
  def in_order(nil), do: []
  def in_order(tree), do: in_order(tree.left) ++ [tree.data] ++ in_order(tree.right)
end
