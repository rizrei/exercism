defmodule RPNCalculator do
  def calculate!(stack, operation), do: operation.(stack)

  def calculate(stack, operation) do
    try do
      calculate!(stack, operation)
    rescue
      _ -> :error
    else
      result -> {:ok, result}
    end
  end

  def calculate_verbose(stack, operation) do
    try do
      calculate!(stack, operation)
    rescue
      error in ArgumentError -> {:error, error.message}
      error -> {:error, error}
    else
      result -> {:ok, result}
    end
  end
end
