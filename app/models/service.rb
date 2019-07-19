class Service
  def hand_name(card_str:)
    card = card_str.strip.split
    validator = CardValidator.new
    if validator.valid?(card)
      rule = Rule.new
      {hand_name: rule.hand(card: card).hand_name, err_messages: [], has_error: false}
    else
      {hand_name: '', err_messages: validator.err_messages, has_error: true}
    end
  end
end
