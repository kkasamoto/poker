module Entities
  module V1
    class CardEntity < Grape::Entity
      expose :card, :hand, :best
    end
  end
end
