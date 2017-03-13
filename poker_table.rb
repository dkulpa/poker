require_relative 'poker_error'

class PokerTable
  def initialize(table)
    @table = table
    @left_hand = create_hand(split(@table).first(5))
    @right_hand = create_hand(split(@table).last(5))

    raise PokerError::DuplicatedCardError if split(@table) != split(@table).uniq
  end

  def strongest_hand
    if @left_hand > @right_hand || stronger_overall_value([@left_hand, @right_hand])
      'left'
    elsif @right_hand > @left_hand || stronger_overall_value([@right_hand, @left_hand])
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

  def split(table)
    table.split(' ')
  end

  def stronger_overall_value(hands)
    hands.first.cards.map(&:int_value).inject(&:+) > hands.last.cards.map(&:int_value).inject(&:+)
  end
end
