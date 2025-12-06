defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits_count = number |> Integer.digits() |> Enum.count()

    number
    |> Integer.digits()
    |> Enum.reduce(0, fn n, acc -> acc + n ** digits_count end)
    |> Kernel.==(number)
  end
end
