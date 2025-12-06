defmodule ResistorColorDuo do
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
  Calculate a resistance value from two colors
  """
  @spec value(colors :: [atom]) :: integer
  def value([color1, color2 | _]) do
    [color1, color2]
    |> Enum.map(&@resistors[&1])
    |> Enum.join()
    |> String.to_integer()
  end
end
