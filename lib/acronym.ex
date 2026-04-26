defmodule Acronym do
  @moduledoc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string |> String.split([" ", "-", "_"], trim: true) |> Enum.map_join("", &upcase_first/1)
  end

  defp upcase_first(str), do: str |> String.at(0) |> String.capitalize()
end
