defmodule Bowling.Roll do
  defstruct [:number, :value]

  @min 0
  @max 10

  @type t() :: %__MODULE__{number: pos_integer(), value: 0..10}

  @spec new(pos_integer(), integer()) :: {:ok, t()} | {:error, atom()}
  def new(_, value) when value > @max, do: {:error, :value_gt_max}
  def new(_, value) when value < @min, do: {:error, :value_lt_min}
  def new(number, value), do: {:ok, %__MODULE__{number: number, value: value}}
end
