defmodule Poker do
  defmodule Card do
    @regex ~r/^(?<rank>[2-9]|10|[JQKA])(?<suit>[CDHS])$/
    @suits ~w(C D H S)
    @ranks ~w(2 3 4 5 6 7 8 9 10 J Q K A)
           |> Enum.with_index(&{&1, &2})
           |> Enum.into(%{})

    defstruct [:rank, :suit]

    @type rank() :: String.t()
    @type suit() :: String.t()
    @type t() :: %__MODULE__{rank: rank(), suit: suit()}

    @spec new(String.t() | tuple()) :: t() | {:error, String.t()}
    def new(card) when is_binary(card) do
      case Regex.named_captures(@regex, card) do
        %{"rank" => rank, "suit" => suit} -> %__MODULE__{rank: rank, suit: suit}
        _ -> {:error, "Invalid card format"}
      end
    end

    def new({rank, suit}) when is_map_key(@ranks, rank) and suit in @suits,
      do: %__MODULE__{rank: rank, suit: suit}

    @spec to_tuple(t()) :: {rank(), suit()}
    def to_tuple(%__MODULE__{rank: rank, suit: suit}), do: {rank, suit}

    @spec compare(t(), t()) :: :lt | :gt | :eq
    def compare(%__MODULE__{rank: rank1}, %__MODULE__{rank: rank2}) do
      v1 = Map.fetch!(@ranks, rank1)
      v2 = Map.fetch!(@ranks, rank2)

      cond do
        v1 < v2 -> :lt
        v1 > v2 -> :gt
        true -> :eq
      end
    end
  end

  defmodule Hand do
    alias Poker.Card

    defstruct [:origin, :rank, cards: []]

    @type t() :: %__MODULE__{
            origin: [String.t()],
            cards: [Card.t()],
            rank: {atom(), [Card.t()]}
          }

    @ranks [
             :high_card,
             :one_pair,
             :two_pair,
             :three_of_a_kind,
             :straight,
             :flush,
             :full_house,
             :four_of_a_kind,
             :straight_flush,
             :royal_flush
           ]
           |> Enum.with_index(&{&1, &2})
           |> Enum.into(%{})

    @spec new([String.t()]) :: t()
    def new(list) do
      cards = cards(list)

      rank =
        cards
        |> Enum.map(&Card.to_tuple/1)
        |> rank()
        |> then(fn {rank, cards} -> {rank, Enum.map(cards, &Card.new/1)} end)

      %__MODULE__{
        origin: list,
        cards: cards,
        rank: rank
      }
    end

    @spec compare(t(), t()) :: :lt | :gt | :eq
    def compare(%__MODULE__{rank: {rank1, cards1}}, %__MODULE__{rank: {rank2, cards2}}) do
      v1 = Map.fetch!(@ranks, rank1)
      v2 = Map.fetch!(@ranks, rank2)

      cond do
        v1 < v2 -> :lt
        v1 > v2 -> :gt
        true -> do_compare(cards1, cards2)
      end
    end

    defp cards(list), do: list |> Enum.map(&Card.new/1) |> Enum.sort({:desc, Card})

    defp rank([{"A", s}, {"K", s}, {"Q", s}, {"J", s}, {"10", s}]), do: {:royal_flush, []}

    defp rank([{"K", s} = c, {"Q", s}, {"J", s}, {"10", s}, {"9", s}]), do: {:straight_flush, [c]}
    defp rank([{"Q", s} = c, {"J", s}, {"10", s}, {"9", s}, {"8", s}]), do: {:straight_flush, [c]}
    defp rank([{"J", s} = c, {"10", s}, {"9", s}, {"8", s}, {"7", s}]), do: {:straight_flush, [c]}
    defp rank([{"10", s} = c, {"9", s}, {"8", s}, {"7", s}, {"6", s}]), do: {:straight_flush, [c]}
    defp rank([{"9", s} = c, {"8", s}, {"7", s}, {"6", s}, {"5", s}]), do: {:straight_flush, [c]}
    defp rank([{"8", s} = c, {"7", s}, {"6", s}, {"5", s}, {"4", s}]), do: {:straight_flush, [c]}
    defp rank([{"7", s} = c, {"6", s}, {"5", s}, {"4", s}, {"3", s}]), do: {:straight_flush, [c]}
    defp rank([{"6", s} = c, {"5", s}, {"4", s}, {"3", s}, {"2", s}]), do: {:straight_flush, [c]}
    defp rank([{"A", s}, {"5", s} = c, {"4", s}, {"3", s}, {"2", s}]), do: {:straight_flush, [c]}

    defp rank([{r, _} = c, {r, _}, {r, _}, {r, _}, k]), do: {:four_of_a_kind, [c, k]}
    defp rank([k, {r, _} = c, {r, _}, {r, _}, {r, _}]), do: {:four_of_a_kind, [c, k]}

    defp rank([{r1, _} = c1, {r1, _}, {r1, _}, {r2, _} = c2, {r2, _}]),
      do: {:full_house, [c1, c2]}

    defp rank([{r2, _} = c2, {r2, _}, {r1, _} = c1, {r1, _}, {r1, _}]),
      do: {:full_house, [c1, c2]}

    defp rank([{_, s}, {_, s}, {_, s}, {_, s}, {_, s}] = list), do: {:flush, list}

    defp rank([{"A", _} = c, {"K", _}, {"Q", _}, {"J", _}, {"10", _}]), do: {:straight, [c]}
    defp rank([{"K", _} = c, {"Q", _}, {"J", _}, {"10", _}, {"9", _}]), do: {:straight, [c]}
    defp rank([{"Q", _} = c, {"J", _}, {"10", _}, {"9", _}, {"8", _}]), do: {:straight, [c]}
    defp rank([{"J", _} = c, {"10", _}, {"9", _}, {"8", _}, {"7", _}]), do: {:straight, [c]}
    defp rank([{"10", _} = c, {"9", _}, {"8", _}, {"7", _}, {"6", _}]), do: {:straight, [c]}
    defp rank([{"9", _} = c, {"8", _}, {"7", _}, {"6", _}, {"5", _}]), do: {:straight, [c]}
    defp rank([{"8", _} = c, {"7", _}, {"6", _}, {"5", _}, {"4", _}]), do: {:straight, [c]}
    defp rank([{"7", _} = c, {"6", _}, {"5", _}, {"4", _}, {"3", _}]), do: {:straight, [c]}
    defp rank([{"6", _} = c, {"5", _}, {"4", _}, {"3", _}, {"2", _}]), do: {:straight, [c]}
    defp rank([{"A", _}, {"5", _} = c, {"4", _}, {"3", _}, {"2", _}]), do: {:straight, [c]}

    defp rank([{r1, _} = c1, {r1, _}, {r1, _}, c2, c3]), do: {:three_of_a_kind, [c1, c2, c3]}
    defp rank([c2, {r1, _} = c1, {r1, _}, {r1, _}, c3]), do: {:three_of_a_kind, [c1, c2, c3]}
    defp rank([c2, c3, {r1, _} = c1, {r1, _}, {r1, _}]), do: {:three_of_a_kind, [c1, c2, c3]}

    defp rank([{r1, _} = c1, {r1, _}, {r2, _} = c2, {r2, _}, k]), do: {:two_pair, [c1, c2, k]}
    defp rank([{r1, _} = c1, {r1, _}, k, {r2, _} = c2, {r2, _}]), do: {:two_pair, [c1, c2, k]}
    defp rank([k, {r1, _} = c1, {r1, _}, {r2, _} = c2, {r2, _}]), do: {:two_pair, [c1, c2, k]}

    defp rank([{r1, _} = c1, {r1, _}, c2, c3, c4]), do: {:one_pair, [c1, c2, c3, c4]}
    defp rank([c2, {r1, _} = c1, {r1, _}, c3, c4]), do: {:one_pair, [c1, c2, c3, c4]}
    defp rank([c2, c3, {r1, _} = c1, {r1, _}, c4]), do: {:one_pair, [c1, c2, c3, c4]}
    defp rank([c2, c3, c4, {r1, _} = c1, {r1, _}]), do: {:one_pair, [c1, c2, c3, c4]}

    defp rank(list), do: {:high_card, list}

    defp do_compare([], []), do: :eq

    defp do_compare([c1 | cards1], [c2 | cards2]) do
      case Card.compare(c1, c2) do
        :eq -> do_compare(cards1, cards2)
        result -> result
      end
    end
  end

  alias Poker.Hand

  @type hand() :: [String.t()]

  @spec best_hand([hand()]) :: [hand()]
  def best_hand(hands) do
    [h | t] = Enum.map(hands, &Poker.Hand.new/1)

    Enum.reduce(t, {h, [h]}, fn hand, {max, acc} ->
      case Hand.compare(hand, max) do
        :gt -> {hand, [hand]}
        :lt -> {max, acc}
        :eq -> {max, [hand | acc]}
      end
    end)
    |> then(fn {_, acc} -> acc end)
    |> Enum.map(& &1.origin)
    |> Enum.reverse()
  end
end
