class Deck
  require_relative 'card.rb'

  attr_reader :content

  def initialize
    @content = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        card = Card.new(suit, value)
        @content << card
      end
    end
    shuffle
  end

  def size
    @content.size
  end

  def shuffle
    @content.sort_by! { rand }
  end

  def add_card(card)
    @content << card
  end

  def remove_card
    @content.delete_at(0)
  end
end
