defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(n), do: do_numeral(n, "")

  defp do_numeral(n, res) when n >= 1000, do: do_numeral(n - 1000, res <> "M")
  defp do_numeral(n, res) when n >= 900, do: do_numeral(n - 900, res <> "CM")
  defp do_numeral(n, res) when n >= 500, do: do_numeral(n - 500, res <> "D")
  defp do_numeral(n, res) when n >= 400, do: do_numeral(n - 400, res <> "CD")
  defp do_numeral(n, res) when n >= 100, do: do_numeral(n - 100, res <> "C")
  defp do_numeral(n, res) when n >= 90, do: do_numeral(n - 90, res <> "XC")
  defp do_numeral(n, res) when n >= 50, do: do_numeral(n - 50, res <> "L")
  defp do_numeral(n, res) when n >= 40, do: do_numeral(n - 40, res <> "XL")
  defp do_numeral(n, res) when n >= 10, do: do_numeral(n - 10, res <> "X")
  defp do_numeral(n, res) when n >= 9, do: do_numeral(n - 9, res <> "IX")
  defp do_numeral(n, res) when n >= 5, do: do_numeral(n - 5, res <> "V")
  defp do_numeral(n, res) when n >= 4, do: do_numeral(n - 4, res <> "IV")
  defp do_numeral(n, res) when n >= 1, do: do_numeral(n - 1, res <> "I")
  defp do_numeral(_, res), do: res
end
