defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """

  @type cage() :: %{exclude: [1..9], size: 1..9, sum: pos_integer()}

  @spec combinations(cage()) :: [[pos_integer()]]
  def combinations(cage), do: combinations(cage, [[]])

  defp combinations(%{size: 0, sum: sum}, acc), do: Enum.filter(acc, &(Enum.sum(&1) == sum))

  defp combinations(%{exclude: exclude, size: size, sum: sum} = cage, acc) do
    new_acc =
      for n <- Range.to_list(1..9) -- exclude,
          set <- acc,
          Enum.sum([n | set]) <= sum and n not in set,
          uniq: true,
          into: [] do
        Enum.sort([n | set])
      end

    combinations(%{cage | size: size - 1}, new_acc)
  end
end
