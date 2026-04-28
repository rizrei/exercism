# credo:disable-for-this-file

defmodule HighScore do
  @default_score 0

  @type name() :: String.t()
  @type score() :: integer()
  @type scores() :: %{name() => score()}

  @spec new :: %{}
  def new(), do: %{}

  @spec add_player(scores(), name(), score()) :: scores()
  def add_player(scores, name, score \\ @default_score), do: Map.put(scores, name, score)

  @spec remove_player(scores(), String.t()) :: scores()
  def remove_player(scores, name), do: Map.delete(scores, name)

  @spec reset_score(scores(), String.t()) :: scores()
  def reset_score(scores, name), do: add_player(scores, name)

  @spec update_score(scores(), String.t(), score()) :: scores()
  def update_score(scores, name, score), do: Map.update(scores, name, score, &(&1 + score))

  @spec get_players(scores()) :: [score()]
  def get_players(scores), do: Map.keys(scores)
end
