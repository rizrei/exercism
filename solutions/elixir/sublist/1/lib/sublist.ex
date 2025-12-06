defmodule Sublist do
  @spec compare([pos_integer], [pos_integer]) :: :equal | :unequal | :sublist | :superlist
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(l1, l2) when l1 == l2, do: :equal
  def compare(l1, l2) when l1 != l2 and length(l1) == length(l2), do: :unequal
  def compare(l1, [_ | tail]) when length(l1) == length(tail) and l1 == tail, do: :sublist
  def compare([_ | tail], l2) when length(tail) == length(l2) and l2 == tail, do: :superlist
  def compare([_ | tail] = l1, l2) when length(l1) > length(l2) do
    if List.starts_with?(l1, l2), do: :superlist, else: compare(tail, l2)
  end
  def compare(l1, [_ | tail] = l2) when length(l1) < length(l2) do
    if List.starts_with?(l2, l1), do: :sublist, else: compare(l1, tail)
  end

  def compare(_, _), do: :unequal
end
