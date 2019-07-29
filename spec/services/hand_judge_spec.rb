require 'rails_helper'
require 'spec_helper'


describe HandJudge do
  describe "self.new_from_str" do
    it "空白区切りによる文字列で表現されたカードを正しく5つに分けているか" do
      card_str = "S1 S2 S3 S4 S5"
      instance = HandJudge.new_from_str(card_str)
      expect(instance.card).to eq ["S1", "S2", "S3", "S4", "S5"]
    end

    it "端っこに空白がある場合、カードを正しく5つに分けているか" do
      card_str = "  S1 S2 S3 S4 S5 "
      instance = HandJudge.new_from_str(card_str)
      expect(instance.card).to eq ["S1", "S2", "S3", "S4", "S5"]
    end

    it "空白2つで区切られていた場合、カードを正しく5つに分けているか" do
      card_str = "S1  S2 S3  S4 S5"
      instance = HandJudge.new_from_str(card_str)
      expect(instance.card).to eq ["S1", "S2", "S3", "S4", "S5"]
    end

    it "全角の空白の場合、正しく分けれない" do
      card_str = "S1　S2 S3 S4 S5"
      instance = HandJudge.new_from_str(card_str)
      expect(instance.card).to eq ["S1　S2", "S3", "S4", "S5"]
    end
  end

  describe "#valid?" do
    # 検証観点
    # 1. 要素は5つあるか？
    # 2. カードのフォーマットは正しいか？
    # 3. カードに重複はあるか？
    # 検証の優先度は1 > 2 > 3
    describe "成功" do
      # 成功のためには、要素数が５でカードに重複がないことが絶対条件。よって調べるのはフォーマットのみ
      it "スートHDCSは成功する？" do
        card = ["S2", "D2", "H2", "C2", "C3"]
        instance = HandJudge.new(card)
        expect(instance.valid?).to eq true
      end

      it "数字の最低は1" do
        card = ["S1", "D1", "H1", "C1", "C2"]
        instance = HandJudge.new(card)
        expect(instance.valid?).to eq true
      end

      it "数字の最高は13" do
        card = ["S13", "D13", "H13", "C13", "C4"]
        instance = HandJudge.new(card)
        expect(instance.valid?).to eq true
      end
    end

    describe "失敗" do
      describe "要素数について" do
        it "要素数が4" do
          card = ["S1", "S2", "S3", "S4"]
          instance = HandJudge.new(card)
          expect(instance.valid?).to eq false
        end

        it "要素数が6" do
          card = ["S1", "S2", "S3", "S4", "S5", "S6"]
          instance = HandJudge.new(card)
          expect(instance.valid?).to eq false
        end

        it "要素数が0" do
          card = []
          instance = HandJudge.new(card)
          expect(instance.valid?).to eq false
        end
      end

      describe "カードのフォーマットについて" do
        describe "不正文字がある" do
          it "全角数字" do
            card  = ['H１', 'H2', 'H3', 'H4', 'H5']
            instance = HandJudge.new(card)
            expect(instance.valid?).to eq false
          end

          it "小文字のhdscどれか" do
            card = ['h1', 'H2', 'H3', 'H4', 'H5']
            instance = HandJudge.new(card)
            expect(instance.valid?).to eq false
          end

          it "HDSC以外の大文字" do
            card = ['F1', 'H2', 'H3', 'H4', 'H5']
            instance = HandJudge.new(card)
            expect(instance.valid?).to eq false
          end
        end

        describe "不正文字はないが、フォーマットが間違い" do
          it "スート1文字だけ" do
            card = ['H', 'H2', 'H3', 'H4', 'H5']
            instance = HandJudge.new(card)
            expect(instance.valid?).to eq false
          end

          it "数字1文字だけ" do
            card = ['1', 'H2', 'H3', 'H4', 'H5']
            instance = HandJudge.new(card)
            expect(instance.valid?).to eq false
          end

          it "数字部分が14" do
            card = ['H14', 'H2', 'H3', 'H4', 'H5']
            instance = HandJudge.new(card)
            expect(instance.valid?).to eq false
          end

          it "数字部分が0" do
            card = ['H0', 'H2', 'H3', 'H4', 'H5']
            instance = HandJudge.new(card)
            expect(instance.valid?).to eq false
          end

          it "スートと数字の位置が逆" do
            card = ['1H', 'H2', 'H3', 'H4', 'H5']
            instance = HandJudge.new(card)
            expect(instance.valid?).to eq false
          end

          it "正しいフォーマットの最後尾にスート" do
            card = ['H1H', 'H2', 'H3', 'H4', 'H5']
            instance = HandJudge.new(card)
            expect(instance.valid?).to eq false
          end

          it "正しいフォーマットの最前列に数字" do
            card = ['1H1', 'H2', 'H3', 'H4', 'H5']
            instance = HandJudge.new(card)
            expect(instance.valid?).to eq false
          end
        end
      end

      describe "カードに重複がある" do
        it "並んで重複" do
          card = ['H1', 'H1', 'H2', 'H3', 'H4']
          instance = HandJudge.new(card)
          expect(instance.valid?).to eq false
        end

        it "バラバラで重複" do
          card = ['H1', 'H2', 'H1', 'H3', 'H4']
          instance = HandJudge.new(card)
          expect(instance.valid?).to eq false
        end

        it "全部同じカード" do
          card = ['H1', 'H1', 'H1', 'H1', 'H1']
          instance = HandJudge.new(card)
          expect(instance.valid?).to eq false
        end
      end
    end

    describe "メッセージの返し方" do
      describe "要素数が失敗した時のメッセージ" do
        before do
          @expect_messages = ['5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）']
        end

        it "要素数だけ失敗" do
          card = ['H1']
          instance = HandJudge.new(card)
          instance.valid?
          expect(instance.err_messages).to eq @expect_messages
        end

        it "要素数と重複の失敗" do
          card = ['H1', 'H1']
          instance = HandJudge.new(card)
          instance.valid?
          expect(instance.err_messages).to eq @expect_messages
        end

        it "要素数とフォーマットの失敗" do
          card = ['h1']
          instance = HandJudge.new(card)
          instance.valid?
          expect(instance.err_messages).to eq @expect_messages
        end
      end

      describe "フォーマットが失敗した時のメッセージ" do
        it "フォーマットが失敗して、重複は成功" do
          @expect_messages = [
            '1番目のカード指定文字が不正です。（h1）',
            '半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。'
          ]
          card = ['h1', 'H2', 'H3', 'H4', 'H5']
          instance = HandJudge.new(card)
          instance.valid?
          expect(instance.err_messages).to eq @expect_messages
        end

        it "フォーマットが失敗して、重複も失敗" do
          @expect_messages = [
            '1番目のカード指定文字が不正です。（h1）',
            '半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。'
          ]
          card = ['h1', 'H3', 'H3', 'H4', 'H5']
          instance = HandJudge.new(card)
          instance.valid?
          expect(instance.err_messages).to eq @expect_messages
        end

        it "フォーマットが複数失敗" do
          @expect_messages = [
            '1番目のカード指定文字が不正です。（h1）',
            '5番目のカード指定文字が不正です。（h2）',
            '半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。'
          ]
          card = ['h1', 'H3', 'H3', 'H4', 'h2']
          instance = HandJudge.new(card)
          instance.valid?
          expect(instance.err_messages).to eq @expect_messages
        end
      end
    end
  end

  describe "#judge_name" do
    describe "正しい役判定をするかどうか" do
      it "ストレートフラッシュ(1, 10, 11, 12, 13)" do
        card = ["S10", "S1", "S11", "S13", "S12"]
        instance = HandJudge.new(card)
        expect(instance.judge_name).to eq "ストレートフラッシュ"
      end

      it "ストレートフラッシュ(普通)" do
        card = ["S9", "S8", "S6", "S10", "S7"]
        instance = HandJudge.new(card)
        expect(instance.judge_name).to eq "ストレートフラッシュ"
      end

      it "フォーカード" do
        card = ["S9", "C7", "H7", "S7", "D7"]
        instance = HandJudge.new(card)
        expect(instance.judge_name).to eq "フォーカード"
      end

      it "フルハウス" do
        card = ["S9", "C7", "H9", "S7", "D7"]
        instance = HandJudge.new(card)
        expect(instance.judge_name).to eq "フルハウス"
      end

      it "フラッシュ" do
        card = ["S9", "S7", "S11", "S1", "S2"]
        instance = HandJudge.new(card)
        expect(instance.judge_name).to eq "フラッシュ"
      end

      it "ストレート(1, 10, 11, 12, 13)" do
        card = ["D10", "S1", "S11", "S13", "S12"]
        instance = HandJudge.new(card)
        expect(instance.judge_name).to eq "ストレート"
      end

      it "ストレート(普通)" do
        card = ["D9", "S8", "S6", "S10", "S7"]
        instance = HandJudge.new(card)
        expect(instance.judge_name).to eq "ストレート"
      end

      it "スリーカード" do
        card = ["D9", "S9", "H9", "S10", "S7"]
        instance = HandJudge.new(card)
        expect(instance.judge_name).to eq "スリーカード"
      end

      it "2ペア" do
        card = ["D9", "S9", "H10", "S10", "S7"]
        instance = HandJudge.new(card)
        expect(instance.judge_name).to eq "2ペア"
      end

      it "1ペア" do
        card = ["D9", "S9", "H6", "S10", "S7"]
        instance = HandJudge.new(card)
        expect(instance.judge_name).to eq "1ペア"
      end

      it "ハイカード" do
        card = ["D1", "S2", "H6", "S10", "S7"]
        instance = HandJudge.new(card)
        expect(instance.judge_name).to eq "ハイカード"
      end
    end
  end

  describe "#judge_strength" do
    describe "正しい強さ（数値）を返すかどうか" do
      it "ストレートフラッシュ == 80" do
        card = ["S9", "S8", "S6", "S10", "S7"]
        instance = HandJudge.new(card)
        expect(instance.judge_strength).to eq 80
      end

      it "ストレート == 40" do
        card = ["D9", "S8", "S6", "S10", "S7"]
        instance = HandJudge.new(card)
        expect(instance.judge_strength).to eq 40
      end

      it "ハイカード == 0" do
        card = ["D1", "S2", "H6", "S10", "S7"]
        instance = HandJudge.new(card)
        expect(instance.judge_strength).to eq 0
      end
    end
  end
end
