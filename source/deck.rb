class Deck

  attr_reader :cards

  SUITS = ["♠", "♥", "♣", "♦"]
  VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

  def initialize
    @cards = []
    SUITS.each do |suit|
      VALUES.each do |value|
        card = {value: value, suit: suit}
        @cards << card
      end
    end
    shuffle
  end

  def size
    @cards.size
  end

  def shuffle
    @cards.sort_by! { rand }
  end

  def add_card(card)
    @cards << card
  end

  def remove_card
    @cards.delete_at(0)
  end
end
