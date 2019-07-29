module Resources
  module V1
    class Cards < Grape::API
      resources :cards do
        post :check do
        end
      end
    end
  end
end
