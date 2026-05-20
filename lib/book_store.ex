defmodule BookStore do
  @typedoc "A book is represented by its number in the 5-book series"
  @type book :: 1 | 2 | 3 | 4 | 5
  @book_price 800
  @discount_percentage %{
    1 => 1,
    2 => 0.95,
    3 => 0.90,
    4 => 0.80,
    5 => 0.75
  }

  @doc """
  Calculate lowest price (in cents) for a shopping basket containing books.
  """
  @spec total(basket :: [book]) :: integer
  def total(basket) do
    basket
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
    |> do_total
  end

  defp do_total([]), do: 0

  defp do_total(book_occurrencies) do
    different_books = book_occurrencies |> Enum.count()

    1..different_books
    |> Enum.map(fn bundle_size ->
      book_occurrencies
      |> remaning_book_occurrencies(bundle_size)
      |> do_total()
      |> Kernel.+(bundle_price(bundle_size))
    end)
    |> Enum.min()
  end

  defp remaning_book_occurrencies(book_occurrencies, 0),
    do:
      book_occurrencies
      |> Enum.sort(:desc)

  defp remaning_book_occurrencies(book_occurrencies, bundle_size),
    do:
      book_occurrencies
      |> List.update_at(bundle_size - 1, &(&1 - 1))
      |> Enum.reject(&(&1 == 0))
      |> remaning_book_occurrencies(bundle_size - 1)

  defp bundle_price(bundle_size),
    do: @discount_percentage[bundle_size] * bundle_size * @book_price
end
