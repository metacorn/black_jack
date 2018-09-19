class Bank
  attr_reader :current_bank
  BET = 10.freeze

  def initialize
    @current_bank = 0
  end

  def get_bet(player)
    player.give_money(BET)
    @current_bank += BET
    BET
  end

  def to_winner(player)
    player.get_money(@current_bank)
    @current_bank = 0
  end

  def to_share(player_1, player_2)
    refund = @current_bank / 2
    player_1.get_money(refund)
    player_2.get_money(refund)
    @current_bank = 0
  end
end
