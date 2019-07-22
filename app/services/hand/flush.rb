class Flush
  attr_reader :primary
  attr_reader :name
  attr_reader :card

  def initialize(card:)
    @primary = 4
    @name = 'フラッシュ'
    @card = card
  end

  def self.is_this_hand?(card:)
    suits = card.map { |c| c[0] }
    if suits.uniq.length == 1
      return true
    end
    false
  end
end
