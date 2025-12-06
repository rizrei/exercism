defmodule Say do
  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number < 0 or number >= 1_000_000_000_000,
    do: {:error, "number is out of range"}

  def in_english(number), do: {:ok, say(number)}
  
  def say(0), do: "zero"
  def say(1), do: "one"
  def say(2), do: "two"
  def say(3), do: "three"
  def say(4), do: "four"
  def say(5), do: "five"
  def say(6), do: "six"
  def say(7), do: "seven"
  def say(8), do: "eight"
  def say(9), do: "nine"
  def say(10), do: "ten"
  def say(11), do: "eleven"
  def say(12), do: "twelve"
  def say(13), do: "thirteen"
  def say(14), do: "fourteen"
  def say(15), do: "fifteen"
  def say(16), do: "sixteen"
  def say(17), do: "seventeen"
  def say(18), do: "eighteen"
  def say(19), do: "nineteen"
  def say(20), do: "twenty"
  def say(30), do: "thirty"
  def say(40), do: "forty"
  def say(50), do: "fifty"
  def say(60), do: "sixty"
  def say(70), do: "seventy"
  def say(80), do: "eighty"
  def say(90), do: "ninety"
  def say(number) when number >= 1_000_000_000, do: decompose(number, 1_000_000_000, "billion")
  def say(number) when number >= 1_000_000, do: decompose(number, 1_000_000, "million")
  def say(number) when number >= 1_000, do: decompose(number, 1_000, "thousand")
  def say(number) when number >= 100, do: decompose(number, 100, "hundred")

  def say(number) when number > 20 do
    red = rem(number, 10)
    say(number - red) <> "-" <> say(red)
  end

  defp decompose(number, n, word) do
    red = rem(number, n)
    result = div(number, n)

    case red do
      0 -> say(result) <> " #{word}"
      _ -> say(result) <> " #{word} " <> say(red)
    end
  end
end
