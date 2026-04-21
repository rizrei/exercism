defmodule JigsawPuzzle do
  @doc """
  Fill in missing jigsaw puzzle details from partial data
  """
  import :math, only: [sqrt: 1, pow: 2]

  @type format() :: :landscape | :portrait | :square
  @type t() :: %__MODULE__{
          pieces: pos_integer() | nil,
          rows: pos_integer() | nil,
          columns: pos_integer() | nil,
          format: format() | nil,
          aspect_ratio: float() | nil,
          border: pos_integer() | nil,
          inside: pos_integer() | nil
        }

  defstruct [:pieces, :rows, :columns, :format, :aspect_ratio, :border, :inside]

  @spec data(jigsaw_puzzle :: t()) :: {:ok, t()} | {:error, String.t()}
  def data(jigsaw_puzzle) do
    jigsaw_puzzle
    |> Map.from_struct()
    |> Map.reject(fn {_k, v} -> is_nil(v) end)
    |> build_pieces()
    |> build_rows()
    |> build_columns()
    |> build_aspect_ratio()
    |> build_format()
    |> build_border()
    |> build_inside()
    |> validate()
    |> then(fn
      {:error, _} = error -> error
      params -> {:ok, struct(__MODULE__, params)}
    end)
  end

  defp build_pieces(%{pieces: _} = jp), do: jp

  defp build_pieces(%{columns: c, rows: r} = jp), do: Map.put(jp, :pieces, c * r)
  defp build_pieces(%{border: b, inside: i} = jp), do: Map.put(jp, :pieces, b + i)
  defp build_pieces(%{format: :square, rows: r} = jp), do: Map.put(jp, :pieces, r * r)
  defp build_pieces(%{format: :square, columns: c} = jp), do: Map.put(jp, :pieces, c * c)

  defp build_pieces(%{format: :square, inside: i} = jp) do
    Map.put(jp, :pieces, square_border(jp) + i)
  end

  defp build_pieces(%{format: :square, border: b} = jp) do
    Map.put(jp, :pieces, square_inside(jp) + b)
  end

  defp build_pieces(%{aspect_ratio: ar, rows: r} = jp),
    do: Map.put(jp, :pieces, round(r * ar) * r)

  defp build_pieces(%{aspect_ratio: ar, columns: c} = jp),
    do: Map.put(jp, :pieces, round(c / ar) * c)

  defp build_pieces(%{aspect_ratio: 1.0} = jp),
    do: jp |> Map.put(:format, :square) |> build_pieces()

  defp build_pieces(_), do: {:error, "Insufficient data"}

  defp build_rows({:error, _} = err), do: err
  defp build_rows(%{rows: _} = jp), do: jp
  defp build_rows(%{pieces: p, columns: c} = jp), do: Map.put(jp, :rows, div(p, c))

  defp build_rows(%{pieces: p, aspect_ratio: ar} = jp),
    do: Map.put(jp, :rows, round(sqrt(p / ar)))

  defp build_rows(%{pieces: p, format: :square} = jp), do: Map.put(jp, :rows, round(sqrt(p)))

  defp build_rows(%{pieces: pieces, format: :landscape, border: border} = jp) do
    [rows | _] =
      for row <- 1..pieces,
          column = pieces / row,
          2 * (column + row) - 4 == border,
          column >= row,
          do: row

    Map.put(jp, :rows, rows)
  end

  defp build_rows(%{pieces: pieces, format: :portrait, border: border} = jp) do
    [rows | _] =
      for row <- 1..pieces,
          column = div(pieces, row),
          2 * (column + row) - 4 == border,
          row >= column,
          do: row

    Map.put(jp, :rows, rows)
  end

  defp build_rows(%{pieces: pieces, format: :landscape, inside: inside} = jp) do
    [rows | _] =
      for row <- 1..pieces,
          column = pieces / row,
          (column - 2) * (row - 2) == inside,
          column > row,
          do: row

    Map.put(jp, :rows, rows)
  end

  defp build_rows(%{pieces: pieces, format: :portrait, inside: inside} = jp) do
    [rows | _] =
      for row <- 1..pieces,
          column = pieces / row,
          (column - 2) * (row - 2) == inside,
          row > column,
          do: row

    Map.put(jp, :rows, rows)
  end

  defp build_rows(_), do: {:error, "Insufficient data"}

  # build_columns/1
  # pieces and rows must be known to calculate columns

  defp build_columns({:error, _} = err), do: err
  defp build_columns(%{columns: _} = jp), do: jp
  defp build_columns(%{pieces: p, rows: r} = jp), do: Map.put(jp, :columns, div(p, r))

  # border
  defp build_border({:error, _} = err), do: err
  defp build_border(%{border: _} = jp), do: jp
  defp build_border(%{pieces: p, inside: i} = jp), do: Map.put(jp, :border, p - i)
  defp build_border(%{columns: c, rows: r} = jp), do: Map.put(jp, :border, 2 * (c + r) - 4)

  # inside
  defp build_inside({:error, _} = err), do: err
  defp build_inside(%{inside: _} = jp), do: jp
  defp build_inside(%{pieces: p, border: b} = jp), do: Map.put(jp, :inside, p - b)

  # aspect_ratio
  defp build_aspect_ratio({:error, _} = err), do: err
  defp build_aspect_ratio(%{aspect_ratio: _} = jp), do: jp
  defp build_aspect_ratio(%{columns: c, rows: r} = jp), do: Map.put(jp, :aspect_ratio, c / r)

  # format
  defp build_format({:error, _} = err), do: err
  defp build_format(%{format: _} = jp), do: jp
  defp build_format(%{aspect_ratio: 1.0} = jp), do: Map.put(jp, :format, :square)
  defp build_format(%{aspect_ratio: ar} = jp) when ar > 1.0, do: Map.put(jp, :format, :landscape)
  defp build_format(%{aspect_ratio: ar} = jp) when ar < 1.0, do: Map.put(jp, :format, :portrait)

  defp validate({:error, _} = err), do: err

  defp validate(jp) do
    [
      &check_pieces/1,
      &check_aspect_ratio/1,
      &check_format/1,
      &check_border/1,
      &check_inside/1
    ]
    |> Enum.all?(&apply(&1, [jp]))
    |> case do
      true -> jp
      false -> {:error, "Contradictory data"}
    end
  end

  defp check_pieces(%{pieces: p, rows: r, columns: c}), do: p == r * c
  defp check_aspect_ratio(%{rows: r, columns: c, aspect_ratio: ar}), do: c / r == ar
  defp check_format(%{format: :square, rows: r, columns: c}), do: r == c
  defp check_format(%{format: :portrait, rows: r, columns: c}), do: r > c
  defp check_format(%{format: :landscape, rows: r, columns: c}), do: c > r
  defp check_border(%{border: b, rows: r, columns: c}), do: b == 2 * (r + c - 2)
  defp check_inside(%{inside: i, pieces: p, border: b}), do: i == p - b

  # helpers

  defp square_border(%{inside: 0}), do: 4
  defp square_border(%{inside: i}), do: round(4 * sqrt(i)) + 4
  defp square_inside(%{border: b}), do: (b / 4 - 1) |> pow(2) |> round()
end
