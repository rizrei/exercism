defmodule SumOfMultiples1 do
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

test_fun = fn module, function_name, input ->
  Enum.each(1..1000, fn _ -> apply(module, function_name, input) end)
end

defmodule SumOfMultiples2 do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    for x <- 1..(limit - 1),
        Enum.any?(factors, &(&1 != 0 && rem(x, &1) == 0 )),
        reduce: 0
    do
      acc -> x + acc
    end
  end
end

Benchee.run(
  %{
    "SumOfMultiples" => fn input -> test_fun.(SumOfMultiples, :to, input) end,
    "SumOfMultiples1" => fn input -> test_fun.(SumOfMultiples1, :to, input) end,
    "SumOfMultiples2" => fn input -> test_fun.(SumOfMultiples2, :to, input) end,
  },
  memory_time: 2,
  inputs: %{
    # "Small" => ["055 444 285"],
    # "Medium" => ["1 2345 6789 1234 5678 9013"],
    "Bigger" => [10_000, [2, 3, 5, 7, 11]],
    # "Bigger" => [10_000, [0, 2, 3, 5, 7, 11]],
  }
)
