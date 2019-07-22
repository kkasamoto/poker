class HandBuilder
  def initialize
    @hands = [
      StraightFlush,
      FourCard,
      FullHouse,
      Flush,
      Straight,
      ThreeCard,
      TwoPair,
      OnePair,
      HighCard
    ]
  end

  def build(card:)
    @hands.each do |hand|
      if hand.is_this_hand?(card: card)
        return hand.new(card: card)
      end
    end
  end
end
