defmodule Hamming do
  @invalid_length_error "strands must be of equal length"

  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) when length(strand1) != length(strand2) do
    {:error, @invalid_length_error}
  end

  def hamming_distance(strand1, strand2) do
    reducer = fn
      s1, s2, acc when s1 != s2 -> acc + 1
      _s1, _s2, acc -> acc
    end

    {:ok, Enum.zip_reduce(strand1, strand2, 0, reducer)}
  end
end
