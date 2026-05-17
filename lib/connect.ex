defmodule Connect do
  defmodule Game do
    @type position() :: {non_neg_integer(), non_neg_integer()}
    @type player() :: String.t()
    @type player_position() :: {position(), player()}
    @type t() :: %__MODULE__{
            max_position: position(),
            board: %{position() => player()}
          }
    defstruct [:board, :max_position]

    @spec new([String.t()]) :: t()
    def new(rows) do
      board = build_board(rows)
      {max_position, _} = Enum.max_by(board, fn {position, _} -> position end)

      %__MODULE__{board: board, max_position: max_position}
    end

    @spec player_start_positions(t(), player()) :: [player_position()]
    def player_start_positions(%{board: board}, "O") do
      for {{0, _}, "O"} = player_position <- board, do: player_position
    end

    def player_start_positions(%{board: board}, "X") do
      for {{_, 0}, "X"} = player_position <- board, do: player_position
    end

    @spec win?(t(), player_position()) :: boolean()
    def win?(%{max_position: {max_x, _}}, {{max_x, _}, "O"}), do: true
    def win?(%{max_position: {_, max_y}}, {{_, max_y}, "X"}), do: true
    def win?(_, _), do: false

    @spec neighbors(t(), player_position()) :: [player_position()]
    def neighbors(%{board: board}, {{x, y}, player}) do
      positions = [
        {x - 1, y},
        {x - 1, y + 1},
        {x, y - 1},
        {x, y + 1},
        {x + 1, y - 1},
        {x + 1, y}
      ]

      for position <- positions, Map.get(board, position) == player, do: {position, player}
    end

    defp build_board(rows) do
      for {row, x} <- Enum.with_index(rows),
          {value, y} <- row |> String.graphemes() |> Enum.with_index(),
          into: %{} do
        {{x, y}, value}
      end
    end
  end

  @doc """
  Calculates the winner (if any) of a board
  """
  @spec result_for([String.t()]) :: :none | :X | :O
  def result_for(rows) do
    game = Game.new(rows)

    cond do
      game |> Game.player_start_positions("X") |> connect?(game) -> :X
      game |> Game.player_start_positions("O") |> connect?(game) -> :O
      true -> :none
    end
  end

  defp connect?(player_positions, game, visited \\ MapSet.new())
  defp connect?([], _, _), do: false

  defp connect?(player_positions, game, visited) do
    Enum.find_value(player_positions, fn player_position ->
      if Game.win?(game, player_position) do
        true
      else
        new_visited = Enum.reduce(player_positions, visited, &MapSet.put(&2, &1))

        game
        |> Game.neighbors(player_position)
        |> Enum.reject(&MapSet.member?(visited, &1))
        |> connect?(game, new_visited)
      end
    end)
  end
end
