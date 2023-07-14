defmodule MatchingBrackets do
  @openers ~w[( \[ {]

  def check_brackets(str) do
    str |> String.replace(~r/[^\(\)\[\]\{\}]/, "") |> String.codepoints() |> check([])
  end

  defp check([head | tail], acc) when head in @openers, do: check(tail, [head | acc])
  defp check(["]" | tail], ["[" | acc]), do: check(tail, acc)
  defp check(["}" | tail], ["{" | acc]), do: check(tail, acc)
  defp check([")" | tail], ["(" | acc]), do: check(tail, acc)
  defp check([], []), do: true
  defp check(_, _), do: false
end
