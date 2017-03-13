class PokerError
  class InvalidCardError < StandardError
  end

  class InvalidNumberOfCardsError < StandardError
  end

  class DuplicatedCardError < StandardError
  end
end
