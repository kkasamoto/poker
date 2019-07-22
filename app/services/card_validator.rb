class CardValidator
  attr_reader :err_messages

  # Arguments:
  #   card(array<str>):  トランプ文字列5つからなる配列
  def valid?(card)
    # 1. cardは5枚あるか？
    # 2. cardそれぞれは指定のフォーマットを満たしているか？
    # 3. cardに重複はないか？

    # 初期化
    @err_messages = []
    # 1.
    if card.length != 5
      @err_messages.append('5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）')
      return false
    end
    #2.
    card.each_with_index  do |c,idx|
      if not c.match(/^[SHDC](\d|10|11|12|13)$/)
       @err_messages.append("#{idx+1}番目のカード指定文字が不正です。（#{c}）")
      end
    end
    if @err_messages.length >= 1
      @err_messages.append('半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。')
      return false
    end
    #3.
    if card.length != card.uniq.length
      @err_messages.append('カードが重複しています。')
      return false
    end
    true
  end
end
