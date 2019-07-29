class PokerFacadeService
  def hand_name(card_str)
    hand_judge = HandJudge.from_str(card_str)
    if hand_judge.valid?
      {hand_name: hand_judge.judge_name, err_messages: [], has_error: false}
    else
      {hand_name: '', err_messages: hand_judge.err_messages, has_error: true}
    end
  end

  def check_strong_card(card_strs)
    result = []
    card_strs.each do |card_str|
      judge = HandJudge.from_str(card_str)
      result.push({card: card_str, hand: judge.judge_name, best: false, strength: judge.judge_strength})
    end

    max_strength = result.max {|a, b| a[:strength] <=> b[:strength]}[:strength]
    result.each do |card_hash|
      if card_hash[:strength] == max_strength
        card_hash[:best] = true
      end
      card_hash.delete(:strength)
    end
    {result: result}
  end
end
