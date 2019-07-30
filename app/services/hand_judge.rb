class HandJudge
  include HandsDefinition::Hands
  attr_reader :card
  attr_reader :err_messages

  def self.new_from_str(card_str)
    card = card_str.strip.split
    return self.new(card)
  end

  def initialize(card)
    @card = card
    @err_messages = []
  end

  # Arguments:
  #   card(array<str>):  トランプ文字列5つからなる配列
  def valid?
    # 1. cardは5枚あるか？
    # 2. cardそれぞれは指定のフォーマットを満たしているか？
    # 3. cardに重複はないか？

    # 1.
    if @card.length != 5
      @err_messages.append('5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）')
      return false
    end
    #2.
    @card.each_with_index  do |c,idx|
      if not c.match(/^[SHDC]([1-9]|10|11|12|13)$/)
        @err_messages.append("#{idx+1}番目のカード指定文字が不正です。（#{c}）")
      end
    end
    if @err_messages.length >= 1
      @err_messages.append('半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。')
      return false
    end
    #3.
    if @card.length != @card.uniq.length
      @err_messages.append('カードが重複しています。')
      return false
    end
    true
  end

  # 役の強さを返す
  def judge_strength
    STRENGTH.each do |k, v|
      if k == judge_name
        return v
      end
    end
  end

  # 名前を返す
  def judge_name
    if same_suit? && sequence?
      return HandsDefinition::Hands::STRAIGHT_FLUSH
    end
    if same_suit?
      return HandsDefinition::Hands::FLUSH
    end
    if sequence?
      return HandsDefinition::Hands::STRAIGHT
    end
    num_pattern = group_by_num.sort_by {|i| i}
    case num_pattern
    when [1,4]
      return HandsDefinition::Hands::FOUR_OF_A_KIND
    when [2,3]
      return HandsDefinition::Hands::FULL_HOUSE
    when [1,1,3]
      return HandsDefinition::Hands::THREE_OF_A_KIND
    when [1,2,2]
      return HandsDefinition::Hands::TWO_PAIR
    when [1,1,1,2]
      return HandsDefinition::Hands::ONE_PAIR
    else
      return HandsDefinition::Hands::HIGH_CARD
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
