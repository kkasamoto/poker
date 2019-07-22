class FourCard
  attr_reader :primary
  attr_reader :name
  attr_reader :card

  def initialize(card:)
    @primary = 2
    @name = "フォーカード"
    @card = card
  end

  def self.is_this_hand?(card:)
    count_num_h = (1..13).map { |num| [num, 0] }.to_h
    nums = card.map { |c| c[1..3].to_i }
    nums.each do |i|
      count_num_h[i] += 1
    end
    count_num_h.values.each do |i|
      if i == 4
        return true
      end
    end
    false
  end
end
