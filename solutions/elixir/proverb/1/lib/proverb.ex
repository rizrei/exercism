defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""
  def recite([s]), do: do_recite([s])

  def recite([s1 | _] = strings) do
    strings
    |> Enum.chunk_every(2, 1, :discard)
    |> Kernel.++([[s1]])
    |> Enum.map(&do_recite/1)
    |> Enum.join()
  end

  def do_recite([s]), do: "And all for the want of a #{s}.\n"
  def do_recite([s1, s2]), do: "For want of a #{s1} the #{s2} was lost.\n"
end
