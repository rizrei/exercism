defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(number_string, size) do
    with true <- String.match?(number_string, ~r/^\d+$/),
         number_digits <- digits_list(number_string),
         true <- size > 0 and length(number_digits) >= size do
      number_digits
      |> Enum.chunk_every(size, 1, :discard)
      |> Enum.map(&Enum.product/1)
      |> Enum.max()
    else
      _ -> raise ArgumentError
    end
  end

  defp digits_list(number_string) do
    number_string
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
