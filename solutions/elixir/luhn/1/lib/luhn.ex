defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    with true <- number |> String.trim() |> valid_number?() do
      number
      |> digits()
      |> luhn_sum()
      |> Kernel.rem(10)
      |> Kernel.==(0)
    end
  end

  defp valid_number?("0"), do: false
  defp valid_number?(number), do: number =~ ~r/^(\d|\s)+$/

  defp digits(number), do: ~r/\d/ |> Regex.scan(number) |> List.flatten()

  defp luhn_sum(list) do
    list
    |> Enum.reverse()
    |> Stream.map(&String.to_integer/1)
    |> Enum.with_index(&transformator/2)
    |> Enum.sum()
  end

  def transformator(num, index) when rem(index, 2) != 0 and num * 2 > 9, do: num * 2 - 9
  def transformator(num, index) when rem(index, 2) != 0, do: num * 2
  def transformator(num, _), do: num
end
