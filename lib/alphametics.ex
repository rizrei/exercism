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
    graphemes = graphemes(puzzle)

    0..9
    |> Enum.to_list()
    |> permutations(length(graphemes))
    |> find_solution(puzzle, graphemes)
  end

  defp graphemes(puzzle) do
    for <<char <- puzzle>>, char in ?A..?Z, uniq: true, do: char
  end

  defp permutations(_list, 0), do: [[]]

  defp permutations(list, len) do
    for elem <- list, rest <- permutations(list -- [elem], len - 1) do
      [elem | rest]
    end
  end

  defp find_solution([], _, _), do: nil

  defp find_solution([digits | tail], puzzle, graphemes) do
    solution = graphemes |> Enum.zip(digits) |> Map.new()

    if valid?(solution, puzzle), do: solution, else: find_solution(tail, puzzle, graphemes)
  end

  defp valid?(solution, puzzle) do
    word_equation =
      Enum.reduce(solution, puzzle, fn {char, digit}, equation ->
        String.replace(equation, <<char>>, to_string(digit))
      end)

    valid_word_equation(word_equation) and not leading_zero?(word_equation)
  end

  defp valid_word_equation(word_equation) do
    Code.eval_string(word_equation) |> then(fn {solved?, []} -> solved? end)
  end

  defp leading_zero?(word_equation), do: String.match?(word_equation, ~r/\b0/)
end
