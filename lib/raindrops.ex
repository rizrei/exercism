defmodule Raindrops do
  @moduledoc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """

  @raindrops %{3 => "Pling", 5 => "Plang", 7 => "Plong"}

  @spec convert(pos_integer()) :: String.t()
  def convert(n) do
    case raindrop_string(n) do
      "" -> Integer.to_string(n)
      sound -> sound
    end
  end

  defp raindrop_string(n) do
    for {number, sound} <- @raindrops, rem(n, number) == 0, into: "", do: sound
  end
end
