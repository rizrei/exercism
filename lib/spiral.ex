defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []
  def matrix(dimension), do: unwind(dimension, dimension, 1)

  defp unwind(_row, 0, _start), do: [[]]

  defp unwind(row, col, start) do
    [Enum.to_list(start..(start + col - 1)) | unwind(col, row - 1, start + col) |> rotate_right()]
  end

  defp rotate_right(matrix), do: transpose(matrix) |> Enum.map(&Enum.reverse/1)
  defp transpose(matrix), do: List.zip(matrix) |> Enum.map(&Tuple.to_list/1)
end
