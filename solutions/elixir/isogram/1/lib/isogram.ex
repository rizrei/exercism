defmodule Isogram do
  @regex ~r/([a-z]).*\1/i

  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence), do: sentence |> String.match?(@regex) |> Kernel.not()
end
