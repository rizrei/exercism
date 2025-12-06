defmodule LanguageList do
  @spec new :: []
  def new(), do: []

  @spec add(list(), binary()) :: nonempty_maybe_improper_list()
  def add(list, language), do: [language | list]

  @spec remove(nonempty_maybe_improper_list) :: any
  def remove([_ | tail]), do: tail

  @spec first(nonempty_maybe_improper_list) :: any
  def first([head | _]), do: head

  @spec count(list) :: non_neg_integer
  def count(list), do: list |> length()

  @spec functional_list?(list()) :: boolean
  def functional_list?(list), do: "Elixir" in list
end
