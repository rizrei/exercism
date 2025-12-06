defmodule BottleSong do
  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles
  """

  @units ~w(no one two three four five six seven eight nine ten)

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, take_down) do
    do_recite(start_bottle, take_down, [])
    |> Enum.reverse()
    |> Enum.join("\n\n")
  end

  defp do_recite(_, 0, acc), do: acc

  defp do_recite(start_bottle, take_down, acc) do
    do_recite(start_bottle - 1, take_down - 1, [verse(start_bottle) | acc])
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
