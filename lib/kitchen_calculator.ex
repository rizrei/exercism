defmodule KitchenCalculator do
  @mililiters_in %{milliliter: 1, cup: 240, fluid_ounce: 30, teaspoon: 5, tablespoon: 15}

  @type unit :: :milliliter | :cup | :fluid_ounce | :teaspoon | :tablespoon
  @spec get_volume({unit(), number()}) :: number()
  def get_volume({_unit, volume}), do: volume

  @spec to_milliliter({unit(), number()}) :: {:milliliter, number()}
  def to_milliliter({unit, volume}) do
    {:milliliter, @mililiters_in[unit] * volume}
  end

  @spec from_milliliter({:milliliter, number()}, unit()) :: {unit(), float()}
  def from_milliliter({:milliliter, volume}, unit) do
    {unit, volume / @mililiters_in[unit]}
  end

  @spec convert({unit(), number()}, unit()) :: {unit(), float()}
  def convert(volume_pair, unit) do
    volume_pair |> to_milliliter() |> from_milliliter(unit)
  end
end
