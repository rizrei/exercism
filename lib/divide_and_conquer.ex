defmodule DivideAndConquer do
  def divide({length, width}) do
    do_divide({length, width}, [])
  end

  defp do_divide({length, length}, acc), do: [{length, length} | acc]

  defp do_divide({length, width}, acc) do
    min = min(length, width)
    max = max(length, width)
    do_divide({max - min, min}, [{min, min} | acc])
  end
end
