defmodule AllYourBase do
  @moduledoc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @errors %{
    invalid_digits: "all digits must be >= 0 and < input base",
    invalid_input_base: "input base must be >= 2",
    invalid_output_base: "output base must be >= 2"
  }

  @min_base 2

  @spec convert([integer()], integer(), integer()) :: {:ok, [integer()]} | {:error, String.t()}
  def convert(_, input_base, _) when input_base < @min_base,
    do: {:error, @errors.invalid_input_base}

  def convert(_, _, output_base) when output_base < @min_base,
    do: {:error, @errors.invalid_output_base}

  def convert(digits, input_base, output_base) do
    if Enum.all?(digits, &(0 <= &1 and &1 < input_base)) do
      digits
      |> Enum.reduce(0, fn digit, acc -> acc * input_base + digit end)
      |> Integer.digits(output_base)
      |> then(&{:ok, &1})
    else
      {:error, "all digits must be >= 0 and < input base"}
    end
  end
end
