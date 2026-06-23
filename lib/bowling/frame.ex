defmodule Bowling.Frame do
  @pins 10
  @last_frame_number 10

  defguard is_last(frame) when frame.number == @last_frame_number
  defguard is_closed(frame) when not is_nil(frame.status)
  defguard is_rolls_empty(frame) when frame.rolls == []

  defstruct [:status, number: 1, rolls: [], pins: @pins]

  @type roll() :: 0..10
  @type t() :: %__MODULE__{
          number: pos_integer(),
          pins: 0..10,
          rolls: [roll()],
          status: :strike | :spare | :open | nil
        }

  @spec new(number :: pos_integer()) :: t()
  def new(number \\ 1), do: %__MODULE__{number: number}

  @spec next(t()) :: t()
  def next(frame), do: %__MODULE__{number: frame.number + 1}

  @spec last_roll(t()) :: roll() | nil
  def last_roll(%{rolls: []}), do: nil
  def last_roll(%{rolls: [roll | _]}), do: roll

  @spec add_roll(t(), roll()) :: {:ok, t()} | {:error, atom()}
  def add_roll(frame, _) when is_closed(frame), do: {:error, :frame_closed}
  def add_roll(frame, roll) when roll > frame.pins, do: {:error, :invalid_pins_count}

  def add_roll(frame, roll) do
    status =
      case rolls = [roll | frame.rolls] do
        [r2, r1] when r1 + r2 < @pins -> :open
        [@pins, _, _] -> :strike
        [_r3, _r2, _r1] -> :spare
        [@pins] when not is_last(frame) -> :strike
        [r2, r1] when not is_last(frame) and r1 + r2 == @pins -> :spare
        _ -> nil
      end

    {:ok, %{frame | rolls: rolls, pins: pins(frame.pins, roll), status: status}}
  end

  defp pins(pins, pins), do: @pins
  defp pins(pins, roll), do: pins - roll
end
