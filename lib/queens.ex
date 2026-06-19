defmodule Queens do
  defstruct [:white, :black]

  @type position() :: {0..7, 0..7}
  @type t() :: %Queens{black: position(), white: position()}

  @positions 0..7

  defguardp is_position(point)
            when is_tuple(point) and
                   tuple_size(point) == 2 and
                   elem(point, 0) in @positions and
                   elem(point, 1) in @positions

  defguardp is_valid_queens(w_pos, b_pos)
            when is_position(w_pos) and
                   is_position(b_pos) and
                   w_pos != b_pos

  @doc """
  Creates a new set of Queens
  """

  @spec new(Keyword.t()) :: Queens.t()
  def new(white: w_pos, black: b_pos) when is_valid_queens(w_pos, b_pos),
    do: %Queens{white: w_pos, black: b_pos}

  def new(white: pos) when is_position(pos), do: %Queens{white: pos}
  def new(black: pos) when is_position(pos), do: %Queens{black: pos}
  def new(_), do: raise(ArgumentError)

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%Queens{white: white, black: black}) do
    for x <- @positions do
      for y <- @positions do
        case {x, y} do
          ^black -> "B"
          ^white -> "W"
          _ -> "_"
        end
      end
      |> Enum.join(" ")
    end
    |> Enum.join("\n")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean()
  def can_attack?(%Queens{white: white, black: black}), do: black in possible_positions(white)

  defp possible_positions({px, py}) do
    for x <- @positions,
        y <- @positions,
        x == px or y == py or y == py - px + x or y == py + px - x,
        uniq: true,
        do: {x, y}
  end
end
