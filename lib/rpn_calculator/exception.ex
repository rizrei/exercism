# credo:disable-for-this-file

defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception([]), do: %StackUnderflowError{}

    @impl true
    def exception(context),
      do: %StackUnderflowError{message: "stack underflow occurred, context: #{context}"}
  end

  def divide([]), do: raise(StackUnderflowError, "when dividing")
  def divide([0, _]), do: raise(DivisionByZeroError)
  def divide(list) when length(list) == 1, do: raise(StackUnderflowError, "when dividing")
  def divide([divisor, dividend]), do: dividend / divisor
end
