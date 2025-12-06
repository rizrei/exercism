defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase |> String.split(" ") |> Enum.map(&(do_translate(&1) <> "ay")) |> Enum.join(" ")
  end

  @vowels ~w[a e i o u]
  @consonant ~w[b c d f g h j k l m n p q r s t v w x y z]

  def do_translate(<<char::binary-size(1), _::binary>> = word) when char in @vowels, do: word

  def do_translate(<<char1::binary-size(1), char2::binary-size(1), _::binary>> = word)
      when char1 in ~w[x y] and char2 in @consonant,
      do: word

  def do_translate("qu" <> rest), do: rest <> "qu"

  def do_translate(<<char::binary-size(1), rest::binary>>) when char in @consonant,
    do: do_translate(rest <> char)
end
