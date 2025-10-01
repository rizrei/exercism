defmodule GottaSnatchEmAll do
  @moduledoc """
  Your nostalgia for Blorkemon™️ cards is showing no sign of slowing down, you even started collecting them again, and you are getting your friends to join you.
  In this exercise, a card collection is represented by a MapSet, since duplicate cards are not important when your goal is to get all existing cards.
  """

  @type card :: String.t()
  @type collection :: MapSet.t(card())

  @spec new_collection(card()) :: collection()
  def new_collection(card), do: MapSet.new([card])

  @spec add_card(card(), collection()) :: {boolean(), collection()}
  def add_card(card, collection) do
    {MapSet.member?(collection, card), MapSet.put(collection, card)}
  end

  @spec trade_card(card(), card(), collection()) :: {boolean(), collection()}
  def trade_card(your_card, their_card, collection) do
    {
      MapSet.member?(collection, your_card) and not MapSet.member?(collection, their_card),
      collection |> MapSet.delete(your_card) |> MapSet.put(their_card)
    }
  end

  @spec remove_duplicates([card()]) :: [card()]
  def remove_duplicates(cards), do: cards |> MapSet.new() |> MapSet.to_list() |> Enum.sort()

  @spec extra_cards(collection(), collection()) :: non_neg_integer()
  def extra_cards(your_collection, their_collection) do
    your_collection |> MapSet.difference(their_collection) |> MapSet.size()
  end

  @spec boring_cards([collection()]) :: [card()]
  def boring_cards([]), do: []

  def boring_cards(collections) do
    collections |> Enum.reduce(&MapSet.intersection/2) |> MapSet.to_list() |> Enum.sort()
  end

  @spec total_cards([collection()]) :: non_neg_integer()
  def total_cards([]), do: 0

  def total_cards(collections) do
    collections |> Enum.reduce(&MapSet.union/2) |> MapSet.size()
  end

  @spec split_shiny_cards(collection()) :: {[card()], [card()]}
  def split_shiny_cards(collection) do
    collection
    |> Enum.split_with(&String.starts_with?(&1, "Shiny"))
    |> Tuple.to_list()
    |> Enum.map(&Enum.sort/1)
    |> List.to_tuple()
  end
end
