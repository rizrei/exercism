# credo:disable-for-this-file

defmodule BoutiqueInventory do
  @spec sort_by_price(list) :: list
  def sort_by_price(inventory), do: inventory |> Enum.sort_by(& &1.price)

  @spec with_missing_price(list) :: list
  def with_missing_price(inventory), do: inventory |> Enum.filter(&(&1.price == nil))

  @spec update_names(list, String.t(), String.t()) :: list
  def update_names(inventory, old_word, new_word) do
    inventory |> Enum.map(&%{&1 | name: String.replace(&1.name, old_word, new_word)})
  end

  @spec increase_quantity(%{:quantity_by_size => any, optional(any) => any}, any) :: %{
          :quantity_by_size => any,
          optional(any) => any
        }
  def increase_quantity(%{quantity_by_size: quantity_by_size} = data, count) do
    new_quantity_by_size = quantity_by_size |> Enum.into(%{}, fn {k, v} -> {k, v + count} end)
    %{data | quantity_by_size: new_quantity_by_size}
  end

  @spec total_quantity(%{:quantity_by_size => any, optional(any) => any}) :: integer
  def total_quantity(%{quantity_by_size: quantity_by_size}) do
    quantity_by_size |> Enum.reduce(0, fn {_k, v}, acc -> v + acc end)
  end
end
