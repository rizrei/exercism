defmodule BinarySearchTree do
  @type bst_node :: %{data: integer | nil, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(integer | nil) :: bst_node
  def new(data), do: %{data: data, left: nil, right: nil}

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, integer | nil) :: bst_node
  def insert(tree, data) when data > tree.data and tree.right == nil,
    do: %{tree | right: %{data: data, left: nil, right: nil}}

  def insert(tree, data) when data <= tree.data and tree.left == nil,
    do: %{tree | left: %{data: data, left: nil, right: nil}}

  def insert(tree, data) when data > tree.data, do: %{tree | right: insert(tree.right, data)}
  def insert(tree, data) when data <= tree.data, do: %{tree | left: insert(tree.left, data)}

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [integer]
  def in_order(tree), do: tree |> fetch_data() |> List.flatten() |> Enum.sort()

  defp fetch_data(nil), do: []

  defp fetch_data(%{data: data, left: left, right: right}),
    do: [data, fetch_data(left), fetch_data(right)]
end
