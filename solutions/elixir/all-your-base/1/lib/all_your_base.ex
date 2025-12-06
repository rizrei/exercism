defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(_, _, output_base) when output_base < 2, do: {:error, "output base must be >= 2"}
  def convert(_, input_base, _) when input_base < 2, do: {:error, "input base must be >= 2"}
  def convert([], _, _), do: {:ok, [0]}

  def convert(list, input_base, output_base) do
    list
    |> Enum.reverse()
    |> convert_to_decimal_int(0, input_base, 0)
    |> convert_to_output_base(output_base, [])
  end

  defp convert_to_decimal_int([], _, _, result), do: result

  defp convert_to_decimal_int([h | _], _, input_base, _) when h not in 0..(input_base - 1) do
    {:error, "all digits must be >= 0 and < input base"}
  end

  defp convert_to_decimal_int([h | t], index, input_base, result) do
    convert_to_decimal_int(t, index + 1, input_base, h * input_base ** index + result)
  end

  defp convert_to_output_base({:error, _} = error, _, _), do: error
  defp convert_to_output_base(0, _, []), do: {:ok, [0]}
  defp convert_to_output_base(0, _, result), do: {:ok, result}

  defp convert_to_output_base(div, base, result) do
    convert_to_output_base(div(div, base), base, [rem(div, base) | result])
  end
end
