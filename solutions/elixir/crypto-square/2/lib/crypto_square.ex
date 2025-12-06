defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(str) do
    str
    |> String.replace(~r/[^0-9a-zA-Z]/, "")
    |> String.downcase()
    |> String.codepoints()
    |> rectangle_chunk()
  end

  defp rectangle_chunk([]), do: ""

  defp rectangle_chunk(codepoints) do
    chunk = codepoints |> length() |> :math.sqrt() |> ceil()

    codepoints
    |> Stream.chunk_every(chunk, chunk, Stream.cycle([" "]))
    |> Stream.zip_with(&Enum.join/1)
    |> Enum.join(" ")
  end
end
