defmodule WordCount do
  @moduledoc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase()
    |> String.replace(~w[: ! & @ $ % ^ & .], "")
    |> String.split([" ", ",\n", ",", "\n", "\t", "_"])
    |> Enum.map(&String.trim(&1, "'"))
    |> Enum.reject(&(&1 == ""))
    |> Enum.frequencies()
  end
end
