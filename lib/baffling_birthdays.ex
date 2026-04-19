defmodule BafflingBirthdays do
  @moduledoc """
  Estimate the probability of shared birthdays in a group of people.
  """

  @spec shared_birthday?([Date.t()]) :: boolean()
  def shared_birthday?(birthdates) do
    birthdates |> Enum.reduce_while(%{}, &reducer/2) |> is_boolean()
  end

  @spec random_birthdates(integer()) :: [Date.t()]
  def random_birthdates(group_size), do: Stream.repeatedly(&rand_date/0) |> Enum.take(group_size)

  @spec estimated_probability_of_shared_birthday(integer()) :: float()
  def estimated_probability_of_shared_birthday(group_size) do
    (1 - Enum.reduce(0..(group_size - 1), 1.0, &(&2 * (365 - &1) / 365))) * 100
  end

  defp rand_date(), do: Date.add(Date.utc_today(), :rand.uniform(365) - 1)

  defp reducer(%{day: d, month: m}, acc) when is_map_key(acc, {m, d}), do: {:halt, true}
  defp reducer(%{day: d, month: m}, acc), do: {:cont, Map.put(acc, {m, d}, 1)}
end
