defmodule ETL do
  @doc """
  Transforms an old Scrabble score system to a new one.

  ## Examples

    iex> ETL.transform(%{1 => ["A", "E"], 2 => ["D", "G"]})
    %{"a" => 1, "d" => 2, "e" => 1, "g" => 2}
  """
  @spec transform(map) :: map
  # def transform(input) do
  #   for {score, letters} <- input, reduce: %{} do
  #     acc ->
  #       letters
  #       |> Enum.map(&String.downcase/1)
  #       |> Enum.into(%{}, fn letter -> {letter, score} end)
  #       |> Map.merge(acc)
  #   end
  # end

  def transform(input) do
    for {key, values} <- input, value <- values, into: %{}, do: {String.downcase(value), key}
  end
end
