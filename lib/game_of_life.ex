defmodule GameOfLife do
  @doc """
  Apply the rules of Conway's Game of Life to a grid of cells
  """

  @type matrix() :: [[0 | 1]]
  @type cell() :: {non_neg_integer(), non_neg_integer()}

  @spec tick(matrix()) :: matrix()
  def tick(matrix) do
    alive_cells = alive_cells(matrix)

    for {row, x} <- Enum.with_index(matrix) do
      for {value, y} <- Enum.with_index(row) do
        case {value, alive_neighbours_count({x, y}, alive_cells)} do
          {1, 3} -> 1
          {1, 2} -> 1
          {0, 3} -> 1
          _ -> 0
        end
      end
    end
  end

  defp alive_cells(matrix) do
    for {row, x} <- Enum.with_index(matrix),
        {1, y} <- Enum.with_index(row),
        into: MapSet.new() do
      {x, y}
    end
  end

  defp alive_neighbours_count({x, y}, alive_cells) do
    for dx <- -1..1, dy <- -1..1, not (dx == 0 and dy == 0), reduce: 0 do
      acc -> if MapSet.member?(alive_cells, {x + dx, y + dy}), do: acc + 1, else: acc
    end
  end
end
