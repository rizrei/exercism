defmodule Bowling.Frame do
  alias __MODULE__.Status

  import Status

  @pins 10
  @last_number 10

  defguard is_empty(frame) when frame.rolls == []
  defguard is_last(frame) when frame.number == @last_number
  defguard is_active(frame) when is_nil(frame.status)
  defguardp is_strike(roll) when roll == @pins
  defguardp is_spare(roll, prev_roll) when roll + prev_roll == @pins
  defguardp is_open(roll, prev_roll) when roll + prev_roll < @pins

  @enforce_keys [:number]
  defstruct [:status, :number, rolls: [], pins: @pins]

  @typep roll() :: 0..10
  @opaque t() :: %__MODULE__{
            number: pos_integer(),
            pins: 0..10,
            rolls: [roll()],
            status: Status.t() | nil
          }

  @spec new(number :: pos_integer()) :: t()
  def new(number \\ 1), do: %__MODULE__{number: number}

  @type next_errors() :: :active_frame | :last_frame
  @spec next(t()) :: {:ok, t()} | {:error, next_errors()}
  def next(frame) when is_active(frame), do: {:error, :active_frame}
  def next(frame) when is_last(frame), do: {:error, :last_frame}
  def next(%{number: number}), do: {:ok, new(number + 1)}

  @spec last_roll(t()) :: roll() | nil
  def last_roll(%{rolls: []}), do: nil
  def last_roll(%{rolls: [roll | _]}), do: roll

  @spec bonus(t()) :: Status.bonus()
  def bonus(frame) when is_active(frame), do: 0
  def bonus(frame), do: frame.status.bonus

  @type add_roll_errors() :: :negative_roll | :inactive_frame | :invalid_pins_count
  @spec add_roll(t(), roll()) :: {:ok, t()} | {:error, :add_roll_errors}
  def add_roll(_, roll) when roll < 0, do: {:error, :negative_roll}
  def add_roll(frame, _) when not is_active(frame), do: {:error, :inactive_frame}
  def add_roll(frame, roll) when roll > frame.pins, do: {:error, :invalid_pins_count}

  def add_roll(%{pins: pins, rolls: rolls} = frame, roll) do
    status =
      case rolls = [roll | rolls] do
        [r2, r1] when is_open(r2, r1) -> open()
        [r3, _, _] when is_strike(r3) -> strike()
        [r3, _r2, _r1] when not is_strike(r3) -> spare()
        [r] when is_strike(r) and not is_last(frame) -> strike()
        [r2, r1] when is_spare(r2, r1) and not is_last(frame) -> spare()
        _ -> nil
      end

    {:ok, %{frame | rolls: rolls, pins: pins(pins, roll), status: status}}
  end

  defp pins(pins, pins), do: @pins
  defp pins(pins, roll), do: pins - roll
end
