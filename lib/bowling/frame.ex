defmodule Bowling.Frame do
  alias Bowling.Roll

  @pins 10

  defstruct [:status, bonus: %{}, number: 1, rolls: [], pins: @pins, closed: false]

  @type t() :: %__MODULE__{
          number: pos_integer(),
          pins: 0..10,
          rolls: [Roll.t()],
          closed: boolean(),
          bonus: map()
        }

  defguard strike?(roll) when roll == @pins
  defguard spare?(roll, prev_roll) when roll + prev_roll == @pins
  defguard open?(roll, prev_roll) when roll + prev_roll < @pins
  defguard last?(number) when number == @pins
  defguard first?(number) when number == 1
  defguard valid_pins_count?(pins_count, roll) when roll <= pins_count

  @spec new(number :: pos_integer()) :: t()
  def new(number \\ 1), do: %__MODULE__{number: number}

  @spec add_roll(t(), Roll.t()) :: {:ok, t()} | {:error, atom()}
  def add_roll(%{closed: true}, _), do: {:error, :frame_closed}

  def add_roll(%{pins: pins}, r) when not valid_pins_count?(pins, r.value) do
    {:error, :invalid_pins_count}
  end

  def add_roll(%{rolls: [r1], pins: pins} = f, r) when open?(r.value, r1.value) do
    {:ok, %{f | rolls: [r, r1], pins: pins(pins, r), closed: true}}
  end

  def add_roll(%{rolls: []} = f, r) when strike?(r.value) and not last?(f.number) do
    {:ok, %{f | rolls: [r], pins: pins(f.pins, r), closed: true, bonus: strike_bonus(r)}}
  end

  def add_roll(%{rolls: [r2, _] = rolls} = f, r) when strike?(r.value) and strike?(r2.value) do
    {:ok, %{f | rolls: [r | rolls], pins: pins(f.pins, r), closed: true, bonus: strike_bonus(r)}}
  end

  def add_roll(%{rolls: [r1]} = f, r) when spare?(r.value, r1.value) and not last?(f.number) do
    {:ok, %{f | rolls: [r, r1], pins: pins(f.pins, r), closed: true, bonus: spare_bonus(r)}}
  end

  def add_roll(%{rolls: [_, _] = rolls} = f, r) do
    {:ok, %{f | rolls: [r | rolls], pins: pins(f.pins, r), closed: true, bonus: spare_bonus(r)}}
  end

  def add_roll(%{rolls: [r1]} = f, r) when spare?(r.value, r1.value) and last?(f.number) do
    {:ok, %{f | rolls: [r, r1], pins: @pins}}
  end

  def add_roll(%{rolls: rolls, pins: pins} = f, r) do
    {:ok, %{f | rolls: [r | rolls], pins: pins(pins, r)}}
  end

  def last_roll(%{rolls: []}), do: nil
  def last_roll(%{rolls: [roll | _]}), do: roll

  defp strike_bonus(roll), do: %{(roll.number + 1) => 1, (roll.number + 2) => 1}
  defp spare_bonus(roll), do: %{(roll.number + 1) => 1}

  defp pins(pins, roll) when pins == roll.value, do: @pins
  defp pins(pins, roll), do: pins - roll.value
end
