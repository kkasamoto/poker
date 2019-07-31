module Resources
  module V1
    class Cards < Grape::API
      resources :cards do

        helpers do
          def raise_for_invalid_element(array)
            array.each do |a|
              raise Grape::Exceptions::ValidationErrors unless a.instance_of?(String)
            end
          end
        end

        desc "check which card is winner"
        params do
          requires :cards, type: Array, allow_blank: false
        end
        post :check do
          raise_for_invalid_element(params[:cards])

          service = PokerFacadeService.new
          rslt_check = service.check_strong_card(params[:cards])
          present :result, rslt_check[:result], with: Entities::V1::CardEntity unless rslt_check[:result].empty?
          present :error, rslt_check[:error], with: Entities::V1::CardErrorEntity unless rslt_check[:error].empty?

          if rslt_check[:error].empty?
            status 200
          else
            status 400
          end
        end
      end
    end
  end
end
