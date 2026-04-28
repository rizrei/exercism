defmodule Hamming do
  @moduledoc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance(strand1 :: [char()], strand2 :: [char()]) ::
          {:ok, non_neg_integer()} | {:error, String.t()}
  def hamming_distance(s1, s2) when length(s1) == length(s2) do
    {:ok, Enum.zip_reduce(s1, s2, 0, &(&3 + ((&1 != &2 && 1) || 0)))}
  end

  def hamming_distance(_, _), do: {:error, "strands must be of equal length"}
end
