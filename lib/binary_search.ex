defmodule BinarySearch do
  @moduledoc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """
  @spec search(tuple, non_neg_integer()) :: {:ok, non_neg_integer} | :not_found
  def search({}, _key), do: :not_found

  def search(numbers, key) do
    do_search(numbers, key, 0, tuple_size(numbers) - 1)
  end

  defp do_search(_numbers, _key, low, high) when low > high, do: :not_found

  defp do_search(numbers, key, low, high) do
    middle = div(low + high, 2)

    case elem(numbers, middle) do
      ^key -> {:ok, middle}
      element when key > element -> do_search(numbers, key, middle + 1, high)
      element when key < element -> do_search(numbers, key, low, middle - 1)
    end
  end
end
