defmodule Username do
  @allowed_characters 'abcdefghijklmnopqrstuvwxyz_'

  @spec sanitize(charlist) :: charlist
  def sanitize([]), do: []
  def sanitize([head | tail]) when head == 223, do: 'ss' ++ sanitize(tail)
  def sanitize([head | tail]) when head == 228, do: 'ae' ++ sanitize(tail)
  def sanitize([head | tail]) when head == 246, do: 'oe' ++ sanitize(tail)
  def sanitize([head | tail]) when head == 252, do: 'ue' ++ sanitize(tail)
  def sanitize([head | tail]) when head in @allowed_characters, do: [head | sanitize(tail)]
  def sanitize([_ | tail]), do: sanitize(tail)
end