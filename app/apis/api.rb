class API < Grape::API
  format :json

  rescue_from Grape::Exceptions::Base do
    rack_response({error: [msg: "不正なリクエストです。"]}.to_json, 400)
  end

  route :any, '*path' do
    error!({error: [msg: "不正なURLです。"]}, 404)
  end

  mount Root
end

