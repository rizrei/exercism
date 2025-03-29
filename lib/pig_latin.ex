defmodule PigLatin do
  @moduledoc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """

  @vowels ~w[a e i o u]

  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase |> String.split(" ") |> Enum.map_join(" ", &pigify/1)
  end

  def pigify(string) do
    string |> String.codepoints() |> do_pigify() |> Enum.join() |> Kernel.<>("ay")
  end

  defp do_pigify([c | _] = word) when c in @vowels, do: word
  defp do_pigify([c1, c2 | _] = word) when c1 in ~w[x y] and c2 not in @vowels, do: word
  defp do_pigify([c1, c2 | tail]) when c1 == "q" and c2 == "u", do: tail ++ [c1, c2]
  defp do_pigify([c | tail]), do: do_pigify(tail ++ [c])
end
