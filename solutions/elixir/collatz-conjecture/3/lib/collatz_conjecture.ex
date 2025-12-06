defmodule CollatzConjecture do
  import Integer, only: [is_even: 1, is_odd: 1]

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """

  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when is_integer(input) and input > 0, do: do_calc(input, 0)

  @spec do_calc(input :: pos_integer(), counter :: non_neg_integer()) :: non_neg_integer()
  defp do_calc(1, counter), do: counter

  defp do_calc(input, counter) when is_odd(input) do
    input |> Kernel.*(3) |> Kernel.+(1) |> do_calc(counter + 1)
  end

  defp do_calc(input, counter) when is_even(input) do
    input |> div(2) |> do_calc(counter + 1)
  end
end
