defmodule BookStore do
  @moduledoc """
  Calculates the price of a shopping basket with the biggest possible discount.
  """

  @book_price 800
  @discounts %{
    2 => 0.05,
    3 => 0.1,
    4 => 0.2,
    5 => 0.25
  }

  def total(basket) do
    basket
    |> generate_tree()
    |> tree_min()
    |> trunc()
  end

  def tree_min(tree) when is_number(tree), do: tree

  def tree_min(tree) do
    tree
    |> Enum.map(fn {_, v} -> tree_min(v) end)
    |> Enum.min()
  end

  def group_price_with_discount(group) do
    group_size = length(group)
    group_price = group_size * @book_price
    discount = Map.get(@discounts, group_size, 0)
    group_price - group_price * discount
  end

  @doc """
    ## Examples
    iex> BookStore.generate_tree([1, 2, 3])
    %{
      [1] => %{[2] => %{[3] => 2400}, [2, 3] => 2320.0, [3] => %{[2] => 2400}},
      [1, 2] => %{[3] => 2320.0},
      [1, 2, 3] => 2160.0,
      [1, 3] => %{[2] => 2320.0},
      [2] => %{[1] => %{[3] => 2400}, [1, 3] => 2320.0, [3] => %{[1] => 2400}},
      [2, 3] => %{[1] => 2320.0},
      [3] => %{[1] => %{[2] => 2400}, [1, 2] => 2320.0, [2] => %{[1] => 2400}}
    }
  """
  def generate_tree(list, cache \\ %{}, price \\ 0)
  def generate_tree([], _cache, price), do: price

  def generate_tree(list, cache, price) do
    list
    |> subsets()
    |> Enum.reduce(%{}, fn subset, acc ->
      frequencies = Enum.frequencies(list -- subset)
      new_price = price + group_price_with_discount(subset)

      new_cache = cache |> Map.put_new(frequencies, new_price)

      # IO.inspect(new_cache)

      acc
      |> Map.put(
        subset,
        generate_tree(list -- subset, new_cache, new_cache |> Map.get(frequencies))
      )
    end)
  end

  @doc """
    Split list to subsets

    ## Examples

      iex> BookStore.subsets([1, 2, 3, 4])
      [
        [1],
        [2],
        [3],
        [4],
        [1, 2],
        [1, 3],
        [1, 4],
        [2, 3],
        [2, 4],
        [3, 4],
        [1, 2, 3],
        [1, 2, 4],
        [1, 3, 4],
        [2, 3, 4],
        [1, 2, 3, 4]
      ]

  """
  def subsets(list) do
    items = Enum.uniq(list)
    for k <- 1..length(items), subsets <- subsets(items, k), do: subsets
  end

  defp subsets(_, 0), do: [[]]
  defp subsets([], _), do: []

  defp subsets([h | t], k) do
    with_h = for tail <- subsets(t, k - 1), do: [h | tail]
    without_h = subsets(t, k)
    with_h ++ without_h
  end
end
