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
        product = x * y,
        palindrome?(product),
        reduce: %{} do
      acc -> Map.update(acc, product, [[x, y]], &[[x, y] | &1])
    end
  end

  defp palindrome?(n), do: palindrome?(n, 0, n)
  defp palindrome?(0, rev, original), do: rev == original
  defp palindrome?(n, rev, original), do: palindrome?(div(n, 10), rev * 10 + rem(n, 10), original)
end
