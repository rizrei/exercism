defmodule Bowling do
  defmodule Frame do
    @moduledoc """
    Bowling.Frame struct
    """

    defstruct number: nil, rolls: [], closed: false, status: nil

    @type t() :: %__MODULE__{
            number: pos_integer() | nil,
            rolls: list(pos_integer()),
            closed: boolean(),
            status: :open_frame | :strike | :spare | nil
          }

    @errors %{
      negative_roll: "Negative roll is invalid",
      invalid_pin_count: "Pin count exceeds pins on the lane",
      closed_frame: "Frame already closed"
    }

    defguardp last_frame?(n) when n == 10
    defguardp strike?(roll) when roll == 10
    defguardp invalid_roll?(roll, prev_roll) when not strike?(prev_roll) and roll + prev_roll > 10

    @spec add_roll(t(), pos_integer()) :: {:ok, t()} | {:error, String.t()}
    def add_roll(_, r) when r < 0, do: {:error, @errors.negative_roll}
    def add_roll(_, r) when r > 10, do: {:error, @errors.invalid_pin_count}
    def add_roll(%{closed: true}, _), do: {:error, @errors.closed_frame}

    def add_roll(%{rolls: [prev_roll]}, roll) when invalid_roll?(roll, prev_roll),
      do: {:error, @errors.invalid_pin_count}

    def add_roll(%{rolls: [prev_roll, 10]}, roll) when invalid_roll?(roll, prev_roll),
      do: {:error, @errors.invalid_pin_count}

    def add_roll(%{rolls: [r1]} = frame, r) when r + r1 < 10,
      do: {:ok, %{frame | rolls: [r, r1], closed: true, status: :open_frame}}

    def add_roll(%{number: n, rolls: []} = frame, 10) when not last_frame?(n),
      do: {:ok, %{frame | rolls: [10], closed: true, status: :strike}}

    def add_roll(%{rolls: [10, 10]} = frame, 10),
      do: {:ok, %{frame | rolls: [10, 10, 10], closed: true, status: :strike}}

    def add_roll(%{number: n, rolls: [r1]} = frame, r) when not last_frame?(n),
      do: {:ok, %{frame | rolls: [r, r1], closed: true, status: :spare}}

    def add_roll(%{rolls: [_, _] = rolls} = frame, r),
      do: {:ok, %{frame | rolls: [r | rolls], closed: true, status: :spare}}

    def add_roll(%{rolls: rolls} = frame, r), do: {:ok, %{frame | rolls: [r | rolls]}}
  end

  defmodule Game do
    @moduledoc """
    Bowling.Frame struct
    """
    alias Bowling.Frame

    defstruct frames: []

    @type t() :: %__MODULE__{frames: [Frame.t()]}

    @spec roll(t(), integer()) :: {:ok, t()} | {:error, String.t()}
    def roll(%Game{frames: [%Frame{number: 10, closed: true} | _]}, _),
      do: {:error, "Cannot roll after game is over"}

    def roll(%Game{frames: []} = game, roll) do
      case Frame.add_roll(%Frame{number: 1}, roll) do
        {:ok, frame} -> {:ok, %Game{game | frames: [frame]}}
        error -> error
      end
    end

    def roll(%Game{frames: [%Frame{number: n, closed: true} | _] = frames} = game, roll) do
      case Frame.add_roll(%Frame{number: n + 1}, roll) do
        {:ok, frame} -> {:ok, %Game{game | frames: [frame | frames]}}
        error -> error
      end
    end

    def roll(%Game{frames: [frame | frames]} = game, roll) do
      case Frame.add_roll(frame, roll) do
        {:ok, frame} -> {:ok, %Game{game | frames: [frame | frames]}}
        error -> error
      end
    end

    @spec score(t()) :: {:ok, integer()} | {:error, String.t()}
    def score(%Game{frames: [%Frame{number: 10, closed: true} | _] = frames}) do
      frames
      |> Enum.reverse()
      |> frames_score(0)
    end

    def score(%Game{}), do: {:error, "Score cannot be taken until the end of the game"}

    defp frames_score([%{rolls: rolls}], score), do: {:ok, score + Enum.sum(rolls)}

    defp frames_score([%{rolls: rolls, status: :open_frame} | t_frames], score) do
      frames_score(t_frames, Enum.sum(rolls) + score)
    end

    defp frames_score([%{status: :strike} | t_frames], score) do
      score =
        t_frames
        |> Stream.flat_map(&Enum.reverse(&1.rolls))
        |> Enum.take(2)
        |> Enum.sum()
        |> Kernel.+(10)
        |> Kernel.+(score)

      frames_score(t_frames, score)
    end

    defp frames_score([%{rolls: rolls, status: :spare} | [%{rolls: n_rolls} | _] = t], score) do
      score =
        n_rolls
        |> Enum.take(-1)
        |> Kernel.++(rolls)
        |> Enum.sum()
        |> Kernel.+(score)

      frames_score(t, score)
    end
  end

  @moduledoc """
  Bowling GenServer
  """

  @spec start() :: Game.t()
  def start(), do: %Game{}

  @spec score(Game.t()) :: {:ok, integer()} | {:error, String.t()}
  def score(game), do: Game.score(game)

  @spec roll(Game.t(), integer()) :: {:ok, Game.t()} | {:error, String.t()}
  def roll(game, roll), do: Game.roll(game, roll)
end
