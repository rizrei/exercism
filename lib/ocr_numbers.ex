defmodule OcrNumbers do
  @digits %{
    {" _ ", "| |", "|_|", "   "} => "0",
    {"   ", "  |", "  |", "   "} => "1",
    {" _ ", " _|", "|_ ", "   "} => "2",
    {" _ ", " _|", " _|", "   "} => "3",
    {"   ", "|_|", "  |", "   "} => "4",
    {" _ ", "|_ ", " _|", "   "} => "5",
    {" _ ", "|_ ", "|_|", "   "} => "6",
    {" _ ", "  |", "  |", "   "} => "7",
    {" _ ", "|_|", "|_|", "   "} => "8",
    {" _ ", "|_|", " _|", "   "} => "9"
  }

  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) when rem(length(input), 4) != 0 do
    {:error, "invalid line count"}
  end

  def convert([first | _]) when first |> byte_size() |> rem(3) != 0 do
    {:error, "invalid column count"}
  end

  def convert(input) do
    input
    |> Enum.chunk_every(4)
    |> Enum.map_join(",", fn line ->
      line
      |> Enum.map(&chunk_line/1)
      |> Enum.zip()
      |> Enum.map_join(&to_digit/1)
    end)
    |> then(&{:ok, &1})
  end

  defp chunk_line(line), do: for(<<chunk::binary-size(3) <- line>>, do: chunk)

  defp to_digit(tuple), do: Map.get(@digits, tuple, "?")
end
