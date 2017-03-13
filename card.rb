require_relative 'poker_error'

POSSIBLE_CARD_NAMES = %w( 2C 3C 4C 5C 6C 7C 8C 9C TC JC QC KC AC
                          2D 3D 4D 5D 6D 7D 8D 9D TD JD QD KD AD
                          2H 3H 4H 5H 6H 7H 8H 9H TH JH QH KH AH
                          2S 3S 4S 5S 6S 7S 8S 9S TS JS QS KS AS )

class Card
  attr_accessor :value, :int_value, :color

  def initialize(name)
    @name = name
    @value = name.slice(0..-2)
    @int_value = value_to_i
    @color = name[-1]

    raise PokerError::InvalidCardError unless POSSIBLE_CARD_NAMES.include?(name)
  end

  def >(card)
    @int_value > card.int_value
  end

  def <(card)
    @int_value < card.int_value
  end

  private

  def value_to_i
    case @value
      when 'T'
        @int_value = 10
      when 'J'
        @int_value = 11
      when 'Q'
        @int_value = 12
      when 'K'
        @int_value = 13
      when 'A'
        @int_value = 14
      else
        @int_value = @value.to_i
    end
  end
end
