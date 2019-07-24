class PokerController < ApplicationController
  def top
  end

  def check
    session[:card] = params[:card]
    service = PokerService.new
    result = service.hand_name(card_str: params[:card])
    if result[:has_error]
      flash.now[:err_messages] = result[:err_messages]
      session[:hand_name] = nil
      render('poker/top', status: 400)
    else
      session[:hand_name] = result[:hand_name]
      render('poker/top', status: 200)
    end
  end
end
