class Straight
  attr_reader :primary
  attr_reader :name
  attr_reader :card

  def initialize(card:)
    @primary = 5
    @name = 'ストレート'
    @card = card
  end

  def self.is_this_hand?(card:)
    nums = card.map { |c| c[1..3].to_i }
    sorted_nums = nums.sort_by {|i| i }

    # 連番か
    # 1, 10, 11, 12, 13の場合は速攻true
    if sorted_nums == [1, 10, 11, 12, 13]
      return true
    end
    now_n = sorted_nums[0]
    for i in sorted_nums do
      if now_n != i
        return false
      end
      now_n += 1
    end
    true
  end

end
