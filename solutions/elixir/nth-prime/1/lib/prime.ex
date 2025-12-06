defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) do
    Stream.iterate(2, &(&1 + 1))
    |> Stream.filter(&is_prime/1)
    |> Enum.take(count)
    |> Enum.reverse()
    |> hd()
  end

  defp is_prime(2), do: true
  defp is_prime(n) when n < 2 or rem(n, 2) == 0, do: false
  defp is_prime(n), do: is_prime(n, 3)

  defp is_prime(n, x) when n < x * x, do: true
  defp is_prime(n, x) when rem(n, x) == 0, do: false
  defp is_prime(n, x), do: is_prime(n, x + 2)
end
