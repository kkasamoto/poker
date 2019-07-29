module Resources
  module V1
    class Cards < Grape::API
      resources :cards do
        desc "check which card is winner"
        post :check do
          service = PokerFacadeService.new
          service.which_strong_card(params[:cards])
        end
      end
    end
  end
end
