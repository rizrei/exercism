defmodule Pov do
  @typedoc """
  A tree, which is made of a node with several branches
  """

  @type tree() :: {any(), [tree()]}

  @doc """
  Reparent a tree on a selected node.
  """
  @spec from_pov(tree(), any()) :: {:ok, tree()} | {:error, atom()}
  def from_pov(tree, node) do
    case find(tree, node, [tree]) do
      nil -> {:error, :nonexistent_target}
      path -> {:ok, reorient(path)}
    end
  end

  @doc """
  Finds a path between two nodes
  """
  @spec path_between(tree(), any(), any()) :: {:ok, [any()]} | {:error, atom()}
  def path_between(tree, from, to) do
    case from_pov(tree, from) do
      {:error, _} ->
        {:error, :nonexistent_source}

      {:ok, new_tree} ->
        case find(new_tree, to, [new_tree]) do
          nil -> {:error, :nonexistent_destination}
          path -> {:ok, Enum.map(path, fn {value, _} -> value end) |> Enum.reverse()}
        end
    end
  end

  defp find({target, _}, target, path), do: path

  defp find({_value, children}, target, path) do
    Enum.reduce_while(children, nil, fn child, acc ->
      case find(child, target, [child | path]) do
        nil -> {:cont, acc}
        found -> {:halt, found}
      end
    end)
  end

  defp reorient([root | rest]), do: reorient(rest, root)
  defp reorient([], tree), do: tree

  defp reorient([{node, children} | rest], {parent, parent_children}) do
    new_children = Enum.reject(children, fn {child, _} -> child == parent end)
    {parent, [reorient(rest, {node, new_children}) | parent_children]}
  end
end
