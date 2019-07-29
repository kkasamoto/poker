module Entities
  module V1
    class CardEntity < RootEntity
      expose :card, :hand, :best
    end
  end
end
