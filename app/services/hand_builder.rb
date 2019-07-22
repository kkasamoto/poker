require 'hand/straight_flush'
require 'hand/four_card'
require 'hand/full_house'
require 'hand/flush'
require 'hand/straight'
require 'hand/three_card'
require 'hand/two_pair'
require 'hand/one_pair'
require 'hand/high_card'


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
