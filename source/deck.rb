class Deck
  class << self
    attr_reader :values, :suits
  end

  attr_reader :cards

  @suits = ["♠", "♥", "♣", "♦"]
  @values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

  def initialize
    suits = self.class.suits
    values = self.class.values
    @cards = []
    suits.each do |suit|
      values.each do |value|
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
