class PokerFacadeService
  def hand_name(card_str)
    hand_judge = HandJudge.new_from_str(card_str)
    if hand_judge.valid?
      {hand_name: hand_judge.judge_name, err_messages: [], has_error: false}
    else
      {hand_name: '', err_messages: hand_judge.err_messages, has_error: true}
    end
  end

  def check_strong_card(card_strs)
    result = []
    error = []
    # cardごとに検証して、成功ならresultに、失敗ならerrorに追加
    card_strs.each do |card_str|
      judge = HandJudge.new_from_str(card_str)
      if judge.valid?
        result.push({card: card_str, hand: judge.judge_name, best: false, strength: judge.judge_strength})
      else
        error.push({card:card_str, msg: judge.err_messages[0]})
      end
    end

    # 最大の強さを調べて、該当するカードのbestキーにtrueを代入
    unless result.empty?
      max_strength = result.max {|a, b| a[:strength] <=> b[:strength]}[:strength]
      result.each do |card_hash|
        if card_hash[:strength] == max_strength
          card_hash[:best] = true
        end
      end
    end
    {result: result, error: error}
  end
end
