defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(m) do
    m
    |> String.split("\n")
    |> Enum.map_join(&process_line/1)
    |> process_tags
    |> add_ul
  end

  defp process_line("* " <> str), do: "<li>#{str}</li>"
  defp process_line(line = "#" <> _), do: parse_header(line, 0)
  defp process_line(line), do: "<p>#{line}</p>"
  defp parse_header(line = "#######" <> _, 0), do: "<p>#{line}</p>"
  defp parse_header(" " <> str, len), do: "<h#{len}>#{str}</h#{len}>"
  defp parse_header("#" <> str, len), do: parse_header(str, len + 1)

  defp process_tags(line) do
    line
    |> String.replace(~r/__([^_]+)__/, "<strong>\\1</strong>")
    |> String.replace(~r/_([^_]+)_/, "<em>\\1</em>")
  end

  defp add_ul(m), do: String.replace(m, ~r/<li>.*<\/li>/, "<ul>\\0</ul>")
end
