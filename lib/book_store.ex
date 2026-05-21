defmodule BookStore do
  @typedoc "A book is represented by its number in the 5-book series"
  @type book() :: 1 | 2 | 3 | 4 | 5
  @type basket() :: [book()]

  @book_price 800
  @discounts %{
    1 => 1,
    2 => 0.95,
    3 => 0.90,
    4 => 0.80,
    5 => 0.75
  }

  @doc """
  Calculate lowest price (in cents) for a shopping basket containing books.
  """
  @spec total(basket()) :: integer()
  def total(basket) do
    basket
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
    |> do_total
  end

  defp do_total([]), do: 0

  defp do_total(bunlde) do
    1..Enum.count(bunlde)
    |> Enum.map(fn bundle_size ->
      bunlde
      |> remaning_bunldes(bundle_size)
      |> do_total()
      |> Kernel.+(bundle_price(bundle_size))
    end)
    |> Enum.min()
  end

  defp remaning_bunldes(bunlde, 0) do
    Enum.sort(bunlde, :desc)
  end

  defp remaning_bunldes(bunlde, bundle_size) do
    bunlde
    |> List.update_at(bundle_size - 1, &(&1 - 1))
    |> Enum.reject(&(&1 == 0))
    |> remaning_bunldes(bundle_size - 1)
  end

  defp bundle_price(bundle_size), do: @discounts[bundle_size] * bundle_size * @book_price
end
