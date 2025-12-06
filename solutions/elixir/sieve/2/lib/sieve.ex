defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(1), do: []
  def primes_to(limit), do: 2..limit |> Enum.to_list() |> sieve(limit)

  defp sieve(list, limit) do
    for x <- list, :math.sqrt(limit) > x, reduce: list do
      acc -> acc -- generator(x, limit)
    end
  end

  defp generator(nth, limit) do
    Stream.unfold(nth ** 2, fn
      n when n > limit -> nil
      n -> {n, n + nth}
    end)
    |> Enum.to_list()
  end
end
