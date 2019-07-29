module Resources
  module V1
    class Root < Grape::API
      version 'v1'
      format :json
      content_type :json, 'application/json'

      route :any, '*path' do
        {error: [msg: "不正なURLです。"]}
      end

      rescue_from Grape::Exceptions::ValidationErrors do
        rack_response({error: [msg: "不正なリクエストです。"]}.to_json, 400)
      end

      mount Resources::V1::Cards
    end
  end
end
