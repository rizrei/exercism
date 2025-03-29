defmodule RotationalCipher do
  @moduledoc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(<<>>, _), do: <<>>

  def rotate(<<head, rest::binary>>, shift) when head in ?A..?Z do
    <<rem(head - ?A + shift, 26) + ?A>> <> rotate(rest, shift)
  end

  def rotate(<<head, rest::binary>>, shift) when head in ?a..?z do
    <<rem(head - ?a + shift, 26) + ?a>> <> rotate(rest, shift)
  end

  def rotate(<<head, rest::binary>>, shift), do: <<head>> <> rotate(rest, shift)
end
