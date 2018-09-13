class Main
  require_relative 'interface.rb'
  require_relative 'player.rb'
  require_relative 'game.rb'
  require_relative 'deck.rb'

  attr_reader :name, :interface

  def introduction
    @interface = Interface.new
    @name = @interface.ask_name
    start_game
  end

  def start_game
    player = Player.new(name)
    dealer = Player.new("Dealer")
    game = Game.new(player, dealer)
  end
end
