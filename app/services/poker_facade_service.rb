class PokerFacadeService
  def hand_name(card_str)
    hand_judge = HandJudge.from_str(card_str)
    if hand_judge.valid?
      {hand_name: hand_judge.judge_name, err_messages: [], has_error: false}
    else
      {hand_name: '', err_messages: hand_judge.err_messages, has_error: true}
    end
  end
end
