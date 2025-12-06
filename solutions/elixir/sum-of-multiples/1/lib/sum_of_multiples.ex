defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    factors |> Enum.map(&energy_points(&1, limit)) |> List.flatten() |> Enum.uniq() |> Enum.sum()
  end

  defp energy_points(0, _), do: [0]
  defp energy_points(start, limit), do: start..(limit - 1)//start |> Enum.to_list()
end
