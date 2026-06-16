defmodule Bowling do
  defmodule Frame do
    @moduledoc """
    Bowling.Frame struct
    """

    defstruct [:number, rolls: [], closed: false, status: nil]

    @type t() :: %__MODULE__{
            number: pos_integer(),
            rolls: [pos_integer()],
            closed: boolean(),
            status: :open_frame | :strike | :spare | nil
          }

    @spec new(pos_integer()) :: t()
    def new(number), do: %__MODULE__{number: number}

    @spec add_roll(t(), pos_integer()) :: {:ok, t()} | {:error, String.t()}
    def add_roll(%{rolls: [r1]} = frame, r) when r + r1 < 10,
      do: {:ok, %{frame | rolls: [r, r1], closed: true, status: :open_frame}}

    def add_roll(%{rolls: [_, _] = rolls} = frame, r),
      do: {:ok, %{frame | rolls: [r | rolls], closed: true, status: :spare}}

    def add_roll(%{number: n, rolls: [r1]} = frame, r) when n != 10 and r + r1 == 10,
      do: {:ok, %{frame | rolls: [r, r1], closed: true, status: :spare}}

    def add_roll(%{rolls: [10, 10]} = frame, 10),
      do: {:ok, %{frame | rolls: [10, 10, 10], closed: true, status: :strike}}

    def add_roll(%{number: n, rolls: []} = frame, 10) when n != 10,
      do: {:ok, %{frame | rolls: [10], closed: true, status: :strike}}

    def add_roll(%{rolls: rolls} = frame, r), do: {:ok, %{frame | rolls: [r | rolls]}}

    def last?(%{number: number}), do: number == 10
  end

  alias Bowling.Frame

  defstruct frames: []

  @errors %{
    invalid_roll: "Negative roll is invalid",
    invalid_pin_count: "Pin count exceeds pins on the lane",
    game_over: "Cannot roll after game is over"
  }

  @type t() :: %__MODULE__{frames: [Frame.t()]}

  @spec start() :: t()
  def start(), do: %__MODULE__{}

  @spec roll(t(), integer()) :: {:ok, t()} | {:error, String.t()}
  def roll(bowling, roll) do
    with :ok <- validate_game_over(bowling),
         :ok <- validate_roll(roll),
         :ok <- validate_pin_count(bowling, roll),
         frame = build_frame(bowling),
         {:ok, frame} <- Frame.add_roll(frame, roll),
         bowling = update_frames(bowling, frame) do
      {:ok, bowling}
    end
  end

  @spec score(t()) :: {:ok, integer()} | {:error, String.t()}
  def score(%{frames: [%Frame{number: 10, closed: true} | _] = frames}) do
    frames
    |> Enum.map(& &1.rolls)
    |> do_score([], 0)
    |> then(&{:ok, &1})
  end

  def score(%{}), do: {:error, "Score cannot be taken until the end of the game"}

  defp build_frame(%{frames: []}), do: Frame.new(1)
  defp build_frame(%{frames: [%{number: n, closed: true} | _]}), do: Frame.new(n + 1)
  defp build_frame(%{frames: [frame | _]}), do: frame

  defp validate_game_over(%{frames: [%{number: 10, closed: true} | _]}) do
    {:error, @errors.game_over}
  end

  defp validate_game_over(_), do: :ok

  defp validate_roll(roll) when roll < 0, do: {:error, @errors.invalid_roll}
  defp validate_roll(_), do: :ok

  defp validate_pin_count(_, roll) when roll > 10, do: {:error, @errors.invalid_pin_count}

  defp validate_pin_count(%{frames: [%{rolls: [r1]} | _]}, r) when r + r1 > 10 and r1 != 10 do
    {:error, @errors.invalid_pin_count}
  end

  defp validate_pin_count(%{frames: [%{rolls: [r1, 10]} | _]}, r) when r + r1 > 10 and r1 != 10 do
    {:error, @errors.invalid_pin_count}
  end

  defp validate_pin_count(_, _), do: :ok

  defp update_frames(%{frames: [%{number: n} | frames]} = bowling, %{number: n} = frame),
    do: %{bowling | frames: [frame | frames]}

  defp update_frames(%{frames: frames} = bowling, frame),
    do: %{bowling | frames: [frame | frames]}

  defp do_score([], _, score), do: score

  defp do_score([[r3, r2, 10] | t], acc, score),
    do: do_score(t, [10, r2, r3 | acc], score + 10 + r2 + r3)

  defp do_score([[10] | t], [r1, r2 | _] = acc, score),
    do: do_score(t, [10 | acc], score + 10 + r1 + r2)

  defp do_score([[r3, r2, r1] | t], acc, score),
    do: do_score(t, [r1, r2, r3 | acc], score + 10 + r3)

  defp do_score([[r2, r1] | t], [r | _] = acc, score) when r1 + r2 == 10,
    do: do_score(t, [r1, r2 | acc], score + 10 + r)

  defp do_score([[r2, r1] | t], acc, score), do: do_score(t, [r1, r2 | acc], score + r1 + r2)
end
