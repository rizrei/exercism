defmodule Transmission do
  import Bitwise

  @error_wrong_parity "wrong parity"

  @spec get_transmit_sequence(binary()) :: binary()
  def get_transmit_sequence(message) do
    encode(message, []) |> Enum.reverse() |> bits_concat()
  end

  defp encode(<<>>, acc), do: acc

  defp encode(<<chunk::7, rest::bitstring>>, acc) do
    p = parity(chunk)
    encode(rest, [<<chunk::7, p::1>> | acc])
  end

  defp encode(<<last::bitstring>>, acc) do
    <<chunk::7>> = <<last::bitstring, 0::size(7 - bit_size(last))>>
    p = parity(chunk)
    [<<chunk::7, p::1>> | acc]
  end

  @spec decode_message(binary()) :: {:ok, binary()} | {:error, String.t()}
  def decode_message(received_data) do
    with {:ok, bits} <- strip_parity(received_data, []) do
      {:ok, bits_to_bytes(bits)}
    end
  end

  defp strip_parity(<<chunk::7, p::1, rest::bitstring>>, acc) do
    if parity(chunk) == p do
      strip_parity(rest, [<<chunk::7>> | acc])
    else
      {:error, @error_wrong_parity}
    end
  end

  defp strip_parity(<<>>, acc), do: {:ok, acc |> Enum.reverse() |> bits_concat()}

  defp bits_to_bytes(bits), do: bits_to_bytes(bits, [])

  defp bits_to_bytes(<<byte::8, rest::bitstring>>, acc) do
    bits_to_bytes(rest, [<<byte>> | acc])
  end

  defp bits_to_bytes(_, acc), do: acc |> Enum.reverse() |> bits_concat()

  defp bits_concat([]), do: <<>>
  defp bits_concat([h | t]), do: Enum.reduce(t, h, &<<&2::bitstring, &1::bitstring>>)

  defp parity(n), do: parity(n, 0)
  defp parity(0, acc), do: acc
  defp parity(n, acc), do: parity(n >>> 1, bxor(acc, n &&& 1))
end
