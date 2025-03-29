defmodule Username do
  @moduledoc """
  VariableLengthQuantity
  """
  @spec sanitize(charlist) :: charlist
  def sanitize([]), do: []
  def sanitize([head | tail]) when head in ?a..?z, do: [head | sanitize(tail)]
  def sanitize([?ä | tail]), do: ~c"ae" ++ sanitize(tail)
  def sanitize([?ö | tail]), do: ~c"oe" ++ sanitize(tail)
  def sanitize([?ü | tail]), do: ~c"ue" ++ sanitize(tail)
  def sanitize([?ß | tail]), do: ~c"ss" ++ sanitize(tail)
  def sanitize([?_ | tail]), do: ~c"_" ++ sanitize(tail)
  def sanitize([_ | tail]), do: sanitize(tail)
end
