require_relative 'poker_error'
require 'set'

class Hand
  attr_accessor :cards, :value

  def initialize(cards)
    @cards = cards
    @value = 0

    set_value
    raise PokerError::InvalidNumberOfCardsError if @cards.size != 5
  end

  def >(hand)
    @value > hand.value
  end

  def <(hand)
    @value < hand.value
  end

  def set_value
    hand_cards_values = @cards.map(&:value)
    hand_cards_int_values = @cards.map(&:int_value)
    hand_cards_colors = @cards.map(&:color)

    if royal_flush(hand_cards_values, hand_cards_colors)
      @value = 10
    elsif straight_flush(hand_cards_int_values, hand_cards_colors)
      @value = 9
    elsif four_of_kind(hand_cards_values)
      @value = 8
    elsif full_house(hand_cards_values)
      @value = 7
    elsif flush(hand_cards_colors)
      @value = 6
    elsif straight(hand_cards_int_values)
      @value = 5
    elsif three_of_kind(hand_cards_values)
      @value = 4
    elsif two_pair(hand_cards_values)
      @value = 3
    elsif one_pair(hand_cards_values)
      @value = 2
    end
  end

  private

  def royal_flush(values, colors)
    @value == 0 &&
    values.include?('A') &&
    values.include?('K') &&
    values.include?('Q') &&
    values.include?('J') &&
    values.include?('T') &&
    colors.uniq.size == 1

  end

  def straight_flush(values, colors)
    @value == 0 && colors.uniq.size == 1 && sequential_rank(values)
  end

  def four_of_kind(values)
    @value == 0 && to_h_with_counter(values).values.include?(4)
  end

  def full_house(values)
    @value == 0 && to_h_with_counter(values).values.sort == [2, 3]
  end

  def flush(colors)
    @value == 0 && colors.uniq.size == 1
  end

  def straight(values)
    @value == 0 && sequential_rank(values)
  end

  def three_of_kind(values)
    @value == 0 && to_h_with_counter(values).values.include?(3)
  end

  def two_pair(values)
    @value == 0 && to_h_with_counter(values).values.sort == [1, 2, 2]
  end

  def one_pair(values)
    @value == 0 && to_h_with_counter(values).values.sort == [1, 1, 1, 2]
  end

  def to_h_with_counter(ary)
    ary.each_with_object(Hash.new(0)) { |element, counts| counts[element] += 1 }
  end

  def sequential_rank(values)
    values.sort.each_cons(2).all? { |x, y| y == x + 1 }
  end
end
