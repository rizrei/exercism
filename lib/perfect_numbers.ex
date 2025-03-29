defmodule PerfectNumbers do
  @natural_numbers_error "Classification is only possible for natural numbers."

  @moduledoc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number <= 0, do: {:error, @natural_numbers_error}
  def classify(number), do: do_classify(number, number |> aliquot_sum)

  defp do_classify(number, aliquot_sum) when number > aliquot_sum, do: {:ok, :deficient}
  defp do_classify(number, aliquot_sum) when number < aliquot_sum, do: {:ok, :abundant}
  defp do_classify(_, _), do: {:ok, :perfect}

  defp aliquot_sum(number) do
    for n <- 1..number, rem(number, n) == 0 and number != n, reduce: 0 do
      acc -> acc + n
    end
  end
end
