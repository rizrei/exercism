defmodule Alphametics do
  @type puzzle :: String.t()
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

      iex> Alphametics.solve("I + BB == ILL")
      %{?I => 1, ?B => 9, ?L => 0}

      iex> Alphametics.solve("A == B")
      nil
  """

  @spec solve(puzzle()) :: solution() | nil
  def solve(puzzle) do
    {total, terms} =
      puzzle
      |> String.split(~r/ \+ | \=\= /)
      |> Enum.map(&to_charlist/1)
      |> List.pop_at(-1)

    leading_chars = [hd(total) | Enum.map(terms, &hd/1)] |> Enum.uniq()

    rest_chars =
      for <<char <- puzzle>>, char in ?A..?Z, char not in leading_chars, uniq: true, do: char

    leading_chars
    |> permutations(rest_chars)
    |> Enum.find(&valid?(&1, terms, total))
  end

  defp permutations(leading, letters, taken \\ [])
  defp permutations([], [], _taken), do: [%{}]

  defp permutations([head | leading], letters, taken) do
    for val <- Enum.to_list(1..9) -- taken,
        perm <- permutations(leading, letters, [val | taken]) do
      Map.put(perm, head, val)
    end
  end

  defp permutations([], [head | letters], taken) do
    for val <- Enum.to_list(0..9) -- taken,
        perm <- permutations([], letters, [val | taken]) do
      Map.put(perm, head, val)
    end
  end

  defp valid?(solution, terms, total) do
    to_int(total, solution) == terms |> Enum.map(&to_int(&1, solution)) |> Enum.sum()
  end

  defp to_int(chars, solution) do
    Enum.reduce(chars, 0, fn char, n -> 10 * n + Map.get(solution, char) end)
  end
end
