defmodule Dot do
  alias Dot.Graph

  defmacro graph(do: block) do
    block
    |> build(Graph.new())
    |> Macro.escape()
  end

  defp build({:__block__, _, attrs}, graph), do: Enum.reduce(attrs, graph, &build/2)

  defp build({:graph, _, [attrs]}, graph) when is_list(attrs), do: Graph.put_attrs(graph, attrs)

  defp build({id, _, nil}, graph), do: Graph.add_node(graph, id)
  defp build({id, _, [attrs]}, graph) when is_list(attrs), do: Graph.add_node(graph, id, attrs)

  defp build({:--, _, [{id1, _, nil}, {id2, _, nil}]}, graph), do: Graph.add_edge(graph, id1, id2)

  defp build({:--, _, [{id1, _, nil}, {id2, _, [attrs]}]}, graph) when is_list(attrs),
    do: Graph.add_edge(graph, id1, id2, attrs)

  defp build(_, _), do: raise(ArgumentError)
end
