class PokerController < ApplicationController
  def check_form
  end

  def check
    @card = params[:card]
    service = Service.new
    result = service.hand_name(card_str: @card)
    if result[:has_error]
      @err_messages = result[:err_messages]
    else
      @hand_name = result[:hand_name]
    end
    render("poker/check_form")
  end
end
