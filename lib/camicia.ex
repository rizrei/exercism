defmodule Camicia do
  defmodule State do
    defstruct [
      :p1,
      :p2,
      current_player: 0,
      pile: [],
      cards: 0,
      tricks: 0,
      penalty: nil,
      visited: %{}
    ]

    @cards ~w(J Q K A) |> Enum.with_index(1) |> Map.new()

    @spec new([String.t()], [String.t()]) :: %__MODULE__{}
    def new(player_a, player_b) do
      %__MODULE__{
        p1: build_deck(player_a),
        p2: build_deck(player_b),
        current_player: 0,
        pile: [],
        cards: 0,
        tricks: 0,
        penalty: nil,
        visited: %{}
      }
    end

    @spec set_p1(%__MODULE__{}, [integer()]) :: %__MODULE__{}
    def set_p1(state, p1), do: %{state | p1: p1}

    @spec set_p2(%__MODULE__{}, [integer()]) :: %__MODULE__{}
    def set_p2(state, p2), do: %{state | p2: p2}

    @spec push_pile(%__MODULE__{}, integer() | nil) :: %__MODULE__{}
    def push_pile(state, card), do: %{state | pile: [card | state.pile]}

    @spec clear_pile(%__MODULE__{}) :: %__MODULE__{}
    def clear_pile(state), do: %{state | pile: []}

    @spec inc_cards(%__MODULE__{}) :: %__MODULE__{}
    def inc_cards(%{cards: cards} = state), do: %{state | cards: cards + 1}

    @spec inc_tricks(%__MODULE__{}) :: %__MODULE__{}
    def inc_tricks(%{tricks: tricks} = state), do: %{state | tricks: tricks + 1}

    @spec switch_current_player(%__MODULE__{}) :: %__MODULE__{}
    def switch_current_player(%{current_player: current_player} = state),
      do: %{state | current_player: 1 - current_player}

    @spec decr_penalty(%__MODULE__{}) :: %__MODULE__{}
    def decr_penalty(%{penalty: penalty} = state), do: %{state | penalty: penalty - 1}

    @spec clear_penalty(%__MODULE__{}) :: %__MODULE__{}
    def clear_penalty(state), do: %{state | penalty: nil}

    @spec set_penalty(%__MODULE__{}, integer() | nil) :: %__MODULE__{}
    def set_penalty(state, penalty), do: %{state | penalty: penalty}

    @spec update_visited(%__MODULE__{}) :: %__MODULE__{}
    def update_visited(%{pile: []} = state) do
      %{state | visited: Map.put(state.visited, {state.p1, state.p2, state.current_player}, true)}
    end

    def update_visited(state), do: state

    defp build_deck(cards), do: Enum.map(cards, &Map.get(@cards, &1))
  end

  @doc """
    Simulate a card game between two players.
    Each player has a deck of cards represented as a list of strings.
    Returns a tuple with the result of the game:
    - `{:finished, cards, tricks}` if the game finishes with a winner
    - `{:loop, cards, tricks}` if the game enters a loop
    `cards` is the number of cards played.
    `tricks` is the number of central piles collected.

    ## Examples

      iex> Camicia.simulate(["2"], ["3"])
      {:finished, 2, 1}

      iex> Camicia.simulate(["J", "2", "3"], ["4", "J", "5"])
      {:loop, 8, 3}F
  """

  @type tricks :: non_neg_integer()
  @type cards :: non_neg_integer()

  @spec simulate([String.t()], [String.t()]) :: {:finished | :loop, cards(), tricks()}
  def simulate(player_a, player_b), do: State.new(player_a, player_b) |> simulate()

  defp simulate(%{p2: [], pile: [], penalty: nil} = state) do
    {:finished, state.cards, state.tricks}
  end

  defp simulate(%{p1: p1, p2: p2, visited: visited, current_player: current_player} = state)
       when is_map_key(visited, {p1, p2, current_player}) do
    {:loop, state.cards, state.tricks}
  end

  # If a player runs out of cards and is unable to play a card (either while paying a penalty or when it is their turn),
  # the other player collects the central pile.
  defp simulate(%{p1: []} = state) do
    state
    |> State.set_p1(state.p2 ++ Enum.reverse(state.pile))
    |> State.set_p2([])
    |> State.switch_current_player()
    |> State.clear_pile()
    |> State.clear_penalty()
    |> State.inc_tricks()
    |> simulate()
  end

  # If the penalty is fully paid without interruption, the player who placed the last payment card collects the central pile
  # and places it at the bottom of their deck. That player then starts the next round.
  defp simulate(%{penalty: 0} = state) do
    state
    |> State.set_p1(state.p2 ++ Enum.reverse(state.pile))
    |> State.set_p2(state.p1)
    |> State.switch_current_player()
    |> State.clear_pile()
    |> State.clear_penalty()
    |> State.inc_tricks()
    |> simulate()
  end

  # If the player paying a penalty does not reveal a payment card, they keep playing.
  defp simulate(%{p1: [nil | t], penalty: penalty} = state) when penalty != nil do
    state
    |> State.update_visited()
    |> State.set_p1(t)
    |> State.push_pile(nil)
    |> State.inc_cards()
    |> State.decr_penalty()
    |> simulate()
  end

  # If there is no ongoing penalty or if the player paying a penalty reveals a payment card, the other player has to play.
  defp simulate(%{p1: [h | t], p2: p2} = state) do
    state
    |> State.update_visited()
    |> State.set_p1(p2)
    |> State.set_p2(t)
    |> State.push_pile(h)
    |> State.inc_cards()
    |> State.switch_current_player()
    |> State.set_penalty(h)
    |> simulate()
  end
end
