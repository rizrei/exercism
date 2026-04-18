defmodule Zipper do
  @doc """
  Get a zipper focused on the root node.
  """

  @enforce_keys [:node]
  defstruct [:node, path: []]

  @typedoc """
  Path is a list of maps, where each map has the following keys:
  - `parent`: the parent node of the current focus
  - `from`: whether the current focus is the left or right child of the parent (`:left` or `:right`)
  """
  @type path() :: [%{parent: BinTree.t(), from: :left | :right}]
  @type t() :: %__MODULE__{node: BinTree.t(), path: path()}

  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(%BinTree{} = node), do: %__MODULE__{node: node}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%{node: node, path: []}), do: node
  def to_tree(z), do: z |> up() |> to_tree()

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any()
  def value(%{node: nil}), do: nil
  def value(%{node: node}), do: node.value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%{node: %BinTree{left: nil}}), do: nil

  def left(%{node: %BinTree{left: left} = node, path: path} = z) do
    %{z | node: left, path: [%{parent: node, from: :left} | path]}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%{node: %BinTree{right: nil}}), do: nil

  def right(%{node: %BinTree{right: right} = node, path: path} = z) do
    %{z | node: right, path: [%{parent: node, from: :right} | path]}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%{path: []}), do: nil

  def up(%{node: node, path: [%{parent: parent, from: from} | rest]} = z) do
    %{z | node: Map.put(parent, from, node), path: rest}
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any()) :: Zipper.t()
  def set_value(%{node: node} = z, value), do: %{z | node: %{node | value: value}}

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(%{node: node} = z, left), do: %{z | node: %{node | left: left}}

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(%{node: node} = z, right), do: %{z | node: %{node | right: right}}
end
