defmodule StateOfTicTacToe do
  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """

  @errors %{
    both_win: "Impossible board: game should have ended after the game was won",
    x_went_twice: "Wrong turn order: X went twice",
    o_started: "Wrong turn order: O started"
  }

  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    with {:ok, list} <- to_list(board),
         :ok <- validate_win(list),
         :ok <- validate_turn_order(list),
         state <- state(list) do
      {:ok, state}
    end
  end

  defp to_list(board) do
    list =
      board
      |> String.split()
      |> Enum.map(fn row ->
        row
        |> String.graphemes()
        |> Enum.map(fn
          "X" -> :x
          "O" -> :o
          _ -> nil
        end)
      end)

    {:ok, list}
  end

  defp state(list) do
    cond do
      win?(list, :x) or win?(list, :o) -> :win
      draw?(list) -> :draw
      true -> :ongoing
    end
  end

  defp validate_win(list), do: if(both_win?(list), do: {:error, @errors.both_win}, else: :ok)

  defp validate_turn_order(list) do
    frequencies = list |> List.flatten() |> Enum.frequencies()
    x_count = Map.get(frequencies, :x, 0)
    o_count = Map.get(frequencies, :o, 0)

    cond do
      x_count - 1 > o_count -> {:error, @errors.x_went_twice}
      x_count < o_count -> {:error, @errors.o_started}
      true -> :ok
    end
  end

  defp win?([[v, _, _], [v, _, _], [v, _, _]], v) when not is_nil(v), do: true
  defp win?([[_, v, _], [_, v, _], [_, v, _]], v) when not is_nil(v), do: true
  defp win?([[_, _, v], [_, _, v], [_, _, v]], v) when not is_nil(v), do: true
  defp win?([[v, v, v], [_, _, _], [_, _, _]], v) when not is_nil(v), do: true
  defp win?([[_, _, _], [v, v, v], [_, _, _]], v) when not is_nil(v), do: true
  defp win?([[_, _, _], [_, _, _], [v, v, v]], v) when not is_nil(v), do: true
  defp win?([[_, _, v], [_, v, _], [v, _, _]], v) when not is_nil(v), do: true
  defp win?([[v, _, _], [_, v, _], [_, _, v]], v) when not is_nil(v), do: true
  defp win?(_, _), do: false

  defp draw?(list), do: list |> List.flatten() |> Enum.all?(&(&1 != nil))

  defp both_win?(list), do: win?(list, :x) and win?(list, :o)
end
