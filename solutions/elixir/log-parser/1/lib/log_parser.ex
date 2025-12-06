defmodule LogParser do
  def valid_line?(line), do: line |> String.match?(~r/\A\[(DEBUG|INFO|WARNING|ERROR)\].*\z/)

  def split_line(line), do: line |> String.split(~r/<(~|\*|=|and|-)*>/)

  def remove_artifacts(line), do: line |> String.replace(~r/end-of-line\d+/i, "")

  def tag_with_user_name(line) do
    name = ~r/User\s+(?<name>\S+)/ |> Regex.run(line, capture: :all_names)
    do_tag_with_user_name(line, name)
  end

  defp do_tag_with_user_name(line, nil), do: line
  defp do_tag_with_user_name(line, [name | _]), do: ["[USER]", name, line] |> Enum.join(" ")
end
