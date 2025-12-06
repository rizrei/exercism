defmodule RPNCalculator do
  def calculate!(stack, operation), do: operation.(stack)

  def calculate(stack, operation) do
    {:ok, calculate!(stack, operation)}
  rescue
    _error -> :error
  end
  
  def calculate_verbose(stack, operation) do
    {:ok, calculate!(stack, operation)}
  rescue
    error -> {:error, error.message}
  end
end
