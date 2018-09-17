class Game
  attr_reader :player, :dealer, :winner

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
    @winner = nil
  end
end
