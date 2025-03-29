defmodule Prime do
  @moduledoc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) do
    Stream.iterate(2, &(&1 + 1))
    |> Stream.filter(&prime?/1)
    |> Enum.take(count)
    |> Enum.reverse()
    |> hd()
  end

  defp prime?(2), do: true
  defp prime?(n) when n < 2 or rem(n, 2) == 0, do: false
  defp prime?(n), do: prime?(n, 3)

  defp prime?(n, x) when n < x * x, do: true
  defp prime?(n, x) when rem(n, x) == 0, do: false
  defp prime?(n, x), do: prime?(n, x + 2)
end
