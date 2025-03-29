defmodule PascalsTriangle do
  @moduledoc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num), do: Stream.iterate([1], &next_row/1) |> Enum.take(num)

  defp next_row([h | _] = row) do
    [h | row |> Enum.chunk_every(2, 1) |> Enum.map(&Enum.sum/1)]
  end
end
