defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  def random_planet_class(), do: @planetary_classes |> Enum.random()

  def random_ship_registry_number(), do: "NCC-#{1000..9999 |> Enum.random()}"

  def random_stardate(), do: 41000..41000 |> Enum.random() |> Kernel.+(:rand.uniform())

  def format_stardate(stardate), do: stardate |> :erlang.float_to_binary(decimals: 1)
end
