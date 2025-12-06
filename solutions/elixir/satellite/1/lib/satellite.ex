defmodule Satellite do
  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style
  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}
  def build_tree(preorder, inorder) do
    cond do
      preorder |> Enum.count() != inorder |> Enum.count() ->
        {:error, "traversals must have the same length"}

      preorder |> Enum.sort() != inorder |> Enum.sort() ->
        {:error, "traversals must have the same elements"}

      preorder |> Enum.uniq() != preorder or preorder |> Enum.uniq() != preorder ->
        {:error, "traversals must contain unique items"}

      true ->
        {:ok, do_build_tree(preorder, inorder)}
    end
  end

  defp do_build_tree([], []), do: {}
  defp do_build_tree([value], [value]), do: {{}, value, {}}

  defp do_build_tree([root | rest], inorder) do
    {left_inorder, [_ | right_inorder]} = inorder |> Enum.split_while(&(&1 != root))
    {left_preorder, right_preorder} = rest |> Enum.split(Enum.count(left_inorder))

    {do_build_tree(left_preorder, left_inorder), root,
     do_build_tree(right_preorder, right_inorder)}
  end
end
