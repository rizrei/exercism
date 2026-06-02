defmodule Username do
  @replacements %{
    ?ä => ~c"ae",
    ?ö => ~c"oe",
    ?ü => ~c"ue",
    ?ß => ~c"ss",
    ?_ => ~c"_"
  }

  @spec sanitize(charlist) :: charlist
  def sanitize([]), do: []

  def sanitize([head | tail]) do
    replacement =
      case head do
        char when char in ?a..?z -> [char]
        char when is_map_key(@replacements, char) -> [@replacements[char]]
        _ -> ~c""
      end

    replacement ++ sanitize(tail)
  end
end
