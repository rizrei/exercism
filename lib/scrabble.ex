defmodule Scrabble do
  @score %{
    ~w(A E I O U L N R S T) => 1,
    ~w(D G) => 2,
    ~w(B C M P) => 3,
    ~w(F H V W Y) => 4,
    ~w(K) => 5,
    ~w(J X) => 8,
    ~w(Q Z) => 10
  }

  @moduledoc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer()
  def score(word) do
    score = for {letters, value} <- @score, char <- letters, into: %{}, do: {char, value}

    word
    |> String.trim()
    |> String.upcase()
    |> String.graphemes()
    |> Enum.sum_by(&score[&1])
  end
end
