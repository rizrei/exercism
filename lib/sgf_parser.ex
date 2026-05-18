defmodule SgfParsing do
  defmodule Sgf do
    @type t() :: %__MODULE__{
            properties: map(),
            children: [t()]
          }
    defstruct properties: %{}, children: []
  end

  @doc """
  Parse a string into a Smart Game Format tree
  """
  @spec parse(String.t()) :: {:ok, Sgf.t()} | {:error, String.t()}
  def parse(encoded) do
    with {:ok, sgf, _} <- do_parse(encoded) do
      {:ok, sgf}
    end
  end

  defp do_parse("()"), do: {:error, "tree with no nodes"}
  defp do_parse(";"), do: {:error, "tree missing"}
  defp do_parse(""), do: {:error, "tree missing"}
  defp do_parse("(;" <> node), do: parse_node(node)
  defp do_parse(";" <> node), do: parse_node(node)

  defp parse_node(node) do
    with {:ok, properties, children} <- parse_properties(node),
         {:ok, children, rest} <- parse_children(children, []) do
      {:ok, %Sgf{properties: properties, children: children}, rest}
    end
  end

  defp parse_properties(";" <> _ = rest), do: {:ok, %{}, rest}
  defp parse_properties("(" <> _ = rest), do: {:ok, %{}, rest}
  defp parse_properties(")" <> _ = rest), do: {:ok, %{}, rest}

  defp parse_properties(node) do
    with {:ok, key, values} <- extract_name(node),
         {:ok, values, props} <- extract_values(values),
         {:ok, other_properties, rest} <- parse_properties(props) do
      {:ok, Map.put(other_properties, key, values), rest}
    end
  end

  defp extract_name(<<key, rest::binary>>) when key in ?A..?Z do
    with {:ok, keys, rest} <- extract_name(rest) do
      {:ok, <<key>> <> keys, rest}
    end
  end

  defp extract_name("[" <> _ = rest), do: {:ok, "", rest}

  defp extract_name(<<key, _::binary>>) when key in ?a..?z,
    do: {:error, "property must be in uppercase"}

  defp extract_name(<<key, _::binary>>) when key in [?), ?(, ?;],
    do: {:error, "properties without delimiter"}

  defp extract_values("[" <> rest) do
    with {:ok, value, values} <- extract_value(rest),
         {:ok, values, rest} <- extract_values(values) do
      {:ok, [value | values], rest}
    end
  end

  defp extract_values(rest), do: {:ok, [], rest}
  defp extract_value("\\\n" <> rest), do: extract_value(rest)

  defp extract_value("\\\t" <> rest) do
    with {:ok, value, rest} <- extract_value(rest) do
      {:ok, " " <> value, rest}
    end
  end

  defp extract_value("\t" <> rest) do
    with {:ok, value, rest} <- extract_value(rest) do
      {:ok, " " <> value, rest}
    end
  end

  defp extract_value(<<"\\", char, rest::binary>>) do
    with {:ok, value, rest} <- extract_value(<<rest::binary>>) do
      {:ok, <<char>> <> value, rest}
    end
  end

  defp extract_value("]" <> rest), do: {:ok, "", rest}

  defp extract_value(<<char, rest::binary>>) do
    with {:ok, value, rest} <- extract_value(<<rest::binary>>) do
      {:ok, <<char>> <> value, rest}
    end
  end

  defp parse_children("(;" <> node, acc) do
    with {:ok, child, <<?), children::binary>>} <- parse_node(node),
         {:ok, children, <<?), rest::binary>>} <-
           parse_children(<<children::binary>>, [child | acc]) do
      {:ok, children, rest}
    end
  end

  defp parse_children(";" <> node, _) do
    with {:ok, child, rest} <- parse_node(node) do
      {:ok, [child], rest}
    end
  end

  defp parse_children(node, acc), do: {:ok, Enum.reverse(acc), node}
end
