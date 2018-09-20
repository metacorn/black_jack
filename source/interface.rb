class Interface
  MENU = {
    add_card: {text: 'add card', action: 'player_add_card'},
    show_cards: {text: 'show cards', action: 'show_cards'},
    pass: {text: 'pass', action: 'player_pass'},
    continue_game: {text: 'continue game', action: 'dealing'},
    new_game: {text: 'new game', action: 'new_game'},
    exit: {text: 'exit', action: 'exit'}
  }.freeze

  def show_menu(*items)
    menu = MENU.values_at(*items)
    puts "Choose your action (put the number):"
    menu.each_with_index do |item, index|
      puts "#{index + 1}. #{item[:text].to_s.capitalize}."
    end
    print '>> '
    item_index = gets.to_i
    check_item_index(item_index, menu.size)
    return_action(menu, item_index)
  end

  def return_action(menu, item_index)
    item = menu[item_index - 1]
    action = item[:action]
  end

  def check_item_index(item_index, menu_size)
    until (1..menu_size).cover?(item_index)
      puts "\nChoose the correct number (1..#{menu_size}) of action:"
      item_index = gets.to_i
    end
    item_index
  end

  def ask_name
    puts "What is your name?"
    gets.chomp.capitalize
  end

  def show_name(player)
    name = player.name
    puts "#{name.upcase}:"
  end

  def show_hand(player)
    print "Cards:"
    player.hand.cards.each { |card| print " #{card.suit}#{card.value}" }
    puts "."
  end

  def show_hidden_hand(player)
    print "Cards:"
    player.hand.cards.each { |card| print " ##" }
    puts "."
  end

  def show_stack(player)
    stack = player.stack
    puts "Stack: $#{stack}."
  end

  def show_points(player)
    points = player.hand.points
    puts "Points: #{points}."
  end

  def show_bank(bank)
    puts "Bank: $#{bank}."
  end

  def show_line
    puts ""
  end

  def show_history(history)
    puts "ACTIVITY:"
    history.list.each { |action| puts action}
    puts "\n"
  end
end
