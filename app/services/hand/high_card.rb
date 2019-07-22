class HighCard
  attr_reader :primary
  attr_reader :name
  attr_reader :card

  def initialize(card:)
    @primary = 9
    @name = 'ハイカード'
    @card = card
  end

  def self.is_this_hand?(card:)
    if card.uniq.length == 5
      return true
    end
    false
  end
end
