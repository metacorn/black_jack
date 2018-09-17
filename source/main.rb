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
    ['exit', 'exit']
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

  def show_table
    system "clear"
    show_dealer_block
    show_player_block
    show_bank_block
    show_history_block
    show_action_block
  end

  def show_dealer_block
    @interface.show_name(@dealer)
    if @dealer_card_visibility == false
      @interface.show_hidden_hand(@dealer)
    else
      @interface.show_hand(@dealer)
    end
    @interface.show_stack(@dealer)
    @interface.show_points(@dealer) if @dealer_card_visibility == true
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
    @history = []
    @bank = 0
    @dealer.betting
    @bank += @dealer.bet
    @history << "Dealer bet $#{@dealer.bet}."
    @player.betting
    @bank += @player.bet
    @history << "#{@player.name} bet $#{@player.bet}."
    2.times { deal_card(@dealer) }
    @history << "Dealer got 2 cards."
    2.times { deal_card(@player) }
    @history << "#{@player.name} got 2 cards."
    @dealer_card_visibility = false
    show_table
  end

  def player_pass
    @history << "#{@player.name} passed."
    dealer_action
    show_table
  end

  def player_add_card
    deal_card(@player)
    @history << "#{@player.name} got a card."
    check_cards
    show_table
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
    show_table
  end

  def dealer_add_card
    deal_card(@dealer)
    @history << "Dealer got a card."
    check_cards
    show_table
  end

  def check_cards
    show_cards if @player.hand.size == 3 && @dealer.hand.size == 3
  end

  def show_cards
    @history << "#{@player.name} showed cards."
    @dealer_card_visibility = true
    define_dealing_winner
    show_table
  end

  def define_dealing_winner
    if @player.get_points > 21 && @dealer.get_points < 21
      player_won(@dealer)
    elsif @player.get_points > @dealer.get_points
      @player.take_bank(@bank)
      @history << "#{@player.name} won $#{@bank}!"
    elsif @player.get_points < @dealer.get_points
      @dealer.take_bank(@bank)
      @history << "Dealer won $#{@bank}!"
    else
      @history << "Draw! Players shared the bank ($#{@bank})."
      @player.share_bank(@bank)
      @dealer.share_bank(@bank)
    end
  end

  def player_won(player)
    player.take_bank(@bank)
    @history << "#{player.name} won $#{@bank}!"
  end


end
