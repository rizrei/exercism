defmodule TwelveDays do
  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """

  @days %{
    1 => "first",
    2 => "second",
    3 => "third",
    4 => "fourth",
    5 => "fifth",
    6 => "sixth",
    7 => "seventh",
    8 => "eighth",
    9 => "ninth",
    10 => "tenth",
    11 => "eleventh",
    12 => "twelfth"
  }

  @gifts [
    "a Partridge in a Pear Tree",
    "two Turtle Doves",
    "three French Hens",
    "four Calling Birds",
    "five Gold Rings",
    "six Geese-a-Laying",
    "seven Swans-a-Swimming",
    "eight Maids-a-Milking",
    "nine Ladies Dancing",
    "ten Lords-a-Leaping",
    "eleven Pipers Piping",
    "twelve Drummers Drumming"
  ]

  @spec verse(integer()) :: String.t()
  def verse(number) do
    gifts = gifts_for_day(number)
    "On the #{@days[number]} day of Christmas my true love gave to me: #{gifts}."
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(integer(), integer()) :: String.t()
  def verses(starting_verse, ending_verse) do
    starting_verse
    |> Range.new(ending_verse)
    |> Enum.map_join("\n", &verse/1)
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing, do: verses(1, 12)

  defp gifts_for_day(1), do: hd(@gifts)

  defp gifts_for_day(day) do
    {gifts, [last_gift]} =
      @gifts
      |> Enum.take(day)
      |> Enum.reverse()
      |> Enum.split(-1)

    "#{Enum.join(gifts, ", ")}, and #{last_gift}"
  end
end
