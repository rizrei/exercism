defmodule SplitSecondStopwatch do
  @doc """
  A stopwatch that can be used to track lap times.
  """

  defmodule Stopwatch do
    @type state() :: :ready | :running | :stopped
    @type t() :: %__MODULE__{
            state: state(),
            lap: Time.t(),
            laps: [Time.t()]
          }
    defstruct state: :ready, lap: ~T[00:00:00], laps: []
  end

  @errors %{
    cannot_start: "cannot start an already running stopwatch",
    cannot_stop: "cannot stop a stopwatch that is not running",
    cannot_reset: "cannot reset a stopwatch that is not stopped",
    cannot_lap: "cannot lap a stopwatch that is not running"
  }

  @spec new() :: Stopwatch.t()
  def new(), do: %Stopwatch{}

  @spec state(Stopwatch.t()) :: Stopwatch.state()
  def state(%Stopwatch{state: state}), do: state

  @spec current_lap(Stopwatch.t()) :: Time.t()
  def current_lap(%Stopwatch{lap: lap}), do: lap

  @spec previous_laps(Stopwatch.t()) :: [Time.t()]
  def previous_laps(%Stopwatch{laps: laps}), do: Enum.reverse(laps)

  @spec advance_time(Stopwatch.t(), Time.t()) :: Stopwatch.t()
  def advance_time(%{state: :stopped} = stopwatch, _), do: stopwatch

  def advance_time(%{lap: lap} = stopwatch, time) do
    %{stopwatch | lap: do_advance_time(lap, time)}
  end

  defp do_advance_time(time, %{hour: h, minute: m, second: s}) do
    Time.shift(time, hour: h, minute: m, second: s)
  end

  @spec total(Stopwatch.t()) :: Time.t()
  def total(%{lap: lap, laps: laps}), do: Enum.reduce(laps, lap, &do_advance_time/2)

  @spec start(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def start(%{state: :running}), do: {:error, @errors[:cannot_start]}
  def start(stopwatch), do: %{stopwatch | state: :running}

  @spec stop(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def stop(%{state: :running} = stopwatch), do: %{stopwatch | state: :stopped}
  def stop(_), do: {:error, @errors[:cannot_stop]}

  @spec lap(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def lap(%{lap: lap, laps: laps, state: :running} = stopwatch) do
    %{stopwatch | lap: ~T[00:00:00], laps: [lap | laps]}
  end

  def lap(_), do: {:error, @errors[:cannot_lap]}

  @spec reset(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def reset(%{state: :stopped}), do: new()
  def reset(_), do: {:error, @errors[:cannot_reset]}
end
