defmodule TopSecret do
  def to_ast(string), do: Code.string_to_quoted!(string)

  def decode_secret_message_part({op, _, args} = ast, acc) when op in [:def, :defp] do
    {function_name, function_args} = get_function_name_and_args(args)

    arity = length(function_args)
    message = function_name |> to_string() |> String.slice(0, arity)
    {ast, [message | acc]}
  end

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  defp get_function_name_and_args([{:when, _, args} | _]), do: get_function_name_and_args(args)
  defp get_function_name_and_args([{name, _, args} | _]) when is_list(args), do: {name, args}
  defp get_function_name_and_args([{name, _, args} | _]) when is_atom(args), do: {name, []}

  @spec decode_secret_message(any) :: any
  def decode_secret_message(string) do
    {_, acc} = string |> to_ast() |> Macro.prewalk([], &decode_secret_message_part/2)

    acc
    |> Enum.reverse()
    |> Enum.join("")
  end
end
