defmodule Bowling.Score do
  use Agent

  alias Bowling.{Score, Frame}

  defstruct bonuses: %{}, value: 0

  @typep multiplier() :: pos_integer()
  @typep roll_number() :: pos_integer()
  @typep bonuses() :: %{roll_number() => multiplier()}
  @type t() :: %__MODULE__{bonuses: bonuses(), value: non_neg_integer()}

  @spec start_link(Score.t()) :: Agent.on_start()
  def start_link(state \\ %Score{}), do: Agent.start_link(fn -> state end)

  @spec value(pid()) :: non_neg_integer()
  def value(score), do: Agent.get(score, & &1.value)

  @spec increase(pid(), Frame.t()) :: :ok
  def increase(score, frame), do: Agent.update(score, &do_increase(&1, frame))

  defp do_increase(%{value: value} = score, frame) when is_nil(frame.bonus) do
    %{score | value: value + Frame.last_roll(frame).value}
  end

  defp do_increase(%{value: value, bonuses: bonuses} = score, frame) do
    roll = Frame.last_roll(frame)

    %{
      score
      | bonuses: Map.merge(frame.bonus, bonuses, fn _k, v1, v2 -> v1 + v2 end),
        value: value + roll.value + roll.value * Map.get(bonuses, roll.number, 0)
    }
  end
end
