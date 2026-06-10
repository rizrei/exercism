defmodule Luhn do
  @moduledoc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean()
  def valid?(number) do
    case digitize(number) do
      {:ok, rev_digits_list} -> rev_digits_list |> luhn_sum() |> then(&(rem(&1, 10) == 0))
      _ -> false
    end
  end

  defp digitize(number, acc \\ [], length \\ 0)
  defp digitize("", _, length) when length <= 1, do: {:error, :invalid_input}
  defp digitize("", acc, _), do: {:ok, acc}
  defp digitize(" " <> rest, acc, length), do: digitize(rest, acc, length)

  defp digitize(<<c, rest::binary>>, acc, length) when c in ?0..?9,
    do: digitize(rest, [c - ?0 | acc], length + 1)

  defp digitize(_, _, _), do: {:error, :invalid_input}

  defp luhn_sum(list, acc \\ 0, double \\ false)
  defp luhn_sum([], acc, _), do: acc
  defp luhn_sum([h | t], acc, true) when h > 4, do: luhn_sum(t, acc + h * 2 - 9, false)
  defp luhn_sum([h | t], acc, true), do: luhn_sum(t, acc + h * 2, false)
  defp luhn_sum([h | t], acc, double), do: luhn_sum(t, acc + h, not double)
end
