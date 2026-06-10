defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """

  @spec generate(non_neg_integer(), non_neg_integer()) :: map()
  def generate(max_factor, min_factor \\ 1)
  def generate(max, min) when min > max, do: raise(ArgumentError)

  def generate(max_factor, min_factor) do
    for x <- min_factor..max_factor,
        y <- x..max_factor,
        palindrome?(x * y),
        reduce: %{} do
      acc -> Map.update(acc, x * y, [[x, y]], &[[x, y] | &1])
    end
  end

  defp palindrome?(number), do: number |> Integer.to_string() |> then(&(&1 == String.reverse(&1)))
end
