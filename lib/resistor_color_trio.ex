defmodule ResistorColorTrio do
  @resistors %{
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
  }

  @doc """
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label([color1, color2, color3 | _]) do
    value =
      [@resistors[color1], @resistors[color2] | List.duplicate(0, @resistors[color3])]
      |> Integer.undigits()

    zero_count = value |> Integer.digits() |> Enum.count(&(&1 == 0))

    cond do
      zero_count >= 9 -> {value |> div(10 ** 9), :gigaohms}
      zero_count >= 6 -> {value |> div(10 ** 6), :megaohms}
      zero_count >= 3 -> {value |> div(10 ** 3), :kiloohms}
      true -> {value, :ohms}
    end
  end
end
