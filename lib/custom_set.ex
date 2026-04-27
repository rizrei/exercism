defmodule CustomSet do
  defstruct map: %{}

  @type t() :: %__MODULE__{map: %{term() => true}}

  @spec new(Enum.t()) :: t()
  def new(enumerable), do: %__MODULE__{map: Map.new(enumerable, &{&1, true})}

  @spec empty?(t()) :: boolean()
  def empty?(%{map: map}), do: map_size(map) == 0

  @spec contains?(t(), any()) :: boolean()
  def contains?(%{map: map}, key), do: Map.has_key?(map, key)

  @spec subset?(t(), t()) :: boolean()
  def subset?(%{map: map1}, %{map: map2}),
    do: Enum.all?(map1, fn {key, _} -> Map.has_key?(map2, key) end)

  @spec disjoint?(t(), t()) :: boolean()
  def disjoint?(%{map: map1}, %{map: map2}),
    do: !Enum.any?(map1, fn {key, _} -> Map.has_key?(map2, key) end)

  @spec equal?(t(), t()) :: boolean()
  def equal?(%{map: map1}, %{map: map2}), do: Map.equal?(map1, map2)

  @spec add(t(), any()) :: t()
  def add(%{map: map} = set, key), do: %{set | map: Map.put(map, key, true)}

  @spec intersection(t(), t()) :: t()
  def intersection(%{map: map1} = set, %{map: map2}),
    do: %{set | map: Map.take(map1, Map.keys(map2))}

  @spec difference(t(), t()) :: t()
  def difference(%{map: map1} = set, %{map: map2}),
    do: %{set | map: Map.drop(map1, Map.keys(map2))}

  @spec union(t(), t()) :: t()
  def union(%{map: map1} = set, %{map: map2}), do: %{set | map: Map.merge(map1, map2)}
end
