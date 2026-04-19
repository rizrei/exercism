defmodule RelativeDistance do
  @doc """
  Calculate the degree of separation between two individuals in a family tree.
  """

  @spec degree_of_separation(
          tree :: %{String.t() => [String.t()]},
          person_a :: String.t(),
          person_b :: String.t()
        ) :: nil | pos_integer()
  def degree_of_separation(tree, person_a, person_b) do
    tree
    |> Enum.reduce(:digraph.new(), &graph_builder/2)
    |> :digraph.get_short_path(person_a, person_b)
    |> case do
      false -> nil
      path -> length(path) - 1
    end
  end

  defp graph_builder({parent, children}, graph) do
    group = [parent | children]
    tap(graph, &for(a <- group, b <- group, uniq: true, do: create_connection(&1, a, b)))
  end

  defp create_connection(graph, person1, person2) do
    :digraph.add_vertex(graph, person1)
    :digraph.add_vertex(graph, person2)
    :digraph.add_edge(graph, person1, person2)
    :digraph.add_edge(graph, person2, person1)
  end
end
