defmodule KitchenCalculator do
  @mililiters_in %{milliliter: 1, cup: 240, fluid_ounce: 30, teaspoon: 5, tablespoon: 15}

  def get_volume({_unit, volume}), do: volume

  def to_milliliter({unit, volume}) do
    {:milliliter, @mililiters_in[unit] * volume}
  end

  def from_milliliter({:milliliter, volume}, unit) do
    {unit, volume / @mililiters_in[unit]}
  end

  def convert(volume_pair, unit) do
    volume_pair |> to_milliliter() |> from_milliliter(unit)
  end
end