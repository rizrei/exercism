defmodule BottleSong do
  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles
  """

  @units ~w(no one two three four five six seven eight nine ten)

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, take_down) do
    start_bottle..(start_bottle - take_down + 1)
    |> Enum.map_join("\n\n", &verse/1)
  end

  defp verse(start_bottle) do
    green_bottles = green_bottles(start_bottle) |> String.capitalize()

    """
    #{green_bottles} hanging on the wall,
    #{green_bottles} hanging on the wall,
    And if one green bottle should accidentally fall,
    There'll be #{green_bottles(start_bottle - 1)} hanging on the wall.\
    """
  end

  defp green_bottles(1), do: "one green bottle"
  defp green_bottles(n), do: "#{@units |> Enum.at(n)} green bottles"
end
