defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean

  def chain?([]), do: true
  def chain?([{a, a}]), do: true
  def chain?([{_a, _b}]), do: false
  def chain?(dominoes), do: [] !== chains(dominoes)

  defp chains(dominoes) do
    for [first | tail] <- permutations(dominoes),
        {:ok, result} <- do_chain(tail, [first]),
        do: result
  end

  defp do_chain([], acc) do
    {a, _} = List.first(acc)
    {_, b} = List.last(acc)
    if a == b, do: [{:ok, acc}], else: [{:error, "start and end does not match"}]
  end

  defp do_chain([{a, b} | tail], [{c, _} | _] = acc) do
    cond do
      a == c -> do_chain(tail, [{b, a} | acc])
      b == c -> do_chain(tail, [{a, b} | acc])
      true -> [{:error, "not a chain"}]
    end
  end

  defp permutations([]), do: [[]]

  defp permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
end
