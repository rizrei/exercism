defmodule Username do
  @spec sanitize(charlist) :: charlist
  def sanitize([]), do: []
  def sanitize([head | tail]) when head in ?a..?z, do: [head | sanitize(tail)]
  def sanitize([?ä | tail]), do: 'ae' ++ sanitize(tail)
  def sanitize([?ö | tail]), do: 'oe' ++ sanitize(tail)
  def sanitize([?ü | tail]), do: 'ue' ++ sanitize(tail)
  def sanitize([?ß | tail]), do: 'ss' ++ sanitize(tail)
  def sanitize([?_ | tail]), do: '_' ++ sanitize(tail)
  def sanitize([_ | tail]), do: sanitize(tail)
end
