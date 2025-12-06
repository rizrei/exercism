defmodule Username do
  @spec sanitize(charlist) :: charlist
  def sanitize([]), do: []
  def sanitize([head | tail]) when head in ?a..?z, do: [head | sanitize(tail)]
  def sanitize([head | tail]) do
    case head do
      ?ä -> 'ae'
      ?ö -> 'oe'
      ?ü -> 'ue'
      ?ß -> 'ss'
      ?_ -> '_'
      _ -> ''
   end ++ sanitize(tail)
  end
end
