defmodule Bowling do
  alias Bowling.{Frame, Score}

  import Bowling.Frame, only: [is_last: 1, is_closed: 1]

  defguardp is_game_over(frame) when is_last(frame) and is_closed(frame)

  defstruct frame: %Frame{}, score: %Score{}
  @type t() :: %__MODULE__{frame: Frame.t(), score: %Score{}}

  @min_roll 0
  @max_roll 10
  @errors %{
    value_lt_min: "Negative roll is invalid",
    value_gt_max: "Pin count exceeds pins on the lane",
    invalid_pins_count: "Pin count exceeds pins on the lane",
    game_over: "Cannot roll after game is over",
    score_unavailable: "Score cannot be taken until the end of the game"
  }

  @spec start() :: t()
  def start(), do: %__MODULE__{}

  @spec score(t()) :: {:ok, integer()} | {:error, String.t()}
  def score(%{score: score, frame: frame}) when is_game_over(frame), do: {:ok, score.value}
  def score(_), do: {:error, @errors[:score_unavailable]}

  @spec roll(t(), integer()) :: {:ok, t()} | {:error, String.t()}
  def roll(bowling, roll) do
    with {:ok, frame} <- build_frame(bowling),
         {:ok, roll} <- validate_roll(roll),
         {:ok, frame} <- Frame.add_roll(frame, roll),
         {:ok, score} <- Score.increase(bowling.score, frame) do
      {:ok, %{bowling | frame: frame, score: score}}
    else
      {:error, error} -> {:error, @errors[error]}
    end
  end

  defp validate_roll(roll) when roll > @max_roll, do: {:error, :value_gt_max}
  defp validate_roll(roll) when roll < @min_roll, do: {:error, :value_lt_min}
  defp validate_roll(roll), do: {:ok, roll}

  defp build_frame(%{frame: frame}) when is_game_over(frame), do: {:error, :game_over}
  defp build_frame(%{frame: frame}) when is_closed(frame), do: {:ok, Frame.next(frame)}
  defp build_frame(%{frame: frame}), do: {:ok, frame}
end
