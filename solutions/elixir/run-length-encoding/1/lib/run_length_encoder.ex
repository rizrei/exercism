defmodule RunLengthEncoder do
  @encode_regex ~r/([a-zA-Z]|\s)\1*/
  @decode_regex ~r/(\d*)(.)/
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string), do: @encode_regex |> Regex.scan(string) |> do_encode()

  defp do_encode([]), do: ""
  defp do_encode([[group, char] | t]) when group == char, do: char <> do_encode(t)
  defp do_encode([[group, char] | t]), do: "#{String.length(group)}" <> char <> do_encode(t)

  @spec decode(String.t()) :: String.t()
  def decode(string), do: Regex.scan(@decode_regex, string) |> do_decode()

  defp do_decode([]), do: ""
  defp do_decode([[_, "", c] | t]), do: c <> do_decode(t)
  defp do_decode([[_, n, c] | t]), do: String.duplicate(c, String.to_integer(n)) <> do_decode(t)
end
