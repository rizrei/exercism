defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer()) :: boolean()
  def valid?(number) do
    digits = Integer.digits(number)
    digits_count = Enum.count(digits)

    digits
    |> Enum.reduce(0, fn n, acc -> acc + n ** digits_count end)
    |> then(&(&1 == number))
  end
end
