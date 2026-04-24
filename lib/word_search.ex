defmodule WordSearch do
  defmodule Location do
    defstruct [:from, :to]

    @type point() :: %{row: non_neg_integer(), column: non_neg_integer()}
    @type point_tuple() :: {non_neg_integer(), non_neg_integer()}
    @type t() :: %Location{from: point(), to: point()}

    @spec new(point_tuple(), point_tuple()) :: t()
    def new({row1, column1}, {row2, column2}) do
      %__MODULE__{from: %{row: row1, column: column1}, to: %{row: row2, column: column2}}
    end
  end

  @type row() :: non_neg_integer()
  @type column() :: non_neg_integer()
  @type point() :: {row(), column()}
  @type grid() :: %{point() => String.t()}

  @doc """
  Find the start and end positions of words in a grid of letters.
  Row and column positions are 1 indexed.
  """
  @spec search(String.t(), [String.t()]) :: %{String.t() => nil | Location.t()}
  def search(input, words) do
    grid = parse_grid(input)
    into = Map.new(words, &{&1, nil})

    for {from, first_letter} <- grid,
        {to, last_letter} <- grid,
        word <- words,
        location?({from, first_letter}, {to, last_letter}, word, grid),
        into: into do
      {word, Location.new(from, to)}
    end
  end

  @spec parse_grid(String.t()) :: grid()
  defp parse_grid(input) do
    lines = String.split(input, "\n", trim: true)

    for {row, r} <- Enum.with_index(lines, 1),
        {char, c} <- row |> String.graphemes() |> Enum.with_index(1),
        into: %{},
        do: {{r, c}, char}
  end

  defp location?({{r1, c1}, first_letter}, {{r2, c2}, last_letter}, word, grid) do
    String.starts_with?(word, first_letter) and
      String.ends_with?(word, last_letter) and
      word?({r1, c1}, {r2, c2}, word, grid)
  end

  defp word?({r1, c1}, {r2, c2}, word, grid) do
    lr?({r1, c1}, {r2, c2}, word, grid) or
      rl?({r1, c1}, {r2, c2}, word, grid) or
      tb?({r1, c1}, {r2, c2}, word, grid) or
      bt?({r1, c1}, {r2, c2}, word, grid) or
      diag_tr_bl?({r1, c1}, {r2, c2}, word, grid) or
      diag_bl_tr?({r1, c1}, {r2, c2}, word, grid) or
      diag_rb_lt?({r1, c1}, {r2, c2}, word, grid) or
      diag_lt_rb?({r1, c1}, {r2, c2}, word, grid)
  end

  defp lr?({r, c1}, {r, c2}, word, grid) when c1 < c2,
    do: Range.new(c1, c2) |> Enum.map(&{r, &1}) |> word?(grid, word)

  defp lr?(_, _, _, _), do: false

  defp rl?({r, c1}, {r, c2}, word, grid) when c1 > c2,
    do: Range.new(c1, c2, -1) |> Enum.map(&{r, &1}) |> word?(grid, word)

  defp rl?(_, _, _, _), do: false

  defp tb?({r1, c}, {r2, c}, word, grid) when r1 < r2,
    do: Range.new(r1, r2) |> Enum.map(&{&1, c}) |> word?(grid, word)

  defp tb?(_, _, _, _), do: false

  defp bt?({r1, c}, {r2, c}, word, grid) when r1 > r2,
    do: Range.new(r1, r2, -1) |> Enum.map(&{&1, c}) |> word?(grid, word)

  defp bt?(_, _, _, _), do: false

  defp diag_lt_rb?({r1, c1}, {r2, c2}, word, grid)
       when r1 < r2 and c1 < c2 and r2 - r1 == c2 - c1,
       do: Enum.zip(r1..r2, c1..c2) |> word?(grid, word)

  defp diag_lt_rb?(_, _, _, _), do: false

  defp diag_rb_lt?({r1, c1}, {r2, c2}, word, grid)
       when r1 > r2 and c1 > c2 and r1 - r2 == c1 - c2,
       do: Enum.zip(r1..r2//-1, c1..c2//-1) |> word?(grid, word)

  defp diag_rb_lt?(_, _, _, _), do: false

  defp diag_bl_tr?({r1, c1}, {r2, c2}, word, grid)
       when r1 > r2 and c1 < c2 and r1 - r2 == c2 - c1,
       do: Enum.zip(r1..r2//-1, c1..c2) |> word?(grid, word)

  defp diag_bl_tr?(_, _, _, _), do: false

  defp diag_tr_bl?({r1, c1}, {r2, c2}, word, grid)
       when r1 < r2 and c1 > c2 and r2 - r1 == c1 - c2,
       do: Enum.zip(r1..r2, c1..c2//-1) |> word?(grid, word)

  defp diag_tr_bl?(_, _, _, _), do: false

  defp word?(points, grid, word) do
    points |> Enum.map_join("", &Map.get(grid, &1)) |> Kernel.==(word)
  end
end
