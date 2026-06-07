defmodule FlattenArray do
  @moduledoc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list()) :: list()
  def flatten(list), do: do_flatten(list, [])

  defp do_flatten([], acc), do: acc
  defp do_flatten([nil | t], acc), do: do_flatten(t, acc)
  defp do_flatten([h | t], acc) when is_list(h), do: do_flatten(h, do_flatten(t, acc))
  defp do_flatten([h | t], acc), do: [h | do_flatten(t, acc)]
end
