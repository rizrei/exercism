# credo:disable-for-this-file

defmodule DNA do
  @nucleic_acids %{
    ?\s => 0,
    ?A => 1,
    ?C => 2,
    ?G => 4,
    ?T => 8
  }

  @codes Map.new(@nucleic_acids, fn {k, v} -> {v, k} end)

  def encode_nucleotide(nucleotide), do: Map.get(@nucleic_acids, nucleotide)

  def decode_nucleotide(code), do: Map.get(@codes, code)

  def encode(dna), do: do_encode(dna, <<>>)

  defp do_encode([], acc), do: acc

  defp do_encode([head | tail], acc) do
    do_encode(tail, <<acc::bitstring, encode_nucleotide(head)::4>>)
  end

  def decode(dna), do: do_decode(dna, [])

  defp do_decode(<<>>, acc), do: Enum.reverse(acc)

  defp do_decode(<<value::4, rest::bitstring>>, acc) do
    do_decode(rest, [decode_nucleotide(value) | acc])
  end
end
