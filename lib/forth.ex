defmodule Forth do
  alias Forth.{Stack, InvalidWord, UnknownWord}

  @opaque evaluator :: %__MODULE__{
            stack: Stack.t(),
            mode: atom(),
            words: %{String.t() => Stack.operation()}
          }

  defstruct stack: [],
            mode: :eval,
            words: %{
              "+" => &Stack.add/1,
              "-" => &Stack.sub/1,
              "*" => &Stack.mul/1,
              "/" => &Stack.div/1,
              "dup" => &Stack.dup/1,
              "drop" => &Stack.drop/1,
              "swap" => &Stack.swap/1,
              "over" => &Stack.over/1
            }

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator()
  def new(), do: %__MODULE__{}

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator(), String.t()) :: evaluator()
  def eval(evaluator, string) do
    string
    |> String.downcase()
    |> String.split(~r/[[:space:]|[:cntrl:]]/u, trim: true)
    |> Enum.reduce(evaluator, &evaluator(&2, &1))
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator()) :: String.t()
  def format_stack(%{stack: stack}), do: stack |> Enum.reverse() |> Enum.join(" ")

  defp evaluator(%{stack: stack, mode: mode} = evaluator, elem) do
    case {mode, Integer.parse(elem)} do
      {mode, number} when mode == :define_fn or number == :error -> eval_elem(evaluator, elem)
      {:eval, {int, ""}} -> %{evaluator | stack: [int | stack]}
      {:define_fn_name, {_number, _}} -> raise InvalidWord, word: elem
      _ -> raise InvalidWord, word: elem
    end
  end

  defp eval_elem(%{mode: :eval} = evaluator, ":"), do: %{evaluator | mode: :define_fn_name}

  defp eval_elem(%{stack: [{word, func} | stack_t], mode: :define_fn, words: words} = ev, ";") do
    stack_operation = fn stack ->
      func
      |> Enum.reverse()
      |> Enum.reduce(%{ev | stack: stack, mode: :eval}, &evaluator(&2, &1))
      |> Map.get(:stack)
    end

    %{ev | stack: stack_t, mode: :eval, words: Map.put(words, word, stack_operation)}
  end

  defp eval_elem(%{stack: stack, mode: :eval, words: words} = ev, word)
       when is_map_key(words, word) do
    %{ev | stack: apply(words[word], [stack])}
  end

  defp eval_elem(%{stack: stack, mode: :define_fn_name} = ev, word) do
    %{ev | stack: [{word, []} | stack], mode: :define_fn}
  end

  defp eval_elem(%{stack: [{func_name, func_stack} | stack], mode: :define_fn} = ev, word) do
    %{ev | stack: [{func_name, [word | func_stack]} | stack]}
  end

  defp eval_elem(_, word), do: raise(UnknownWord, word: word)

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end

  defmodule Stack do
    alias Forth

    @type t() :: [integer()]
    @type operation() :: (t() -> t() | no_return())

    @spec add(t()) :: t() | no_return()
    def add([b, a | stack]), do: [a + b | stack]
    def add(_), do: raise(Forth.StackUnderflow)

    @spec sub(t()) :: t() | no_return()
    def sub([b, a | stack]), do: [a - b | stack]
    def sub(_), do: raise(Forth.StackUnderflow)

    @spec mul(t()) :: t() | no_return()
    def mul([b, a | stack]), do: [a * b | stack]
    def mul(_), do: raise(Forth.StackUnderflow)

    @spec div(t()) :: t() | no_return()
    def div([0, _a | _]), do: raise(Forth.DivisionByZero)
    def div([b, a | stack]), do: [div(a, b) | stack]
    def div(_), do: raise(Forth.StackUnderflow)

    @spec dup(t()) :: t() | no_return()
    def dup([head | stack]), do: [head, head | stack]
    def dup(_), do: raise(Forth.StackUnderflow)

    @spec drop(t()) :: t() | no_return()
    def drop([_head | stack]), do: stack
    def drop(_), do: raise(Forth.StackUnderflow)

    @spec swap(t()) :: t() | no_return()
    def swap([b, a | stack]), do: [a, b | stack]
    def swap(_), do: raise(Forth.StackUnderflow)

    @spec over(t()) :: t() | no_return()
    def over([_b, a | _] = stack), do: [a | stack]
    def over(_stack), do: raise(Forth.StackUnderflow)
  end
end
