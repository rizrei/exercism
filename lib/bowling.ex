defmodule Bowling do
  alias Bowling.{Frame, Score}

  import Frame, only: [is_active: 1, is_last: 1]

  defguardp is_game_over(frame) when is_last(frame) and not is_active(frame)

  @enforce_keys [:frame, :score]
  defstruct [:frame, :score]

  @opaque t() :: %__MODULE__{frame: Frame.t(), score: Score.t()}

  @errors %{
    negative_roll: "Negative roll is invalid",
    invalid_pins_count: "Pin count exceeds pins on the lane",
    last_frame: "Cannot roll after game is over",
    score_unavailable: "Score cannot be taken until the end of the game"
  }

  @spec start() :: t()
  def start(), do: %__MODULE__{frame: Frame.new(), score: Score.new()}

  @spec score(t()) :: {:ok, integer()} | {:error, String.t()}
  def score(bowling) when is_game_over(bowling.frame), do: {:ok, bowling.score.value}
  def score(_), do: {:error, @errors[:score_unavailable]}

  @spec roll(t(), integer()) :: {:ok, t()} | {:error, String.t()}
  def roll(bowling, roll) do
    with {:ok, frame} <- build_frame(bowling),
         {:ok, frame} <- Frame.add_roll(frame, roll),
         score = Score.increase(bowling.score, frame) do
      {:ok, %{bowling | frame: frame, score: score}}
    else
      {:error, error} -> {:error, @errors[error]}
    end
  end

  @spec build_frame(t()) :: {:ok, Frame.t()} | {:error, Frame.next_errors()}
  defp build_frame(%{frame: frame}) when is_active(frame), do: {:ok, frame}
  defp build_frame(%{frame: frame}), do: Frame.next(frame)
end
