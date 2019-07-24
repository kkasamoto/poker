class PokerService
  def hand_name(card_str:)
    card = card_str.strip.split
    validator = CardValidator.new
    if validator.valid?(card)
      hand = HandBuilder.new.build(card: card)
      {hand_name: hand.name, err_messages: [], has_error: false}
    else
      {hand_name: '', err_messages: validator.err_messages, has_error: true}
    end
  end
end
