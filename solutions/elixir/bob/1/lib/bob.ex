defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    input = input |> String.trim()
    cond do
      upcase?(input) and question?(input) -> "Calm down, I know what I'm doing!"
      input == "" -> "Fine. Be that way!"
      upcase?(input) -> "Whoa, chill out!"
      question?(input) -> "Sure."
      true -> "Whatever."
    end
  end

  defp upcase?(input), do: String.match?(input, ~r/[A-Z|\p{L}]+/) and String.upcase(input) == input
  defp question?(input), do: input |> String.ends_with?("?")
end