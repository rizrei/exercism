defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.split([" ", "-", "_"], trim: true)
    |> Enum.map_join("", &(&1 |> String.at(0) |> String.capitalize()))
  end
end
