defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    last = letter - ?A
    center_row = row(last, last)

    (last - 1)
    |> Range.new(0, -1)
    |> Enum.reduce([center_row], fn i, acc ->
      row = row(i, last)
      [row | acc] ++ [row]
    end)
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defp row(0, last) do
    outer = String.duplicate(" ", last)
    outer <> <<?A>> <> outer
  end

  defp row(i, last) do
    letter = <<?A + i>>
    outer = String.duplicate(" ", last - i)
    inner = String.duplicate(" ", i * 2 - 1)
    outer <> letter <> inner <> letter <> outer
  end
end
