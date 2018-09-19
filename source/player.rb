class Player
  require_relative 'counter.rb'
  
  include Counter

  attr_reader :name, :stack, :hand

  def initialize(name)
    @name = name
    @hand = []
  end

  def initial_stack
    @stack = 100
  end

  def hand_out(out)
    @hand.each { |card| out << card }
    @hand = []
  end

  def get_card(card)
    @hand << card
  end

  def check_points
    total_points
  end

  def give_money(money)
    @stack -= money
  end

  def get_money(money)
    @stack += money
  end

  def can_add?
    @hand.size == 2
  end
end
