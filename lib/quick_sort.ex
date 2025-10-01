defmodule QuickSort do
  @moduledoc false

  def qsort([]), do: []

  def qsort([pivot | t]) do
    {lower, higher} = Enum.split_with(t, fn x -> x < pivot end)
    qsort(lower) ++ [pivot] ++ qsort(higher)
  end
end
