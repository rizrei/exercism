defmodule FlowerField do
  @doc """
  Annotate empty spots next to flowers with the number of flowers next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate(board) do
    flowers_map = flowers_map(board)

    for {line, row} <- Enum.with_index(board) do
      for {_char, col} <- line |> String.graphemes() |> Enum.with_index(), into: "" do
        flowers_map |> Map.get({row, col}) |> to_string()
      end
    end
  end

  defp flowers_map(board) do
    for {line, row} <- Enum.with_index(board),
        {char, col} <- line |> String.graphemes() |> Enum.with_index(),
        reduce: %{} do
      acc -> update_flowers_map(acc, {row, col}, char)
    end
  end

  defp update_flowers_map(acc, point, " "), do: Map.put_new(acc, point, " ")

  defp update_flowers_map(flowers_map, point, "*") do
    point
    |> adjacent_points()
    |> Enum.reduce(flowers_map, fn p, acc ->
      case Map.get(acc, p) do
        "*" -> acc
        " " -> Map.put(acc, p, 1)
        _ -> Map.update(acc, p, 1, &(&1 + 1))
      end
    end)
    |> Map.put(point, "*")
  end

  defp adjacent_points({x, y}) do
    for row <- [x - 1, x, x + 1],
        col <- [y - 1, y, y + 1],
        row >= 0 and col >= 0 and {row, col} != {x, y},
        into: [] do
      {row, col}
    end
  end
end
