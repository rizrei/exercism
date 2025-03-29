defmodule Pangram do
  @moduledoc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @alphabet ?a..?z |> Enum.map(&<<&1>>)

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    sentence_graphemes = sentence |> String.downcase() |> String.graphemes()

    @alphabet |> Kernel.--(sentence_graphemes) |> Enum.empty?()
  end
end
