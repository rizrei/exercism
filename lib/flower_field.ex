defmodule FlowerField do
  @doc """
  Annotate empty spots next to flowers with the number of flowers next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate(board) do
    flowers_cells = flowers_cells(board)

    for {line, x} <- Enum.with_index(board) do
      for {value, y} <- line |> String.graphemes() |> Enum.with_index(), into: "" do
        cond do
          value == "*" ->
            "*"

          value == " " ->
            count_adjacent_flowers({x, y}, flowers_cells)
            |> then(&if &1 == 0, do: " ", else: to_string(&1))
        end
      end
    end
  end

  defp flowers_cells(matrix) do
    for {row, x} <- Enum.with_index(matrix),
        {"*", y} <- row |> String.graphemes() |> Enum.with_index(),
        into: MapSet.new() do
      {x, y}
    end
  end

  defp count_adjacent_flowers({x, y}, flowers_cells) do
    for dx <- -1..1, dy <- -1..1, not (dx == 0 and dy == 0), reduce: 0 do
      acc -> if MapSet.member?(flowers_cells, {x + dx, y + dy}), do: acc + 1, else: acc
    end
  end
end
