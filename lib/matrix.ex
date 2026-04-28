defmodule Matrix do
  @moduledoc """
  Matrix
  """
  defstruct matrix: nil

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @type row() :: [integer()]
  @type column() :: [integer()]
  @type t() :: %__MODULE__{matrix: [row()]}

  @spec from_string(String.t()) :: t()
  def from_string(input) do
    %Matrix{matrix: input |> String.split("\n") |> Enum.map(&digits_to_list/1)}
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(Matrix.t()) :: String.t()
  def to_string(%Matrix{matrix: matrix}), do: Enum.map_join(matrix, "\n", &Enum.join(&1, " "))

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(Matrix.t()) :: [row()]
  def rows(%Matrix{matrix: matrix}), do: matrix

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(Matrix.t(), integer()) :: row()
  def row(%Matrix{matrix: matrix}, index), do: Enum.at(matrix, index - 1)

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: Matrix.t()) :: [row()]
  def columns(matrix), do: matrix |> rows() |> Enum.zip_with(& &1)

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(Matrix.t(), integer()) :: column()
  def column(matrix, index), do: matrix |> columns() |> Enum.at(index - 1)

  defp digits_to_list(str), do: str |> String.split() |> Enum.map(&String.to_integer/1)
end
