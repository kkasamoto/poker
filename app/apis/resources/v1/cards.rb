module Resources
  module V1
    class Cards < Grape::API
      resources :cards do

        helpers do
          def valid_array_elements(array)
            array.each do |a|
              unless a.instance_of?(String)
                raise Grape::Exceptions::ValidationErrors
              end
            end
          end
        end

        desc "check which card is winner"
        params do
          requires :cards, type: Array, allow_blank: false, coerce_with: ->(val) { val }
        end
        post :check do
          valid_array_elements(params[:cards])

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
