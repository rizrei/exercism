defmodule BookStore do
  @moduledoc """
  Calculates the price of a shopping basket with the biggest possible discount.
  """

  @typedoc "A book is represented by its number in the 5-book series"
  @type book :: 1 | 2 | 3 | 4 | 5
  @book_price 800
  @discounts %{1 => 1.0, 2 => 0.95, 3 => 0.90, 4 => 0.80, 5 => 0.75}
  @group Map.new(@discounts, fn {size, discount} ->
           {size, @book_price * size * discount}
         end)

  def total([]), do: 0
  def total(basket), do: basket |> Enum.frequencies() |> min_price_cached(%{}) |> elem(0) |> round()

  defp min_price_cached(freq, cache) when map_size(freq) == 0, do: {0, cache}

  defp min_price_cached(freq, cache) do
    key = freq |> Enum.sort() |> Enum.into([])

    case Map.get(cache, key) do
      nil ->
        {result, updated_cache} =
          Map.keys(@group)
          |> Enum.filter(fn size -> map_size(freq) >= size end)
          |> Enum.reduce({nil, cache}, fn size, {current_min, curr_cache} ->
            {recursive_cost, next_cache} =
              freq |> group_books(size) |> min_price_cached(curr_cache)

            cost = @group[size] + recursive_cost

            new_min =
              case current_min do
                nil -> cost
                min -> min(min, cost)
              end

            {new_min, next_cache}
          end)

        {result, Map.put(updated_cache, key, result)}

      cached_result ->
        {cached_result, cache}
    end
  end

  # Remove a group of books with the highest frequencies from the frequency map
  defp group_books(freq, size) do
    books_to_remove =
      freq
      |> Enum.sort_by(fn {_book, count} -> -count end)
      |> Enum.take(size)
      |> Enum.map(&elem(&1, 0))

    Enum.reduce(books_to_remove, freq, fn book, acc ->
      Map.update!(acc, book, &(&1 - 1))
    end)
    |> Enum.reject(fn {_book, count} -> count == 0 end)
    |> Enum.into(%{})
  end
end
