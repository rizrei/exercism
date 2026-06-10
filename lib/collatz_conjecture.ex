defmodule CollatzConjecture do
  import Integer, only: [is_even: 1, is_odd: 1]

  @moduledoc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """

  @spec calc(pos_integer()) :: non_neg_integer()
  def calc(input) when input > 0, do: do_calc(input, 0)

  defp do_calc(1, counter), do: counter
  defp do_calc(input, counter) when is_odd(input), do: do_calc(input * 3 + 1, counter + 1)
  defp do_calc(input, counter) when is_even(input), do: do_calc(div(input, 2), counter + 1)
end
