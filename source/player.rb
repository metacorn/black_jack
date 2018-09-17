class Player
  attr_reader :name, :stack, :hand, :points

  def initialize(name)
    @name = name
    @stack = 100
    @hand = []
  end

  def get_card(card)
    @hand << card
  end

  def get_points
    @points = 0
    @points += points_non_a
    @points += points_a(points)
  end

  def points_non_a
    points_non_a = 0
    @hand.each do |card|
      case card[:value]
      when "2", "3", "4", "5", "6", "7", "8", "9", "10"
        points_non_a += card[:value].to_i
      when "J", "Q", "K"
        points_non_a += 10
      else
        points_non_a += 0
      end
    end
    points_non_a
  end

  def points_a(non_a_points)
    points_a = 0
    a_amount = 0
    @hand.each { |card| a_amount += 1 if card[:value] == "A" }
    if a_amount == 0
      points_a += 0
    elsif (non_a_points + a_amount * 11) <= 21
      points_a += (a_amount * 11)
    elsif (non_a_points + 1 + (a_amount - 1) * 11) <= 21
      points_a += (1 + (a_amount - 1) * 11)
    else
      points_a += (2 + (a_amount - 2) * 11)
    end
    points_a
  end

  def bet
    bet = 10
    @stack -= bet
    bet
  end
end
