defmodule HighScore do
  @default_score 0

  @spec new :: %{}
  def new(), do: %{}

  @spec add_player(map, binary, integer) :: map
  def add_player(scores, name, score \\ @default_score) do
    scores |> Map.put(name, score)
  end

  @spec remove_player(map, binary) :: map
  def remove_player(scores, name), do: scores |> Map.delete(name)

  @spec reset_score(map, binary) :: map
  def reset_score(scores, name), do: scores |> add_player(name)

  @spec update_score(map, binary, integer) :: map
  def update_score(scores, name, score) do
    scores |> Map.update(name, score, &(&1 + score))
  end

  @spec get_players(map) :: list
  def get_players(scores), do: scores |> Map.keys()
end
