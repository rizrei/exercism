defmodule LanguageList do
  @spec new :: []
  def new(), do: []

  @spec add(list(), String.t()) :: [String.t()]
  def add(list, language), do: [language | list]

  @spec remove([String.t()]) :: [String.t()] | []
  def remove([_ | tail]), do: tail

  @spec first([String.t()]) :: String.t()
  def first([head | _]), do: head

  @spec count([String.t()]) :: non_neg_integer
  def count(list), do: list |> length()

  @spec functional_list?([String.t()]) :: boolean
  def functional_list?(list), do: list |> Enum.member?("Elixir")
end
