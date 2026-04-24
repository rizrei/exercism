defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer()) :: String.t()
  def encode(str, 1), do: str

  def encode(str, rails) do
    rails
    |> rail_stream()
    |> Stream.zip(String.graphemes(str))
    |> Enum.sort_by(fn {rail, _} -> rail end)
    |> Enum.map_join("", fn {_, letter} -> letter end)
  end

  defp rail_stream(rails) do
    Range.new(1, rails - 1)
    |> Enum.concat(Range.new(rails, 2, -1))
    |> Stream.cycle()
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer()) :: String.t()
  def decode("", _), do: ""
  def decode(str, 1), do: str

  def decode(str, rails) do
    rails
    |> rail_stream()
    |> Stream.zip(Range.new(1, String.length(str)))
    |> Enum.sort()
    |> Enum.zip(String.graphemes(str))
    |> Enum.sort_by(fn {{_, index}, _} -> index end)
    |> Enum.map_join("", fn {{_, _}, letter} -> letter end)
  end
end
