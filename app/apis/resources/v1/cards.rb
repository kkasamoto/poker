module Resources
  module V1
    class Cards < Grape::API
      resources :cards do
        desc "check which card is winner"
        params do
          requires :cards, type: Array[String], allow_blank: false
        end
        post :check do
          status 200

          service = PokerFacadeService.new
          rslt_check = service.check_strong_card(params[:cards])
          present :result, rslt_check[:result], with: Entities::V1::CardEntity unless rslt_check[:result].empty?
          present :error, rslt_check[:error], with: Entities::V1::CardErrorEntity unless rslt_check[:error].empty?
        end
      end
    end
  end
end
