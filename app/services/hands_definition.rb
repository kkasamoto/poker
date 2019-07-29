module HandsDefinition
  module Hands
    STRAIGHT_FLUSH="ストレートフラッシュ"
    FOUR_OF_A_KIND="フォーカード"
    FULL_HOUSE="フルハウス"
    FLUSH="フラッシュ"
    STRAIGHT="ストレート"
    THREE_OF_A_KIND="スリーカード"
    TWO_PAIR="2ペア"
    ONE_PAIR="1ペア"
    HIGH_CARD="ハイカード"

    STRENGTH = {
      Hands::STRAIGHT_FLUSH => 80,
      Hands::FOUR_OF_A_KIND => 70,
      Hands::FULL_HOUSE => 60,
      Hands::FLUSH => 50,
      Hands::STRAIGHT => 40,
      Hands::THREE_OF_A_KIND => 30,
      Hands::TWO_PAIR => 20,
      Hands::ONE_PAIR => 10,
      Hands::HIGH_CARD => 0
    }
  end
end
