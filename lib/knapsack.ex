defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """
  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer
  def maximum_value([], _), do: 0
  def maximum_value(_, 0), do: 0

  def maximum_value([%{weight: w} | tail], maximum_weight) when w > maximum_weight do
    maximum_value(tail, maximum_weight)
  end

  def maximum_value([%{value: v, weight: w} | tail], maximum_weight) do
    max(
      maximum_value(tail, maximum_weight),
      v + maximum_value(tail, maximum_weight - w)
    )
  end
end
