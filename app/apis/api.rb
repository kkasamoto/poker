class API < Grape::API
  include Grape::Exceptions

  format :json

  rescue_from InvalidMessageBody, ValidationErrors do
    rack_response({error: [msg: "不正なリクエストです。"]}.to_json, 400)
  end

  route :any, '*path' do
    error!({error: [msg: "不正なURLです。"]}, 404)
  end

  mount Root
end

