defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new, do: {}

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem), do: list |> Tuple.append(elem)

  @doc """
  Counts the number of elements in a LinkedList
  """
  @spec count(t) :: non_neg_integer()
  def count(list), do: list |> tuple_size()

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?({}), do: true
  def empty?(_), do: false

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({}), do: {:error, :empty_list}

  def peek(list) do
    last_index = list |> count |> Kernel.-(1)
    {:ok, list |> elem(last_index)}
  end

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({}), do: {:error, :empty_list}

  def tail(list) do
    last_index = list |> count |> Kernel.-(1)
    {:ok, list |> Tuple.delete_at(last_index)}
  end

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({}), do: {:error, :empty_list}

  def pop(list) do
    {:ok, peek} = peek(list)
    {:ok, tail} = tail(list)
    {:ok, peek, tail}
  end

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list), do: list |> Enum.reverse() |> List.to_tuple()

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list), do: list |> reverse() |> Tuple.to_list()

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list), do: list |> do_reverse({})

  defp do_reverse({}, new_list), do: new_list

  defp do_reverse(list, new_list) do
    {:ok, peek, tail} = list |> pop()
    do_reverse(tail, new_list |> push(peek))
  end
end
