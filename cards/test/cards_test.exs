defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck makes 48 cards" do
    assert length(Cards.create_deck) == 48
  end

  test "shuffling a deck randomizes it" do
    deck = Cards.create_deck
    refute deck == Cards.shuffle(deck)
    assert deck != Cards.shuffle(deck)
  end

end
