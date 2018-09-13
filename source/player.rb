class Player
  attr_reader :name, :stack, :hand

  def initialize(name)
    @name = name
    @stack = 100
    @hand = []
  end
end
