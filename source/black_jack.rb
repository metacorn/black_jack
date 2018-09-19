class BlackJack
  require_relative 'interface.rb'
  require_relative 'player.rb'
  require_relative 'deck.rb'
  require_relative 'bank.rb'
  require_relative 'history.rb'

  attr_reader :interface

  def introduction
    @interface = Interface.new
    player_name = @interface.ask_name
    @player = Player.new(player_name)
    @dealer = Player.new("Dealer")
    new_game
  end

  private

  MENU = [
    ['add card', 'player_add_card'],
    ['show cards', 'show_cards'],
    ['pass', 'player_pass'],
    ['exit', 'exit']
  ]

  NEXT_DEALING = [
    ['continue game', 'dealing'],
    ['exit', 'exit']
  ]

  NEXT_GAME = [
    ['new game', 'new_game'],
    ['exit', 'exit']
  ]

  def new_game
    @deck = Deck.new
    @out = []
    @bank = Bank.new
    @history = History.new
    initial_stacks
    dealing
  end

  def initial_stacks
    @player.initial_stack
    @dealer.initial_stack
  end

  def dealing
    clear_history
    hands_out
    banking
    getting_cards
    @dealer_card_visibility = false
    show_table
    ask_action
  end

  def clear_history
    @history.clear
  end

  def logging(action_msg)
    @history.write(action_msg)
  end

  def hands_out
    @dealer.hand_out(@out)
    @player.hand_out(@out)
  end

  def banking
    betting(@player)
    betting(@dealer)
  end

  def betting(player)
    bet = @bank.get_bet(player)
    logging("#{player.name} bet $#{bet}.")
  end

  def getting_cards
    initial_getting_cards(@player)
    initial_getting_cards(@dealer)
  end

  def initial_getting_cards(player)
    2.times { deal_card(player) }
    logging("#{player.name} got 2 cards.")
  end

  def show_table
    system "clear"
    show_dealer_block
    show_player_block
    show_bank_block
    show_history_block
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
    if @bank.current_bank != 0
      @interface.show_bank(@bank.current_bank)
      @interface.show_line
    end
  end

  def show_history_block
    @interface.show_history(@history) if @history.not_empty?
  end

  def ask_action
    if @player.can_add?
      action_of(MENU)
    else
      action_of(MENU.values_at(1, 3))
    end
  end

  def ask_next_dealing
    action_of(NEXT_DEALING)
  end

  def ask_next_game
    action_of(NEXT_GAME)
  end

  def action_of(menu)
    item_index = @interface.show_menu(menu)
    choise = menu[item_index - 1]
    action = choise[1]
    send(action)
  end

  def deal_card(player)
    if @deck.size != 0
      player.get_card(@deck.content[0])
      @deck.remove_card
    else
      shuffle_out_deal_card(player)
    end
  end

  def shuffle_out_deal_card(player)
    @out.each { |card| @deck.add_card(card) }
    @deck.shuffle
    @out = []
    logging("Deck was shuffled.")
    deal_card(player)
  end

  def player_pass
    logging("#{@player.name} passed.")
    dealer_action
    show_table
    ask_action
  end

  def player_add_card
    deal_card(@player)
    logging("#{@player.name} got a card.")
    full_hands?
    dealer_action
    show_table
    ask_action
  end

  def dealer_action
    if @dealer.check_points > 17
      dealer_pass
    elsif @dealer.can_add?
      dealer_add_card
    else
      dealer_pass
    end
  end

  def dealer_pass
    logging("Dealer passed.")
    show_table
    ask_action
  end

  def dealer_add_card
    deal_card(@dealer)
    logging("Dealer got a card.")
    full_hands?
    show_table
    ask_action
  end

  def full_hands?
    show_cards if @player.hand.size == 3 && @dealer.hand.size == 3
  end

  def show_cards
    logging("#{@player.name} showed cards.")
    logging("#{@dealer.name} showed cards.")
    @dealer_card_visibility = true
    define_dealing
    check_game_winner
    show_table
    ask_next_dealing
  end

  def define_dealing
    dealer_points = @dealer.check_points
    player_points = @player.check_points
    if (player_points > 21) && (dealer_points <= 21)
      dealing_winner(@dealer)
    elsif (player_points <= 21) && (dealer_points > 21)
      dealing_winner(@player)
    elsif (player_points > 21) && (dealer_points > 21)
      dealing_draw
    elsif player_points > dealer_points
      dealing_winner(@player)
    elsif player_points < dealer_points
      dealing_winner(@dealer)
    else
      dealing_draw
    end
  end

  def dealing_winner(player)
    pot = @bank.current_bank
    @bank.to_winner(player)
    logging("#{player.name} won $#{pot}!")
  end

  def dealing_draw
    pot = @bank.current_bank
    @bank.to_share(@player, @dealer)
    logging("Draw! Players shared the bank ($#{pot}).")
  end

  def check_game_winner
    game_winner(@player) if @dealer.stack == 0
    game_winner(@dealer) if @player.stack == 0
  end

  def game_winner(player)
    logging("#{player.name} won a game!")
    show_table
    ask_next_game
  end
end
