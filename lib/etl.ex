defmodule ETL do
  @moduledoc """
  Transforms an old Scrabble score system to a new one.

  ## Examples

    iex> ETL.transform(%{1 => ["A", "E"], 2 => ["D", "G"]})
    %{"a" => 1, "d" => 2, "e" => 1, "g" => 2}
  """
  @type old_score() :: %{non_neg_integer() => list(String.t())}
  @type new_score() :: %{String.t() => non_neg_integer()}

  @spec transform(old_score()) :: new_score()
  def transform(input) do
    for {key, values} <- input, value <- values, into: %{}, do: {String.downcase(value), key}
  end
end
