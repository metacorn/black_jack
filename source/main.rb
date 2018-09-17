class Main
  require_relative 'interface.rb'
  require_relative 'player.rb'
  require_relative 'game.rb'
  require_relative 'deck.rb'

  attr_reader :name, :interface

  def introduction
    @interface = Interface.new
    @name = @interface.ask_name
    new_game
  end

  private

  MENU = [
    ['pass', 'player_pass'],
    ['add card', 'player_add_card'],
    ['show cards', 'show_cards'],
  ].freeze

  def new_game
    @player = Player.new(name)
    @dealer = Player.new("Dealer")
    @game = Game.new(@player, @dealer)
    @deck = Deck.new
    unless @game.winner
      dealing
    end
  end

  def deal_card(player)
    if @deck.size != 0
      player.get_card(@deck.cards[0])
      @deck.remove_card
    else
      new_deck_deal_card(player)
    end
  end

  def new_deck_deal_card(player)
    @deck = Deck.new
    deal_card(@deck, player)
  end

  def show_table(dealer_shows)
    system "clear"
    show_dealer_block(dealer_shows)
    show_player_block
    show_bank_block
    show_history_block
    show_action_block
  end

  def show_dealer_block(dealer_shows)
    @interface.show_name(@dealer)
    @interface.show_hand(@dealer, dealer_shows)
    @interface.show_stack(@dealer)
    @interface.show_line
  end

  def show_player_block
    @interface.show_name(@player)
    @interface.show_hand(@player)
    @interface.show_stack(@player)
    @interface.show_points(@player)
    @interface.show_line
  end

  def show_bank_block
    @interface.show_bank(@bank)
    @interface.show_line
  end

  def show_history_block
    @interface.show_history(@history)
  end

  def show_action_block
    action_of(MENU)
  end

  def action_of(menu)
    item_index = @interface.show_menu(menu)
    choise = menu[item_index - 1]
    action = choise[1]
    send(action)
  end

  def dealing
    @bank = 0
    @bank += @dealer.bet
    @bank += @player.bet
    2.times { deal_card(@dealer) }
    2.times { deal_card(@player) }
    @history = []
    dealer_shows = false
    show_table(dealer_shows)
  end

  def player_pass
    dealer_action
    @history << "#{@player.name} passed."
    dealer_shows = false
    show_table(dealer_shows)
  end

  def player_add_card
    deal_card(@player)
    @history << "#{@player.name} got a card."
    dealer_shows = false
    show_table(dealer_shows)
  end

  def dealer_action
    if @dealer.get_points > 17
      dealer_pass
    else
      dealer_add_card
    end
  end

  def dealer_pass
    @history << "Dealer passed."
    dealer_shows = false
    show_table(dealer_shows)
  end

  def dealer_add_card
    deal_card(@dealer)
    @history << "Dealer got a card."
    dealer_shows = false
    show_table(dealer_shows)
  end

  def show_cards
    dealer_shows = true
    show_table(dealer_shows)
  end
end
