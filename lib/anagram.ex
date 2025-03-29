defmodule Anagram do
  @moduledoc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    base = String.downcase(base)
    for c <- candidates, anagram?(base, String.downcase(c)), do: c, into: []
  end

  defp anagram?(a, b), do: a != b and sorted(a) == sorted(b)
  defp sorted(string), do: string |> to_charlist() |> Enum.sort()
end
