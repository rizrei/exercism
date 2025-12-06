defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  defmodule Frame do
    defstruct number: nil, rolls: [], closed: false, status: nil

    def add_roll(_, r) when r < 0, do: {:error, "Negative roll is invalid"}
    def add_roll(_, r) when r > 10, do: {:error, "Pin count exceeds pins on the lane"}
    def add_roll(%Frame{closed: true}, _), do: {:error, "Frame already closed"}

    def add_roll(%Frame{rolls: [r1]}, r) when r1 != 10 and r1 + r > 10,
      do: {:error, "Pin count exceeds pins on the lane"}

    def add_roll(%Frame{rolls: [r2, 10]}, r) when r2 != 10 and r2 + r > 10,
      do: {:error, "Pin count exceeds pins on the lane"}

    def add_roll(%Frame{rolls: [r1]} = frame, r) when r + r1 < 10,
      do: {:ok, %{frame | rolls: [r, r1], closed: true, status: :open_frame}}

    def add_roll(%Frame{number: n, rolls: []} = frame, 10) when n != 10,
      do: {:ok, %{frame | rolls: [10], closed: true, status: :strike}}

    def add_roll(%Frame{rolls: [10, 10]} = frame, 10),
      do: {:ok, %{frame | rolls: [10, 10, 10], closed: true, status: :strike}}

    def add_roll(%Frame{number: n, rolls: [r1]} = frame, r) when n != 10,
      do: {:ok, %{frame | rolls: [r, r1], closed: true, status: :spare}}

    def add_roll(%Frame{rolls: [_, _] = rolls} = frame, r),
      do: {:ok, %{frame | rolls: [r | rolls], closed: true, status: :spare}}

    def add_roll(%Frame{rolls: rolls} = frame, r), do: {:ok, %{frame | rolls: [r | rolls]}}
  end

  defmodule Game do
    defstruct frames: []

    alias Bowling.Frame

    def roll(%Game{frames: [%Frame{number: 10, closed: true} | _]}, _),
      do: {:error, "Cannot roll after game is over"}

    def roll(%Game{frames: []} = game, roll) do
      with frame <- %Frame{number: 1},
           {:ok, frame} <- Frame.add_roll(frame, roll) do
        {:ok, %Game{game | frames: [frame]}}
      end
    end

    def roll(%Game{frames: [%Frame{number: n, closed: true} | _] = frames} = game, roll) do
      with frame <- %Frame{number: n + 1},
           {:ok, frame} <- Frame.add_roll(frame, roll) do
        {:ok, %Game{game | frames: [frame | frames]}}
      end
    end

    def roll(%Game{frames: [frame | tail_frames]} = game, roll) do
      with {:ok, frame} <- Frame.add_roll(frame, roll) do
        {:ok, %Game{game | frames: [frame | tail_frames]}}
      end
    end

    def score(%Game{frames: [%Frame{number: 10, closed: true} | _] = frames}) do
      frames
      |> Enum.reverse()
      |> frames_score(0)
    end

    def score(%Game{}), do: {:error, "Score cannot be taken until the end of the game"}

    defp frames_score([%{rolls: rolls}], score), do: {:ok, score + Enum.sum(rolls)}

    defp frames_score([%{rolls: rolls, status: :open_frame} | t_frames], score) do
      score = score + Enum.sum(rolls)
      frames_score(t_frames, score)
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

  @spec start() :: any
  def start, do: %Game{}

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """

  @spec roll(any, integer) :: {:ok, any} | {:error, String.t()}
  def roll(game, roll), do: Bowling.Game.roll(game, roll)

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful error tuple.
  """

  @spec score(any) :: {:ok, integer} | {:error, String.t()}
  def score(game), do: Bowling.Game.score(game)
end
