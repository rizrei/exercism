defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num), do: do_rows([[1]], num)

  defp do_rows(list, num) when length(list) == num, do: list |> Enum.reverse()

  defp do_rows([h | _] = list, num) do
    [[1 | h |> Enum.chunk_every(2, 1) |> Enum.map(&Enum.sum/1)] | list]
    |> do_rows(num)
  end
end