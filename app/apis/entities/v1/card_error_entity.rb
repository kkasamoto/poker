module Entities
  module V1
    class CardErrorEntity < Grape::Entity
      expose :card, :msg
    end
  end
end
