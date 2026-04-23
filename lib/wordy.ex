defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """

  @regex ~r/.*?\d+/

  @spec answer(String.t()) :: integer() | no_return()
  def answer(question) do
    question
    |> String.split(@regex, include_captures: true, trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(0, &reducer/2)
  end

  defp reducer("What is " <> n, acc), do: acc + String.to_integer(n)
  defp reducer("plus " <> n, acc), do: acc + String.to_integer(n)
  defp reducer("minus " <> n, acc), do: acc - String.to_integer(n)
  defp reducer("multiplied by " <> n, acc), do: acc * String.to_integer(n)
  defp reducer("divided by " <> n, acc), do: div(acc, String.to_integer(n))
  defp reducer("?", acc), do: acc
  defp reducer(_, _), do: raise(ArgumentError, "invalid string")
end
