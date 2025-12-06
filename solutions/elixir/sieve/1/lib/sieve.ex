defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(1), do: []
  def primes_to(limit), do: 2..limit |> sieve(2, [])

  defp sieve([], _, res), do: res |> Enum.filter(& &1) |> Enum.reverse()

  defp sieve(list, nth, res) do
    [h | tail] =
      list
      |> Enum.with_index(fn
        element, _ when element == nth ->
          element

        _, index when rem(index, nth) == 0 ->
          nil

        element, _ ->
          element
      end)

    sieve(tail, nth + 1, [h | res])
  end
end
