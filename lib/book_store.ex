defmodule BookStore do
  @typedoc "A book is represented by its number in the 5-book series"
  @type book :: 1 | 2 | 3 | 4 | 5

  @book_price 800
  @discounts %{
    2 => 0.05,
    3 => 0.1,
    4 => 0.2,
    5 => 0.25
  }

  @doc """
  Calculate lowest price (in cents) for a shopping basket containing books.
  """
  @spec total(basket :: [book]) :: integer
  def total(basket) do
    basket
    |> Enum.frequencies()
    |> suggested_grouping()
    |> Enum.map(&group_price_with_discount/1)
    |> Enum.sum()
    |> trunc()
  end

  defp suggested_grouping(frequencies, acc \\ [])
  defp suggested_grouping(frequencies, acc) when frequencies == %{}, do: acc

  defp suggested_grouping(frequencies, acc) do
    new_acc = [Map.keys(frequencies) | acc]
    new_frequencies = for {k, v} when v - 1 > 0 <- frequencies, into: %{}, do: {k, v - 1}
    suggested_grouping(new_frequencies, new_acc)
  end

  def group_price_with_discount(group) do
    group_size = length(group)
    group_price = group_size * @book_price
    discount = Map.get(@discounts, group_size, 0)
    group_price - group_price * discount
  end
end
