# credo:disable-for-this-file

defmodule BoutiqueInventory do
  @type item() :: %{
          name: String.t(),
          price: integer(),
          quantity_by_size: %{String.t() => integer()}
        }

  @spec sort_by_price([item()]) :: [item()]
  def sort_by_price(inventory), do: Enum.sort_by(inventory, & &1.price)

  @spec with_missing_price([item()]) :: [item()]
  def with_missing_price(inventory), do: Enum.filter(inventory, &(&1.price == nil))

  @spec update_names([item()], String.t(), String.t()) :: [item()]
  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, &%{&1 | name: String.replace(&1.name, old_word, new_word)})
  end

  @spec increase_quantity(item(), integer()) :: item()
  def increase_quantity(%{quantity_by_size: quantity_by_size} = data, count) do
    new_quantity_by_size = Enum.into(quantity_by_size, %{}, fn {k, v} -> {k, v + count} end)
    %{data | quantity_by_size: new_quantity_by_size}
  end

  @spec total_quantity(%{:quantity_by_size => any, optional(any) => any}) :: integer
  def total_quantity(%{quantity_by_size: quantity_by_size}) do
    Enum.reduce(quantity_by_size, 0, fn {_k, v}, acc -> v + acc end)
  end
end
