require_relative 'poker_error'

class PokerTable
  def initialize(table)
    @table = table
    @left_hand = create_hand(@table.split(' ').first(5))
    @right_hand = create_hand(@table.split(' ').last(5))

    raise PokerError::DuplicatedCardError if @table.split(' ') != @table.split(' ').uniq
  end

  def strongest_hand
    if @left_hand > @right_hand ||
      @left_hand.cards.map(&:int_value).inject(&:+) > @right_hand.cards.map(&:int_value).inject(&:+)
      'left'
    elsif @right_hand > @left_hand ||
      @right_hand.cards.map(&:int_value).inject(&:+) > @left_hand.cards.map(&:int_value).inject(&:+)
      'right'
    else
      'tie'
    end
  end

  private

  def create_hand(card_codes)
    Hand.new(get_cards(card_codes))
  end

  def get_cards(card_codes)
    card_codes.map do |card_code|
      Card.new(card_code)
    end
  end
end
