class PokerFacadeService
  def hand_name(card_str:)
    card = card_str.strip.split
    validator = CardValidator.new
    hand_judge = HandJudge.new(card)
    if validator.valid?(card)
      {hand_name: hand_judge.judge_name, err_messages: [], has_error: false}
    else
      {hand_name: '', err_messages: validator.err_messages, has_error: true}
    end
  end
end
