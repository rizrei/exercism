defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """

  @spec generate(non_neg_integer(), non_neg_integer()) :: map()
  def generate(max_factor, min_factor \\ 1)

  def generate(max_factor, min_factor) when min_factor < max_factor do
    prods =
      for a <- min_factor..max_factor, b <- a..max_factor, palindrome?(a * b), reduce: %{} do
        acc -> Map.update(acc, a * b, [[a, b]], &[[a, b] | &1])
      end

    if prods == %{}, do: %{}, else: prods |> Enum.min_max() |> Tuple.to_list() |> Map.new()
  end

  def generate(factor, factor), do: %{}
  def generate(_, _), do: raise(ArgumentError)

  defp palindrome?(n) do
    s = Integer.to_string(n)
    s == String.reverse(s)
  end
end
