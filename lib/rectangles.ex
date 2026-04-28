defmodule Rectangles do
  @doc """
  Count the number of ASCII rectangles.
  """

  @type row() :: non_neg_integer()
  @type column() :: non_neg_integer()
  @type point() :: {row(), column()}
  @type grid() :: %{point() => String.t()}

  @spec count(String.t()) :: non_neg_integer()
  def count(""), do: 0

  def count(input) do
    grid = parse_grid(input)
    corners = for {pos, char} <- grid, char == "+", do: pos

    for p1 <- corners, p2 <- corners, valid_rectangle?(p1, p2, grid), reduce: 0 do
      acc -> acc + 1
    end
  end

  @spec parse_grid(String.t()) :: grid()
  defp parse_grid(input) do
    lines = String.split(input, "\n", trim: true)

    for {row, r} <- Enum.with_index(lines),
        {char, c} <- row |> String.graphemes() |> Enum.with_index(),
        into: %{},
        do: {{r, c}, char}
  end

  defp valid_rectangle?({r1, c1} = p1, {r2, c2} = p2, grid) do
    valid_corners?(p1, p2, grid) and
      h_edge?(r1, c1..c2, grid) and
      h_edge?(r2, c1..c2, grid) and
      v_edge?(c1, r1..r2, grid) and
      v_edge?(c2, r1..r2, grid)
  end

  defp valid_corners?({r1, c1}, {r2, c2}, grid) do
    r1 < r2 and c1 < c2 and corner?({r1, c2}, grid) and corner?({r2, c1}, grid)
  end

  defp h_edge?(r, cols, grid), do: Enum.all?(cols, &h_edge?({r, &1}, grid))
  defp h_edge?(point, grid), do: corner?(point, grid) or Map.get(grid, point) == "-"
  defp v_edge?(c, rows, grid), do: Enum.all?(rows, &v_edge?({&1, c}, grid))
  defp v_edge?(point, grid), do: corner?(point, grid) or Map.get(grid, point) == "|"

  defp corner?(point, grid), do: Map.get(grid, point) == "+"
end
