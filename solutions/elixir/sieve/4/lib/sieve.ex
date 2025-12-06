defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(1), do: []
  def primes_to(limit), do: 2..limit |> Enum.to_list() |> primes_to(limit, [])

  defp primes_to([], _, acc), do: acc |> Enum.reverse()

  defp primes_to([h | t], limit, acc) do
    primes_to(t -- Enum.to_list(h..limit//h), limit, [h | acc])
  end
end
