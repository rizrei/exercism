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
  def isbn?(isbn) do
    formatted_isbn = isbn |> String.replace("-", "")
    case formatted_isbn|> String.match?(~r/^[0-9]{9}([0-9]{1}|X)$/) do
      true -> formatted_isbn |> mod11()|> Kernel.==(0)
      _ -> false
    end
  end

  defp mod11(formatted_isbn) do
    formatted_isbn
    |> String.reverse()
    |> String.codepoints()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn
      {"X", i}, acc -> 10 * i + acc
      {n, i}, acc -> String.to_integer(n) * i + acc
    end)
    |> Integer.mod(11)
  end
end
