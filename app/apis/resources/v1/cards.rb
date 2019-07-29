module Resources
  module V1
    class Cards < Grape::API
      resources :cards do
        desc "check which card is winner"
        params do
          requires :cards, type: Array[String]
        end
        post :check do
          service = PokerFacadeService.new
          service.check_strong_card(params[:cards])
        end
      end
    end
  end
end
