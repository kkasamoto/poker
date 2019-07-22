class StraightFlush
  attr_reader :primary
  attr_reader :name
  attr_reader :card

  def initialize(card:)
    @primary = 1
    @name = 'ストレートフラッシュ'
    @card = card
  end

  def self.is_this_hand?(card:)
    suits = card.map { |c| c[0] }
    nums = card.map { |c| c[1..3].to_i }
    sorted_nums = nums.sort_by {|i| i }
    # スートが同じか
    if suits.uniq.length != 1
      return false
    end

    # 連番か
    if sorted_nums == [1, 10, 11, 12, 13]
      return false
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
