defmodule RotationalCipher do
  @moduledoc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer()) :: String.t()
  def rotate(text, shift), do: do_rotate(text, shift, [])

  defp do_rotate("", _, acc), do: acc |> Enum.reverse() |> List.to_string()

  defp do_rotate(<<h::utf8, rest::binary>>, shift, acc) when h in ?A..?Z do
    do_rotate(rest, shift, [rem(h - ?A + shift, 26) + ?A | acc])
  end

  defp do_rotate(<<h::utf8, rest::binary>>, shift, acc) when h in ?a..?z do
    do_rotate(rest, shift, [rem(h - ?a + shift, 26) + ?a | acc])
  end

  defp do_rotate(<<h::utf8, rest::binary>>, shift, acc) do
    do_rotate(rest, shift, [h | acc])
  end
end
