defmodule VariableLengthQuantity do
  @moduledoc """
  VariableLengthQuantity
  """
  import Bitwise

  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers), do: integers |> Enum.reduce(<<>>, &do_encode/2)

  defp do_encode(0, acc), do: acc <> <<0>>
  defp do_encode(x, acc), do: acc <> encode_int(x, 0, <<>>)
  defp encode_int(0, _, acc), do: acc
  defp encode_int(x, b, acc), do: encode_int(x >>> 7, 1, <<b::1, x::7, acc::binary>>)

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes), do: do_decode(bytes, 0, [])
  defp do_decode(<<>>, 0, []), do: {:error, "incomplete sequence"}
  defp do_decode(<<>>, 0, acc), do: {:ok, Enum.reverse(acc)}
  defp do_decode(<<0::1, x::7, r::binary>>, i, acc), do: do_decode(r, 0, [(i <<< 7) + x | acc])
  defp do_decode(<<1::1, x::7, r::binary>>, i, acc), do: do_decode(r, (i <<< 7) + x, acc)
  defp do_decode(<<_::binary>>, _, _), do: {:error, "incomplete sequence"}
end
