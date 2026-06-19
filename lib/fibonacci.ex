defmodule Fibonacchi do
  def fibonacchi(0), do: 0
  def fibonacchi(1), do: 1
  def fibonacchi(n), do: do_finonacchi(n, 2, {1, 0})

  defp do_finonacchi(n, n, {a, b}), do: a + b
  defp do_finonacchi(n, step, {a, b}), do: do_finonacchi(n, step + 1, {a + b, a})
end
