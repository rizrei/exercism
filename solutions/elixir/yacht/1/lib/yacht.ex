defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer

  def score(category, dices), do: dices |> Enum.sort() |> do_score(category)

  defp do_score(dices, :ones), do: dices |> simple_score(1)
  defp do_score(dices, :twos), do: dices |> simple_score(2)
  defp do_score(dices, :threes), do: dices |> simple_score(3)
  defp do_score(dices, :fours), do: dices |> simple_score(4)
  defp do_score(dices, :fives), do: dices |> simple_score(5)
  defp do_score(dices, :sixes), do: dices |> simple_score(6)
  defp do_score([d, d, d, d, d], :full_house), do: 0
  defp do_score([d1, d1, d2, d2, d2], :full_house), do: d1 * 2 + d2 * 3
  defp do_score([d1, d1, d1, d2, d2], :full_house), do: d1 * 3 + d2 * 2
  defp do_score([1, 2, 3, 4, 5], :little_straight), do: 30
  defp do_score([2, 3, 4, 5, 6], :big_straight), do: 30
  defp do_score([d, d, d, d, _], :four_of_a_kind), do: d * 4
  defp do_score([_, d, d, d, d], :four_of_a_kind), do: d * 4
  defp do_score(dices, :choice), do: dices |> Enum.sum()
  defp do_score([d, d, d, d, d], :yacht), do: 50
  defp do_score(_, _), do: 0

  defp simple_score(dices, num), do: dices |> Enum.count(&(&1 == num)) |> Kernel.*(num)
end
