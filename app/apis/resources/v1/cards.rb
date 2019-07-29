module Resources
  module V1
    class Cards < Grape::API
      resources :cards do
        desc "check which card is winner"
        post :check do
          service = PokerFacadeService.new
          #service.check_strong_card(params[:cards])
          present service.check_strong_card(params[:cards]), with: Entities::V1::CardsEntity
        end
      end
    end
  end
end
