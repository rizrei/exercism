defmodule Bowling do
  defmodule Frame do
    @moduledoc """
    Bowling.Frame struct
    """
    @pins 10

    defstruct number: 1, rolls: [], closed: false

    defguard last?(number) when number == 10
    defguard strike?(roll) when roll == @pins
    defguard spare?(roll, prev_roll) when roll + prev_roll == @pins
    defguard open?(roll, prev_roll) when roll + prev_roll < @pins
    defguard valid_roll?(roll) when roll in 0..@pins

    defguard valid_roll?(roll, prev_roll)
             when valid_roll?(roll) and (roll + prev_roll <= 10 or strike?(prev_roll))

    @type status() :: :strike | :spare | :open

    @type roll() :: non_neg_integer()
    @type t() :: %__MODULE__{
            number: pos_integer(),
            rolls: [roll()],
            closed: boolean()
          }

    @spec new() :: t()
    def new(), do: %__MODULE__{}

    @spec new(pos_integer()) :: t()
    def new(number), do: %__MODULE__{number: number}

    @spec add_roll(t(), roll()) :: t()
    def add_roll(%{closed: true} = frame, _), do: frame

    def add_roll(%{rolls: [r1]} = frame, r) when open?(r, r1),
      do: %{frame | rolls: [r, r1], closed: true}

    def add_roll(%{rolls: [_, _] = rolls} = frame, r),
      do: %{frame | rolls: [r | rolls], closed: true}

    def add_roll(%{number: n, rolls: [r1]} = frame, r) when spare?(r, r1) and not last?(n),
      do: %{frame | rolls: [r, r1], closed: true}

    def add_roll(%{number: n, rolls: []} = frame, r) when strike?(r) and not last?(n),
      do: %{frame | rolls: [@pins], closed: true}

    def add_roll(%{rolls: rolls} = frame, r), do: %{frame | rolls: [r | rolls]}

    @spec status(t()) :: status() | nil
    def status(%{rolls: [r2, r1]}) when open?(r2, r1), do: :open
    def status(%{rolls: [r3, _, _]}) when strike?(r3), do: :strike
    def status(%{rolls: [r]}) when strike?(r), do: :strike
    def status(%{rolls: [_, _, _]}), do: :spare
    def status(%{rolls: [_, _]}), do: :spare
    def status(_), do: nil

    @spec score(t(), next_rolls :: [roll()]) :: non_neg_integer()
    def score(%{number: n, rolls: rolls}, _) when last?(n), do: Enum.sum(rolls)

    def score(%{rolls: rolls} = frame, [r1, r2 | _]) do
      case status(frame) do
        :strike -> Enum.sum([r2, r1 | rolls])
        :spare -> Enum.sum([r1 | rolls])
        :open -> Enum.sum(rolls)
      end
    end
  end

  defmodule Validator do
    import Bowling.Frame

    @spec validate_roll(Bowling.t(), Bowling.Frame.roll()) :: :ok | {:error, atom()}
    def validate_roll(bowling, roll) do
      with :ok <- validate_roll(roll),
           :ok <- validate_game_over(bowling),
           :ok <- validate_pin_count(bowling, roll) do
        :ok
      end
    end

    defp validate_game_over(%{frames: [frame | _]}) when last?(frame.number) and frame.closed,
      do: {:error, :game_over}

    defp validate_game_over(_), do: :ok

    defp validate_roll(roll) when roll < 0, do: {:error, :negative_roll}
    defp validate_roll(roll) when roll > 10, do: {:error, :invalid_pin_count}
    defp validate_roll(_), do: :ok

    defp validate_pin_count(%{frames: [%{rolls: [r1]} | _]}, r) when not valid_roll?(r, r1) do
      {:error, :invalid_pin_count}
    end

    defp validate_pin_count(%{frames: [%{rolls: [r1, 10]} | _]}, r) when not valid_roll?(r, r1) do
      {:error, :invalid_pin_count}
    end

    defp validate_pin_count(_, _), do: :ok
  end

  defmodule Score do
    import Bowling.Frame, only: [last?: 1]

    @spec calculate(Bowling.t()) :: {:ok, non_neg_integer()} | {:error, :score_unavailable}
    def calculate(bowling) do
      with :ok <- validate(bowling),
           score = do_score(bowling.frames, [], 0) do
        {:ok, score}
      end
    end

    defp validate(%{frames: [frame | _]}) when last?(frame.number) and frame.closed, do: :ok
    defp validate(_), do: {:error, :score_unavailable}

    defp do_score([], _rolls, score), do: score

    defp do_score([frame | frames], rolls, score) do
      do_score(frames, Enum.reverse(frame.rolls) ++ rolls, score + Frame.score(frame, rolls))
    end
  end

  defstruct frames: []

  @errors %{
    negative_roll: "Negative roll is invalid",
    invalid_pin_count: "Pin count exceeds pins on the lane",
    game_over: "Cannot roll after game is over",
    score_unavailable: "Score cannot be taken until the end of the game"
  }

  @type t() :: %__MODULE__{frames: [Frame.t()]}

  @spec start() :: t()
  def start(), do: %__MODULE__{frames: [Frame.new()]}

  @spec roll(t(), integer()) :: {:ok, t()} | {:error, String.t()}
  def roll(bowling, roll) do
    with :ok <- Validator.validate_roll(bowling, roll),
         frame = bowling |> build_frame() |> Frame.add_roll(roll),
         bowling = update_bowling(bowling, frame) do
      {:ok, bowling}
    else
      {:error, error} -> {:error, @errors[error]}
    end
  end

  @spec score(t()) :: {:ok, integer()} | {:error, String.t()}
  def score(bowling) do
    case Score.calculate(bowling) do
      {:ok, score} -> {:ok, score}
      {:error, error} -> {:error, @errors[error]}
    end
  end

  defp build_frame(%{frames: [%{number: n, closed: true} | _]}), do: Frame.new(n + 1)
  defp build_frame(%{frames: [frame | _]}), do: frame

  defp update_bowling(bowling, frame) do
    bowling
    |> update_bowling_frames(frame)
  end

  defp update_bowling_frames(%{frames: [%{number: n} | frames]} = bowling, %{number: n} = frame),
    do: %{bowling | frames: [frame | frames]}

  defp update_bowling_frames(%{frames: frames} = bowling, frame),
    do: %{bowling | frames: [frame | frames]}
end
