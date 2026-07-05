defmodule Poker do
  defmodule Card do
    @regex ~r/^(?<rank>[2-9]|10|[JQKA])(?<suit>[CDHS])$/
    @ranks ~w(2 3 4 5 6 7 8 9 10 J Q K A)
           |> Enum.with_index(2)
           |> Map.new()

    @type rank() :: String.t()
    @type suit() :: String.t()
    @type t() :: {rank(), suit()}

    @spec new(String.t() | tuple()) :: t() | {:error, String.t()}
    def new(card) when is_binary(card) do
      case Regex.named_captures(@regex, card) do
        %{"rank" => rank, "suit" => suit} -> {rank, suit}
        _ -> {:error, "Invalid card format"}
      end
    end

    @spec compare(t(), t()) :: :lt | :gt | :eq
    def compare({rank1, _}, {rank2, _}) do
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

    defstruct [:origin, :rank, :cards]

    @type rank() ::
            :high_card
            | :one_pair
            | :two_pair
            | :three_of_a_kind
            | :straight
            | :flush
            | :full_house
            | :four_of_a_kind
            | :straight_flush
            | :royal_flush

    @type t() :: %__MODULE__{
            origin: [String.t()],
            cards: [Card.t()],
            rank: rank()
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
      {rank, cards} =
        list
        |> Enum.map(&Card.new/1)
        |> Enum.sort({:desc, Card})
        |> rank()

      %__MODULE__{
        origin: list,
        cards: cards,
        rank: rank
      }
    end

    @spec compare(t(), t()) :: :lt | :gt | :eq
    def compare(hand1, hand2) do
      v1 = Map.fetch!(@ranks, hand1.rank)
      v2 = Map.fetch!(@ranks, hand2.rank)

      cond do
        v1 < v2 -> :lt
        v1 > v2 -> :gt
        true -> do_compare(hand1.cards, hand2.cards)
      end
    end

    defp do_compare([], []), do: :eq

    defp do_compare([c1 | cards1], [c2 | cards2]) do
      case Card.compare(c1, c2) do
        :eq -> do_compare(cards1, cards2)
        result -> result
      end
    end

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
  end

  alias Poker.Hand

  @type hand() :: [String.t()]

  @spec best_hand([hand()]) :: [hand()]
  def best_hand(hands) do
    [hand | hands] = Enum.map(hands, &Poker.Hand.new/1)

    Enum.reduce(hands, {hand, [hand]}, fn current_hand, {max, acc} ->
      case Hand.compare(current_hand, max) do
        :gt -> {current_hand, [current_hand]}
        :lt -> {max, acc}
        :eq -> {max, [current_hand | acc]}
      end
    end)
    |> then(fn {_, acc} -> acc end)
    |> Enum.map(& &1.origin)
    |> Enum.reverse()
  end
end
