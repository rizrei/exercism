defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""
  def recite([s]), do: "And all for the want of a #{s}.\n"

  def recite([s1 | _] = strings) do
    Enum.chunk_every(strings, 2, 1, :discard)
    |> Enum.map_join(fn [s1, s2] -> "For want of a #{s1} the #{s2} was lost.\n" end)
    |> Kernel.<>("And all for the want of a #{s1}.\n")
  end
end
