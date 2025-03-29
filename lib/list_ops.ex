# credo:disable-for-this-file

defmodule ListOps do
  @spec count(list) :: non_neg_integer
  def count(l), do: do_count(l, 0)

  defp do_count([], acc), do: acc
  defp do_count([_ | t], acc), do: do_count(t, acc + 1)

  @spec reverse(list) :: list
  def reverse(l), do: do_reverse(l, [])

  defp do_reverse([], acc), do: acc
  defp do_reverse([h | t], acc), do: do_reverse(t, [h | acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: do_map(l, f, [])

  defp do_map([], _, acc), do: acc
  defp do_map([h | t], f, acc), do: [f.(h) | do_map(t, f, acc)]

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: do_filter(l, f, [])

  defp do_filter([], _, acc), do: acc

  defp do_filter([h | t], f, acc) do
    if f.(h) do
      [h | do_filter(t, f, acc)]
    else
      do_filter(t, f, acc)
    end
  end

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl(l, acc, f), do: l |> reduce(acc, f)

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr(l, acc, f), do: l |> reverse() |> reduce(acc, f)

  @spec append(list, list) :: list
  def append([], b), do: b
  def append([h | t], b), do: [h | append(t, b)]

  @spec concat([[any]]) :: [any]
  def concat(ll), do: reduce(ll, [], &append(reverse(&1), &2)) |> reverse

  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  defp reduce([], acc, _), do: acc
  defp reduce([h | t], acc, f), do: reduce(t, f.(h, acc), f)
end
