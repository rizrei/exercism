defmodule Bowling do
  alias Bowling.{Frame, Roll, Score}

  import Bowling.Frame, only: [last?: 1]

  defstruct [:score, frame: %Frame{}]
  @type t() :: %__MODULE__{frame: Frame.t()}

  @errors %{
    value_lt_min: "Negative roll is invalid",
    value_gt_max: "Pin count exceeds pins on the lane",
    invalid_pins_count: "Pin count exceeds pins on the lane",
    frame_closed: "Cannot roll after game is over",
    invalid_frame_number: "Cannot roll after game is over",
    score_unavailable: "Score cannot be taken until the end of the game"
  }

  @spec start() :: t()
  def start() do
    {:ok, score} = Score.start_link()
    %__MODULE__{score: score}
  end

  @spec roll(t(), integer()) :: {:ok, t()} | {:error, String.t()}
  def roll(bowling, roll) do
    with {:ok, roll} <- build_roll(bowling, roll),
         {:ok, frame} <- build_frame(bowling),
         {:ok, frame} <- Frame.add_roll(frame, roll),
         Score.increase(bowling.score, frame) do
      {:ok, %{bowling | frame: frame}}
    else
      {:error, error} -> {:error, @errors[error]}
    end
  end

  defp build_roll(%{frame: frame}, value) do
    case Frame.last_roll(frame) do
      %Roll{number: number} -> Roll.new(number + 1, value)
      nil -> Roll.new(1, value)
    end
  end

  defp build_frame(%{frame: frame}) when last?(frame.number) and frame.closed,
    do: {:error, :frame_closed}

  defp build_frame(%{frame: frame}) when frame.closed, do: {:ok, Frame.new(frame.number + 1)}
  defp build_frame(%{frame: frame}), do: {:ok, frame}

  @spec score(t()) :: {:ok, integer()} | {:error, String.t()}
  def score(%{score: score, frame: frame}) when last?(frame.number) and frame.closed do
    {:ok, Score.value(score)}
  end

  def score(_), do: {:error, @errors[:score_unavailable]}
end
