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
          rslt_for_check = service.check_strong_card(params[:cards])
          if rslt_for_check[:result].size != 0
            present :result, rslt_for_check[:result], with: Entities::V1::CardEntity
          end
          if rslt_for_check[:error].size != 0
            present :error, rslt_for_check[:error], with: Entities::V1::CardErrorEntity
          end
        end
      end
    end
  end
end
