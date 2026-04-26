defmodule Change do
  @moduledoc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """
  @spec generate([integer()], integer()) :: {:ok, [integer()]} | {:error, String.t()}
  def generate(_coins, 0), do: {:ok, []}
  def generate(_coins, target) when target < 0, do: {:error, "cannot change"}

  def generate(coins, target) do
    1..target
    |> Enum.reduce(%{0 => []}, &change_for(&1, &2, coins))
    |> Map.get(target)
    |> then(&(&1 && {:ok, &1})) ||
      {:error, "cannot change"}
  end

  defp change_for(target, acc, coins) do
    coins
    |> Enum.filter(&acc[target - &1])
    |> Enum.map(&[&1 | acc[target - &1]])
    |> Enum.min_by(&length/1, fn -> nil end)
    |> then(&Map.put(acc, target, &1))
  end
end
