defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  def random_planet_class(), do: @planetary_classes |> Enum.random()

  def random_ship_registry_number(), do: "NCC-#{1000..9999 |> Enum.random()}"

  def random_stardate(), do: :rand.uniform() * (42000 - 41000) + 41000

  def format_stardate(stardate), do: "~.1f" |> :io_lib.format([stardate]) |> to_string()
end
