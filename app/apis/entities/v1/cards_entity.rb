module Entities
  module V1
    class CardsEntity < RootEntity
      expose :result, using: CardEntity
    end
  end
end
