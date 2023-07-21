defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn), do: do_isbn?(isbn, 10, 0)

  def do_isbn?(<<c, rest::binary>>, n, sum) when c in ?0..?9,
    do: do_isbn?(rest, n - 1, sum + n * (c - ?0))

  def do_isbn?(<<c, rest::binary>>, n, sum)when c == ?-, do: do_isbn?(rest, n, sum)
  def do_isbn?("X", _, sum), do: do_isbn?(<<>>, 0, sum + 10)
  def do_isbn?(<<>>, 0, sum), do: sum |> Integer.mod(11) == 0
  def do_isbn?(_, _, _), do: false
end
