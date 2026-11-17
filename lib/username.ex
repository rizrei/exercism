defmodule Username do
  @replacements %{
    ?ä => ~c"ae",
    ?ö => ~c"oe",
    ?ü => ~c"ue",
    ?ß => ~c"ss",
    ?_ => ~c"_"
  }

  @spec sanitize(charlist()) :: charlist()
  def sanitize(username), do: do_sanitize(username, [])

  defp do_sanitize([], acc), do: Enum.reverse(acc)

  defp do_sanitize([h | t], acc) do
    acc =
      case h do
        char when char in ?a..?z ->
          [h | acc]

        char when is_map_key(@replacements, char) ->
          @replacements |> Map.get(h) |> Enum.reduce(acc, &[&1 | &2])

        _ ->
          acc
      end

    do_sanitize(t, acc)
  end
end

defmodule Username.V2 do
  def sanitize([c | username]) when c in ?a..?z, do: [c | sanitize(username)]
  def sanitize([?_ | username]), do: [?_ | sanitize(username)]
  def sanitize([?ä | username]), do: [?a, ?e | sanitize(username)]
  def sanitize([?ö | username]), do: [?o, ?e | sanitize(username)]
  def sanitize([?ü | username]), do: [?u, ?e | sanitize(username)]
  def sanitize([?ß | username]), do: [?s, ?s | sanitize(username)]
  def sanitize([_ | username]), do: sanitize(username)
  def sanitize([]), do: []
end

defmodule Username.V3 do
  def sanitize(~c"") do
    ~c""
  end

  def sanitize([head | tail]) do
    sanitized =
      case head do
        ?ß -> ~c"ss"
        ?ä -> ~c"ae"
        ?ö -> ~c"oe"
        ?ü -> ~c"ue"
        x when x >= ?a and x <= ?z -> [x]
        ?_ -> ~c"_"
        _ -> ~c""
      end

    sanitized ++ sanitize(tail)
  end
end

defmodule Username.V4 do
  @replacements %{
    ?ä => ~c"ae",
    ?ö => ~c"oe",
    ?ü => ~c"ue",
    ?ß => ~c"ss",
    ?_ => ~c"_"
  }

  @spec sanitize(charlist()) :: charlist()
  def sanitize(username), do: do_sanitize(username, [])

  defp do_sanitize([], acc), do: Enum.reverse(acc)

  defp do_sanitize([h | t], acc) when h in ?a..?z do
    do_sanitize(t, [h | acc])
  end

  defp do_sanitize([h | t], acc) when is_map_key(@replacements, h) do
    do_sanitize(t, @replacements |> Map.get(h) |> Enum.reduce(acc, &[&1 | &2]))
  end

  defp do_sanitize([_ | t], acc) do
    do_sanitize(t, acc)
  end
end

defmodule Username.V5 do
  def sanitize(username), do: do_sanitize(username, [])

  defp do_sanitize([], acc), do: Enum.reverse(acc)
  defp do_sanitize([c | t], acc) when c in ?a..?z, do: do_sanitize(t, [c | acc])
  defp do_sanitize([?_ | t], acc), do: do_sanitize(t, [?_ | acc])
  defp do_sanitize([?ä | t], acc), do: do_sanitize(t, [?e, ?a | acc])
  defp do_sanitize([?ö | t], acc), do: do_sanitize(t, [?e, ?o | acc])
  defp do_sanitize([?ü | t], acc), do: do_sanitize(t, [?e, ?u | acc])
  defp do_sanitize([?ß | t], acc), do: do_sanitize(t, [?s, ?s | acc])
  defp do_sanitize([_ | t], acc), do: do_sanitize(t, acc)
end
