defmodule SquareRoot do
  @moduledoc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand), do: babylonian(radicand, radicand)
  defp babylonian(x, accum)
  defp babylonian(x, accum) when round(accum * accum) == x, do: round(accum)
  defp babylonian(x, accum), do: babylonian(x, (accum + x / accum) / 2)
end
