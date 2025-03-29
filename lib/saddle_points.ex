defmodule SaddlePoints do
  @moduledoc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(""), do: []
  def rows(str), do: str |> String.split("\n") |> Enum.map(&digits_to_list/1)

  @moduledoc """
  Parses a string representation of a matrix
  to a list of columns
  """

  # columns = SaddlePoints.columns("1 2 3\n4 5 6\n7 8 9\n8 7 6")
  # assert Enum.at(columns, 0) == [1, 4, 7, 8]
  @spec columns(String.t()) :: [[integer]]
  def columns(str), do: str |> rows() |> Enum.zip_with(& &1)

  @moduledoc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    for {r, r_index} <- str |> rows() |> Enum.with_index(1),
        {c, c_index} <- str |> columns() |> Enum.with_index(1),
        Enum.max(r) == Enum.min(c),
        do: {r_index, c_index}
  end

  defp digits_to_list(str), do: str |> String.split() |> Enum.map(&String.to_integer/1)
end
