require_relative 'poker_error'

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

    royal_flush(hand_cards_values, hand_cards_colors)
    straight_flush(hand_cards_int_values, hand_cards_colors)
    four_of_kind(hand_cards_values)
    full_house(hand_cards_values)
    flush(hand_cards_colors)
    straight(hand_cards_int_values)
    three_of_kind(hand_cards_values)
    two_pair(hand_cards_values)
    one_pair(hand_cards_values)
  end

  private

  def royal_flush(values, colors)
    if @value == 0 &&
      values.include?('A') &&
      values.include?('K') &&
      values.include?('Q') &&
      values.include?('J') &&
      values.include?('T') &&
      colors.uniq.size == 1
      @value = 10
    end
  end

  def straight_flush(values, colors)
    if @value == 0 && colors.uniq.size == 1 && sequential_rank(values)
      @value = 9
    end
  end

  def four_of_kind(values)
    if @value == 0 && array_to_h_with_counter(values).values.include?(4)
      @value = 8
    end
  end

  def full_house(values)
    if @value == 0 && array_to_h_with_counter(values).values.sort == [2, 3]
      @value = 7
    end
  end

  def flush(colors)
    if @value == 0 && colors.uniq.size == 1
      @value = 6
    end
  end

  def straight(values)
    if @value == 0 && sequential_rank(values)
      @value = 5
    end
  end

  def three_of_kind(values)
    if @value == 0 && array_to_h_with_counter(values).values.include?(3)
      @value = 4
    end
  end

  def two_pair(values)
    if @value == 0 && array_to_h_with_counter(values).values.sort == [1, 2, 2]
      @value = 3
    end
  end

  def one_pair(values)
    if @value == 0 && array_to_h_with_counter(values).values.sort == [1, 1, 1, 2]
      @value = 2
    end
  end

  def array_to_h_with_counter(ary)
    ary.each_with_object(Hash.new(0)) { |element, counts| counts[element] += 1 }
  end

  def sequential_rank(values)
    values.sort.each_cons(2).all? { |x, y| y == x + 1 }
  end
end
