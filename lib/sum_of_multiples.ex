defmodule SumOfMultiples do
  @moduledoc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer(), [non_neg_integer()]) :: non_neg_integer()
  def to(limit, factors) do
    factors = Enum.filter(factors, &(&1 != 0))

    for x <- Range.new(1, limit - 1),
        Enum.any?(factors, &(rem(x, &1) == 0)),
        reduce: 0 do
      acc -> x + acc
    end
  end
end
