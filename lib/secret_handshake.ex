defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) when code not in 1..31, do: []

  def commands(code) do
    code |> Integer.digits(2) |> Enum.reverse() |> Enum.with_index() |> do_commands([])
  end

  defp do_commands([], result), do: Enum.reverse(result)
  defp do_commands([{1, 0} | t], result), do: do_commands(t, ["wink" | result])
  defp do_commands([{1, 1} | t], result), do: do_commands(t, ["double blink" | result])
  defp do_commands([{1, 2} | t], result), do: do_commands(t, ["close your eyes" | result])
  defp do_commands([{1, 3} | t], result), do: do_commands(t, ["jump" | result])
  defp do_commands([{1, 4} | t], result), do: do_commands(t, Enum.reverse(result))
  defp do_commands([{0, _} | t], result), do: do_commands(t, result)
end
