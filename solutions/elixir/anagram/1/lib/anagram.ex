defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    base
    |> do_match(candidates)
  end

  def do_match(base, candidates, result \\ [])
  def do_match(_, [], result), do: result |> Enum.reverse()

  def do_match(base, [h | t], result) do
    new_result = if anagram?(base, h), do: [h | result], else: result
    do_match(base, t, new_result)
  end

  def anagram?(base, candidate) when length(base) != length(candidate), do: false
  def anagram?(base, base), do: false

  def anagram?(base, candidate) do
    b = base |> String.downcase() |> String.graphemes()
    c = candidate |> String.downcase() |> String.graphemes()

    cond do
      b == c -> false
      Enum.sort(b) == Enum.sort(c) -> true
      true -> false
    end
  end
end
