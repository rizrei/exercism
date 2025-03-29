defmodule PrimeFactors do
  @moduledoc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number), do: do_factors_for(number, 2, []) |> Enum.sort()

  # def do_factors_for(2, _, _), do: [2]
  @spec do_factors_for(pos_integer, pos_integer, [pos_integer]) :: [pos_integer]
  defp do_factors_for(n, d, l) when d > n, do: l
  defp do_factors_for(n, d, l) when rem(n, d) == 0, do: do_factors_for(div(n, d), d, [d | l])
  defp do_factors_for(n, d, l), do: do_factors_for(n, d + 1, l)
end
