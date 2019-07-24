class PokerFacadeService
  def hand_name(card_str:)
    card = card_str.strip.split
    hand_judge = HandJudge.new(card)
    if hand_judge.valid?
      {hand_name: hand_judge.judge_name, err_messages: [], has_error: false}
    else
      {hand_name: '', err_messages: hand_judge.err_messages, has_error: true}
    end
  end
end
