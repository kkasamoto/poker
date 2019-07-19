class PokerController < ApplicationController
  attr_accessor :count

  def check_form
  end

  def check
    session[:card] = params[:card]
    service = Service.new
    result = service.hand_name(card_str: params[:card])
    if result[:has_error]
      flash[:err_messages] = result[:err_messages]
      session[:hand_name] = nil
    else
      session[:hand_name] = result[:hand_name]
    end
    redirect_to("/")
  end
end
