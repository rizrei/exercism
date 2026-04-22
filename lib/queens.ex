defmodule Queens do
  defstruct [:white, :black]

  @type position() :: {0..7, 0..7}
  @type t() :: %Queens{black: position(), white: position()}

  defguardp is_position(point)
            when is_tuple(point) and tuple_size(point) == 2 and
                   elem(point, 0) in 0..7 and
                   elem(point, 1) in 0..7

  @doc """
  Creates a new set of Queens
  """

  @spec new(Keyword.t()) :: Queens.t()
  def new(white: w_position, black: b_position)
      when is_position(w_position) and is_position(b_position) and w_position != b_position do
    %Queens{white: w_position, black: b_position}
  end

  def new(white: pos) when is_position(pos), do: %Queens{white: pos}
  def new(black: pos) when is_position(pos), do: %Queens{black: pos}

  def new(_), do: raise(ArgumentError)

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%Queens{white: white, black: black}) do
    for x <- 0..7 do
      for y <- 0..7 do
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
    for x <- 0..7,
        y <- 0..7,
        x == px or y == py or y == py - px + x or y == py + px - x,
        uniq: true,
        do: {x, y}
  end
end
