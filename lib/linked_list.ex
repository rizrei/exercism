defmodule LinkedList do
  @opaque t :: tuple()

  @moduledoc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new, do: {}

  @moduledoc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem), do: {elem, list}

  @moduledoc """
  Counts the number of elements in a LinkedList
  """
  @spec count(t) :: non_neg_integer()
  def count({}), do: 0
  def count({_, l}), do: 1 + count(l)

  @moduledoc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?(list), do: list == {}

  @moduledoc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({}), do: {:error, :empty_list}
  def peek({h, _rest}), do: {:ok, h}

  @moduledoc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({}), do: {:error, :empty_list}
  def tail({_h, elem}), do: {:ok, elem}

  @moduledoc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({}), do: {:error, :empty_list}
  def pop({h, rest}), do: {:ok, h, rest}

  @moduledoc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list([]), do: {}
  def from_list([h | t]), do: {h, from_list(t)}

  @moduledoc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list({}), do: []
  def to_list({h, t}), do: [h | to_list(t)]

  @moduledoc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list), do: do_reverse(list, {})
  defp do_reverse({}, rev), do: rev
  defp do_reverse({h, t}, rev), do: do_reverse(t, {h, rev})
end
