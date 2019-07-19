class Rule
  def initialize
    @rule = [
      StraightFlush.new,
      FourCard.new,
      FullHouse.new,
      Flush.new,
      Straight.new,
      ThreeCard.new,
      TwoPair.new,
      OnePair.new,
      HighCard.new
    ]
  end

  def hand(card:)
    @rule.each do |hand|
      if hand.is_this_hand?(card: card)
        return hand
      end
    end
  end
end


class StraightFlush
  def hand_name
    "ストレートフラッシュ"
  end

  def is_this_hand?(card:)
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


class FourCard
  def hand_name
    "フォー・オブ・ア・カインド"
  end

  def is_this_hand?(card:)
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


class FullHouse
  def hand_name
    "フルハウス"
  end

  def is_this_hand?(card:)
    count_num_h = (1..13).map { |num| [num, 0] }.to_h
    nums = card.map { |c| c[1..3].to_i }
    nums.each do |i|
      count_num_h[i] += 1
    end

    count = 0
    count_num_h.values.each do |i|
      if i == 2
        count += 1
      end
      if i == 3
        count += 2
      end
    end

    count == 3
  end
end


class Flush
  def hand_name
    "フラッシュ"
  end

  def is_this_hand?(card:)
    suits = card.map { |c| c[0] }
    if suits.uniq.length == 1
      return true
    end
    false
  end
end


class Straight
  def hand_name
    "ストレート"
  end

  def is_this_hand?(card:)
    nums = card.map { |c| c[1..3].to_i }
    sorted_nums = nums.sort_by {|i| i }

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


class ThreeCard
  def hand_name
    "スリー・オブ・ア・カインド"
  end

  def ThreeCard.is_this_hand?(card:)
    count_num_h = (1..13).map { |num| [num, 0] }.to_h
    nums = card.map { |c| c[1..3].to_i }
    nums.each do |i|
      count_num_h[i] += 1
    end

    count = 0
    count_num_h.values.each do |i|
      if i == 2
        count -= 1
      end
      if i == 3
        count += 1
      end
    end

    return count == 1
  end
end


class TwoPair
  def hand_name
    "ツーペア"
  end

  def is_this_hand?(card:)
    count_num_h = (1..13).map { |num| [num, 0] }.to_h
    nums = card.map { |i| card[1..3].to_i }
    nums.each do |i|
      count_num_h[i] += 1
    end

    count = 0
    count_num_h.values.each do |i|
      if i == 2
        count += 1
      end
    end

    count == 2
  end
end


class OnePair
  def hand_name
    "ワンペア"
  end

  def is_this_hand?(card:)
    count_num_h = (1..13).map { |num| [num, 0] }.to_h
    nums = card.map { |i| card[1..3].to_i }
    nums.each do |i|
      count_num_h[i] += 1
    end

    count = 0
    count_num_h.values.each do |i|
      if i == 2
        count += 1
      end
    end

    count == 1
  end
end


class HighCard
  def hand_name
    "ハイカード"
  end

  def is_this_hand?(card:)
    if card.uniq == 5
      return true
    end

    false
  end
end
