defmodule CollatzConjecture do
  defguard is_pos_integer(term) when is_integer(term) and term > 0
  defguard is_even(term) when is_pos_integer(term) and rem(term, 2) == 0
  defguard is_odd(term) when is_pos_integer(term) and rem(term, 2) != 0

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """

  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when is_pos_integer(input), do: do_calc(input, 0)

  @spec do_calc(input :: pos_integer(), counter :: non_neg_integer()) :: non_neg_integer()
  defp do_calc(1, counter), do: counter
  defp do_calc(input, counter) when is_odd(input) do
    input |> Kernel.*(3) |> Kernel.+(1) |> do_calc(counter + 1)
  end

  defp do_calc(input, counter) when is_even(input) do
    input |> div(2) |> do_calc(counter + 1)
  end
end
