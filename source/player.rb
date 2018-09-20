require_relative 'hand.rb'

class Player
  attr_reader :name, :stack, :hand

  def initialize(name)
    @name = name
    @hand = Hand.new
  end

  def initial_stack
    @stack = 100
  end

  def give_money(money)
    @stack -= money
  end

  def get_money(money)
    @stack += money
  end
end
