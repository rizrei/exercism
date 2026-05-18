defmodule GoCounting do
  defmodule Board do
    defstruct [:grid, :max_position]

    def new(string) do
      grid = build_grid(string)
      {max_position, _} = Enum.max_by(grid, fn {position, _} -> position end)

      %__MODULE__{grid: grid, max_position: max_position}
    end

    def territory(%{grid: grid} = board, position) do
      case grid[position] do
        player when player in ["B", "W"] ->
          {:ok, %{owner: :none, territory: []}}

        nil ->
          {:error, "Invalid coordinate"}

        _ ->
          state = %{owner: nil, territory: MapSet.new()}
          %{owner: owner, territory: territory} = territory(board, position, state)
          {:ok, %{owner: owner || :none, territory: MapSet.to_list(territory)}}
      end
    end

    def territories(%{grid: grid} = board) do
      for {position, "_"} <- grid, reduce: %{white: [], black: [], none: []} do
        state ->
          if position in state.white or position in state.black or position in state.none do
            state
          else
            {:ok, %{owner: owner, territory: territory}} = territory(board, position)
            put_in(state[owner], Enum.sort(territory ++ state[owner]))
          end
      end
    end

    defp territory(%{grid: grid} = board, {x, y} = position, state) do
      player = grid[position]

      case player do
        "B" ->
          update_owner(state, player)

        "W" ->
          update_owner(state, player)

        "_" ->
          new_positions =
            for {new_x, new_y} <- [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}],
                %{max_position: {max_x, max_y}} = board,
                new_x in 0..max_x and new_y in 0..max_y,
                not MapSet.member?(state.territory, {new_x, new_y}) do
              {new_x, new_y}
            end

          new_state = %{state | territory: MapSet.put(state.territory, position)}

          Enum.reduce(new_positions, new_state, &Map.merge(&2, territory(board, &1, &2)))
      end
    end

    defp build_grid(string) do
      for {line, y} <- string |> String.split("\n", trim: true) |> Enum.with_index(),
          {value, x} <- line |> String.graphemes() |> Enum.with_index(),
          into: %{},
          do: {{x, y}, value}
    end

    defp update_owner(%{owner: nil} = state, "B"), do: %{state | owner: :black}
    defp update_owner(%{owner: nil} = state, "W"), do: %{state | owner: :white}
    defp update_owner(%{owner: :black} = state, "B"), do: state
    defp update_owner(%{owner: :black} = state, "W"), do: %{state | owner: :none}
    defp update_owner(%{owner: :white} = state, "B"), do: %{state | owner: :none}
    defp update_owner(%{owner: :white} = state, "W"), do: state
    defp update_owner(%{owner: :none} = state, _), do: state
    defp update_owner(state, _), do: state
  end

  @type position() :: {pos_integer(), pos_integer()}
  @type owner() :: %{owner: atom(), territory: [position()]}
  @type territories :: %{white: [position()], black: [position()], none: [position()]}

  @doc """
  Return the owner and territory around a position
  """
  @spec territory(String.t(), position()) :: {:ok, owner()} | {:error, String.t()}
  def territory(board, position) do
    board
    |> Board.new()
    |> Board.territory(position)
  end

  @doc """
  Return all white, black and neutral territories
  """
  @spec territories(String.t()) :: territories()
  def territories(board) do
    board
    |> Board.new()
    |> Board.territories()
  end
end
