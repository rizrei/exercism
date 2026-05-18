defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @moduledoc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?([domino()]) :: boolean()

  def chain?([]), do: true
  def chain?([{n1, n2}]), do: n1 == n2

  def chain?([{n1, n2} | dominoes]) do
    Enum.any?(
      dominoes,
      fn
        {^n1, x} = domino -> chain?([{n2, x} | List.delete(dominoes, domino)])
        {x, ^n1} = domino -> chain?([{n2, x} | List.delete(dominoes, domino)])
        _ -> false
      end
    )
  end
end
