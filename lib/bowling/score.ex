defmodule Bowling.Score do
  alias Bowling.Frame

  require Frame

  defstruct bonus: 0, value: 0

  @opaque t() :: %__MODULE__{bonus: non_neg_integer(), value: non_neg_integer()}

  @spec new() :: t()
  def new, do: %__MODULE__{}

  @spec increase(t(), Frame.t()) :: t()
  def increase(score, frame) when Frame.is_empty(frame), do: score

  def increase(score, frame) do
    {multiplier, current_bonus} = multiplier(score)

    %{
      score
      | value: score.value + Frame.last_roll(frame) * multiplier,
        bonus: current_bonus + Frame.bonus(frame)
    }
  end

  defp multiplier(%{bonus: b}) when b in [0, 1], do: {b + 1, 0}
  defp multiplier(%{bonus: b}), do: {b, 1}
end
