defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(0), do: ""
  def numeral(number) when number >= 1000, do: "M" <> numeral(number - 1000)
  def numeral(number) when number >= 900, do: "CM" <> numeral(number - 900)
  def numeral(number) when number >= 500, do: "D" <> numeral(number - 500)
  def numeral(number) when number >= 400, do: "CD" <> numeral(number - 400)
  def numeral(number) when number >= 100, do: "C" <> numeral(number - 100)
  def numeral(number) when number >= 90, do: "XC" <> numeral(number - 90)
  def numeral(number) when number >= 50, do: "L" <> numeral(number - 50)
  def numeral(number) when number >= 40, do: "XL" <> numeral(number - 40)
  def numeral(number) when number >= 10, do: "X" <> numeral(number - 10)
  def numeral(number) when number >= 9, do: "IX" <> numeral(number - 9)
  def numeral(number) when number >= 5, do: "V" <> numeral(number - 5)
  def numeral(number) when number >= 4, do: "IV" <> numeral(number - 4)
  def numeral(number) when number >= 1, do: "I" <> numeral(number - 1)
end
