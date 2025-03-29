defmodule Sublist do
  @moduledoc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  @spec compare([pos_integer], [pos_integer]) :: :equal | :unequal | :sublist | :superlist
  def compare(l, l), do: :equal
  def compare(l1, l2) when length(l1) == length(l2), do: :unequal

  def compare(l1, l2) when length(l1) < length(l2) do
    if sublist?(l1, l2), do: :sublist, else: :unequal
  end

  def compare(l1, l2) when length(l1) > length(l2) do
    if sublist?(l2, l1), do: :superlist, else: :unequal
  end

  defp sublist?([], _), do: true
  defp sublist?(_, []), do: false
  defp sublist?(l1, l2), do: List.starts_with?(l2, l1) || sublist?(l1, tl(l2))
end
