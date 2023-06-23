defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """
  @error_message "all digits must be >= 0 and < input base"
  @input_base_error "input base must be >= 2"
  @output_base_error "output base must be >= 2"

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(_, _, output_base) when output_base < 2, do: {:error, @output_base_error}
  def convert(_, input_base, _) when input_base < 2, do: {:error, @input_base_error}

  def convert(digits, input_base, output_base) do
    if Enum.all?(digits, fn num -> num >= 0 and num < input_base end) do
      {:ok, digits |> to_decimal(input_base) |> from_decimal(output_base)}
    else
      {:error, @error_message}
    end
  end

  defp to_decimal(_num, base, _result \\ 0)
  defp to_decimal([], _, result), do: result

  defp to_decimal([num | rest] = digits, base, result) do
    to_decimal(rest, base, result + num * base ** (length(digits) - 1))
  end

  defp from_decimal(_number, _base, _result \\ [])
  defp from_decimal(number, base, result) when number < base, do: [number | result]

  defp from_decimal(number, base, result),
    do: from_decimal(div(number, base), base, [rem(number, base) | result])
end

# defmodule AllYourBase do
#   @doc """
#   Given a number in input base, represented as a sequence of digits, converts it to output base,
#   or returns an error tuple if either of the bases are less than 2
#   """
#   @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
#   def convert(digits, input_base, output_base) do
#     with :ok <- validate_input(digits, input_base, output_base) do
#       {:ok,
#        digits
#        |> Integer.undigits(input_base)
#        |> Integer.digits(output_base)}
#     end
#   end
#   defp validate_input(digits, input, output) do
#     cond do
#       output < 2 -> {:error, "output base must be >= 2"}
#       input < 2 -> {:error, "input base must be >= 2"}
#       invalid_digit?(digits, input) -> {:error, "all digits must be >= 0 and < input base"}
#       true -> :ok
#     end
#   end
#   defp invalid_digit?(digits, input_base) do
#     not Enum.all?(digits, fn d -> d >= 0 and d < input_base end)
#   end
# end
