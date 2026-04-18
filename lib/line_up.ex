defmodule LineUp do
  @doc """
  Formats a full ticket sentence for the given name and number, including
  the person's name, the ordinal form of the number, and fixed descriptive text.
  """

  @spec format(String.t(), pos_integer()) :: String.t()
  def format(name, number) do
    ones = rem(number, 10)
    tens = rem(number, 100)
    "#{name}, you are the #{number}#{get_suffix(ones, tens)} customer we serve today. Thank you!"
  end

  defp get_suffix(1, 11), do: "th"
  defp get_suffix(1, _), do: "st"
  defp get_suffix(2, 12), do: "th"
  defp get_suffix(2, _), do: "nd"
  defp get_suffix(3, 13), do: "th"
  defp get_suffix(3, _), do: "rd"
  defp get_suffix(_, _), do: "th"
end
