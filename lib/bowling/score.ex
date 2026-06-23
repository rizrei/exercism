defmodule Bowling.Score do
  alias Bowling.Frame

  import Frame, only: [is_rolls_empty: 1]

  defstruct bonus: 0, value: 0

  @type t() :: %__MODULE__{bonus: non_neg_integer(), value: non_neg_integer()}

  @spec increase(t(), Frame.t()) :: {:ok, t()}
  def increase(score, frame) when is_rolls_empty(frame), do: {:ok, score}

  def increase(score, frame) do
    {multiplier, bonus} =
      case score.bonus do
        b when b in [0, 1] -> {b + 1, 0}
        n -> {n, 1}
      end

    %{
      score
      | value: score.value + Frame.last_roll(frame) * multiplier,
        bonus: bonus + frame_bonus(frame)
    }
    |> then(&{:ok, &1})
  end

  def frame_bonus(frame) when frame.status == :strike, do: 2
  def frame_bonus(frame) when frame.status == :spare, do: 1
  def frame_bonus(_), do: 0
end
