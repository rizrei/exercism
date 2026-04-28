defmodule Raindrops do
  @moduledoc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """

  defguardp is_raindrop(n) when rem(n, 3) == 0 or rem(n, 5) == 0 or rem(n, 7) == 0

  @raindrops %{3 => "Pling", 5 => "Plang", 7 => "Plong"}

  @spec convert(pos_integer()) :: String.t()
  def convert(n) when is_raindrop(n),
    do: for({f, sound} <- @raindrops, rem(n, f) == 0, into: "", do: sound)

  def convert(n), do: Integer.to_string(n)
end
