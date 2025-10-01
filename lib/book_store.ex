defmodule BookStore do
  @moduledoc """
  Calculates the price of a shopping basket with the biggest possible discount.
  """

  @typedoc "A book is represented by its number in the 5-book series"
  @type book :: 1 | 2 | 3 | 4 | 5
  @book_price 800
  @group %{
    1 => @book_price,
    2 => @book_price * 2 * 0.95,
    3 => @book_price * 3 * 0.90,
    4 => @book_price * 4 * 0.80,
    5 => @book_price * 5 * 0.75
  }

  def total([]), do: 0
  def total(basket), do: basket |> Enum.frequencies() |> min_price() |> round()

  defp min_price(freq) when map_size(freq) == 0, do: 0

  defp min_price(freq) do
    Map.keys(@group)
    |> Enum.filter(fn size -> map_size(freq) >= size end)
    |> Enum.map(fn size ->
      min_price = freq |> group_books(size) |> min_price()
      @group[size] + min_price
    end)
    |> Enum.min()
  end

  defp group_books(freq, size) do
    freq
    |> Enum.sort_by(fn {_book, count} -> -count end)
    |> Enum.map(fn {book, _count} -> book end)
    |> Enum.take(size)
    |> Enum.reduce(freq, fn book, acc ->
      acc
      |> Map.update!(book, &(&1 - 1))
      |> Enum.reject(fn {_book, count} -> count == 0 end)
      |> Enum.into(%{})
    end)
  end
end
