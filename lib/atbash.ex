defmodule Atbash do
  @moduledoc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """

  @cipher ?a..?z |> Enum.zip(?z..?a//-1) |> Map.new()
  @max_chunk 5
  @shift ?a - ?A

  @spec encode(String.t()) :: String.t()
  def encode(plaintext), do: do_encode(plaintext, 0, [])

  defp do_encode("", _, [?\s | acc]), do: acc |> Enum.reverse() |> List.to_string()
  defp do_encode("", _, acc), do: acc |> Enum.reverse() |> List.to_string()
  defp do_encode(plaintext, @max_chunk, acc), do: do_encode(plaintext, 0, [?\s | acc])

  defp do_encode(<<h, t::binary>>, chunk, acc) when h in ?A..?Z do
    do_encode(t, chunk + 1, [Map.get(@cipher, h + @shift) | acc])
  end

  defp do_encode(<<h, t::binary>>, chunk, acc) when h in ?a..?z do
    do_encode(t, chunk + 1, [Map.get(@cipher, h) | acc])
  end

  defp do_encode(<<h, t::binary>>, chunk, acc) when h in ?0..?9 do
    do_encode(t, chunk + 1, [h | acc])
  end

  defp do_encode(<<_h, t::binary>>, chunk, acc) do
    do_encode(t, chunk, acc)
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher), do: do_decode(cipher, [])

  defp do_decode("", acc), do: acc |> Enum.reverse() |> List.to_string()
  defp do_decode(<<h, t::binary>>, acc) when h in ?a..?z, do: do_decode(t, [@cipher[h] | acc])
  defp do_decode(<<h, t::binary>>, acc) when h in ?0..?9, do: do_decode(t, [h | acc])
  defp do_decode(<<_h, t::binary>>, acc), do: do_decode(t, acc)
end
