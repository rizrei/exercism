defmodule TopSecret do
  def to_ast(string), do: Code.string_to_quoted!(string)

  def decode_secret_message_part({:defp, _, [ast_node | _]} = ast, acc),
    do: {ast, fetch_func_name(ast_node, acc)}

  def decode_secret_message_part({:def, _, [ast_node | _]} = ast, acc),
    do: {ast, fetch_func_name(ast_node, acc)}

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  defp fetch_func_name({:when, _, [ast_node | _]}, acc), do: fetch_func_name(ast_node, acc)
  defp fetch_func_name({_, _, nil}, acc), do: ["" | acc]
  defp fetch_func_name({f, _, l}, acc), do: [f |> to_string() |> String.slice(0, length(l)) | acc]

  @spec decode_secret_message(any) :: any
  def decode_secret_message(string) do
    {_, acc} =
      string
      |> to_ast()
      |> Macro.prewalk([], fn
        {:def, _, _} = ast, acc -> decode_secret_message_part(ast, acc)
        {:defp, _, _} = ast, acc -> decode_secret_message_part(ast, acc)
        other, acc -> {other, acc}
      end)

    acc |> Enum.reverse() |> Enum.join()
  end
end
