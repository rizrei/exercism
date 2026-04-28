# credo:disable-for-this-file

defmodule LogParser do
  @spec valid_line?(String.t()) :: boolean()
  def valid_line?(line), do: String.match?(line, ~r/\A\[(DEBUG|INFO|WARNING|ERROR)\].*\z/)

  @spec split_line(String.t()) :: [String.t()]
  def split_line(line), do: String.split(line, ~r/<(~|\*|=|and|-)*>/)

  @spec remove_artifacts(String.t()) :: String.t()
  def remove_artifacts(line), do: String.replace(line, ~r/end-of-line\d+/i, "")

  @spec tag_with_user_name(String.t()) :: String.t()
  def tag_with_user_name(line) do
    ~r/User\s+(?<name>\S+)/
    |> Regex.run(line, capture: :all_names)
    |> then(&(&1 && Enum.join(["[USER]", hd(&1), line], " "))) || line
  end
end
