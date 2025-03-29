defmodule RunLengthEncoder do
  @encode_regex ~r/([\p{L}\s])\1+/
  @decode_regex ~r/(\d+)([\p{L}\s])/
  @moduledoc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    Regex.replace(@encode_regex, string, fn consecutive_strings, string ->
      "#{String.length(consecutive_strings)}#{string}"
    end)
  end

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    Regex.replace(@decode_regex, string, fn _struct, number, letter ->
      String.duplicate(letter, String.to_integer(number))
    end)
  end
end
