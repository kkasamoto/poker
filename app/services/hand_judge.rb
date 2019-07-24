class HandJudge
  attr_reader :card

  module Hands
    STRAIGHT_FLUSH="ストレートフラッシュ"
    FOUR_OF_A_KIND="フォーカード"
    FULL_HOUSE="フルハウス"
    FLUSH="フラッシュ"
    STRAIGHT="ストレート"
    THREE_OF_A_KIND="スリーカード"
    TWO_PAIR="2ペア"
    ONE_PAIR="1ペア"
    HIGH_CARD="ハイカード"

    STRENGTH = {
      Hands::STRAIGHT_FLUSH => 80,
      Hands::FOUR_OF_A_KIND => 70,
      Hands::FULL_HOUSE => 60,
      Hands::FLUSH => 50,
      Hands::STRAIGHT => 40,
      Hands::THREE_OF_A_KIND => 30,
      Hands::TWO_PAIR => 20,
      Hands::ONE_PAIR => 10,
      Hands::HIGH_CARD => 0
    }
  end

  def initialize(card)
    @card = card
  end

  # 役の強さを返す
  def judge_strength
    Hands::STRENGTH.each do |h, p|
      if h == judge_name
        p
      end
    end
  end

  # 名前を返す
  def judge_name
    if same_suit? && sequence?
      return Hands::STRAIGHT_FLUSH
    end
    if same_suit?
      return Hands::FLUSH
    end
    if sequence?
      return Hands::STRAIGHT
    end
    num_pattern = group_by_num.sort_by {|i| i}
    case num_pattern
    when [1,4]
      return Hands::FOUR_OF_A_KIND
    when [2,3]
      return Hands::FULL_HOUSE
    when [1,1,3]
      return Hands::THREE_OF_A_KIND
    when [1,2,2]
      return Hands::TWO_PAIR
    when [1,1,1,2]
      return Hands::ONE_PAIR
    else
      return Hands::HIGH_CARD
    end
  end

  private

    def same_suit?
      suits = @card.map { |c| c[0] }
      suits.uniq.length == 1
    end

    def sequence?
      nums = card.map { |c| c[1..3].to_i }
      sorted_nums = nums.sort_by {|i| i }
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

    # カードの数字部分でグルーピングし、グループの大きさリストを返す。
    # ex) card = ["S1", "D1", "D3", "H3", "D2"]
    #     -> [2, 2, 1]
    def group_by_num
      @card.group_by {|c| c[1..3]}.values.map(&:size)
    end
end
