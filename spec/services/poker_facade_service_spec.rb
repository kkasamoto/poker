require 'rails_helper'
require 'spec_helper'


describe PokerFacadeService do
  describe '#hand_name' do
    describe "HandJudgeの成否によって違う結果を返せているか" do
      before do
        @mock_judge = instance_double(HandJudge)
        allow(HandJudge).to receive(:new_from_str).and_return(@mock_judge)
        allow(@mock_judge).to receive(:judge_name).and_return('test')
        allow(@mock_judge).to receive(:err_messages).and_return(['error1', 'error2'])
      end

      it 'HandJudgeのvalid?がtrueの時正しい結果を返すか？' do
        card_str = 'S1 S2 S3 S4 S5'
        allow(@mock_judge).to receive(:valid?).and_return(true)
        instance = PokerFacadeService.new
        expect(instance.hand_name(card_str)).to eq({hand_name: 'test', err_messages: [], has_error: false})
      end

      it 'HandJudgeのvalid?がfalseの時正しい結果を返すか？' do
        card_str = 'S1 S2 S3 S4 S5'
        allow(@mock_judge).to receive(:valid?).and_return(false)
        instance = PokerFacadeService.new
        expect(instance.hand_name(card_str)).to eq({hand_name: '', err_messages: ['error1', 'error2'], has_error: true})
      end
    end
  end

  describe '#check_strong_card' do
    describe  'HandJudge#valid?の返り値によって、正しく結果を振り分けること' do
      before do
        @mock_judge = instance_double(HandJudge)
        allow(HandJudge).to receive(:new_from_str).and_return(@mock_judge)
        allow(@mock_judge).to receive(:judge_name).and_return('test')
        allow(@mock_judge).to receive(:err_messages).and_return(['error1'])
        allow(@mock_judge).to receive(:judge_strength).and_return(0)
      end

      it '要素が1つでvalid?がtrueになる場合' do
        allow(@mock_judge).to receive(:valid?).and_return(true)
        card_strs = ['true']
        instance = PokerFacadeService.new
        expect(instance.check_strong_card(card_strs)).to eq({result: [{card: 'true', hand: 'test', best: true, strength: 0}],
                                                            error: []})
      end

      it '要素が1つでvalid?がfalseになる場合' do
        allow(@mock_judge).to receive(:valid?).and_return(false)
        card_strs = ['false']
        instance = PokerFacadeService.new
        expect(instance.check_strong_card(card_strs)).to eq({result: [],
                                                             error: [{card: 'false', msg: 'error1'}]})
      end

      it '要素が2つでvalid?がtrueになる場合（要素が複数の場合にも対応しているか？）' do
        allow(@mock_judge).to receive(:valid?).and_return(true)
        card_strs = ['true', 'true']
        instance = PokerFacadeService.new
        expect(instance.check_strong_card(card_strs)).to eq({result: [{card: 'true', hand: 'test', best: true, strength: 0},
                                                                     {card: 'true', hand: 'test', best: true, strength: 0}],
                                                             error: []})
      end
    end

    describe '正確にカードの強さを判定し、bestキーにtrueを入れること' do
      before do
        @mock_judge1 = instance_double(HandJudge)
        allow(@mock_judge1).to receive(:judge_strength).and_return(0)
        @mock_judge2 = instance_double(HandJudge)
        allow(@mock_judge2).to receive(:judge_strength).and_return(30)
        @mock_judge3 = instance_double(HandJudge)
        allow(@mock_judge3).to receive(:judge_strength).and_return(80)
        allow(HandJudge).to receive(:new_from_str).with('weak').and_return(@mock_judge1)
        allow(HandJudge).to receive(:new_from_str).with('middle').and_return(@mock_judge2)
        allow(HandJudge).to receive(:new_from_str).with('strong').and_return(@mock_judge3)
        allow(@mock_judge1).to receive(:judge_name).and_return('test')
        allow(@mock_judge1).to receive(:valid?).and_return(true)
        allow(@mock_judge2).to receive(:judge_name).and_return('test')
        allow(@mock_judge2).to receive(:valid?).and_return(true)
        allow(@mock_judge3).to receive(:judge_name).and_return('test')
        allow(@mock_judge3).to receive(:valid?).and_return(true)
      end

      it '1つだけ強さ30が存在する場合' do
        card_strs = ['middle']
        instance = PokerFacadeService.new
        expect(instance.check_strong_card(card_strs)).to eq({result: [{card: 'middle', hand: 'test', best: true, strength: 30}],
                                                             error: []})
      end

      it '1つだけ強さ0が存在する場合' do
        card_strs = ['weak']
        instance = PokerFacadeService.new
        expect(instance.check_strong_card(card_strs)).to eq({result: [{card: 'weak', hand: 'test', best: true, strength: 0}],
                                                             error: []})
      end

      it '3つ違う強さが存在する場合' do
        card_strs = ['weak', 'middle', 'strong']
        instance = PokerFacadeService.new
        expect(instance.check_strong_card(card_strs)).to eq({result: [{card: 'weak', hand: 'test', best: false, strength: 0},
                                                                      {card: 'middle', hand: 'test', best: false, strength: 30},
                                                                      {card: 'strong', hand: 'test', best: true, strength: 80}],
                                                             error: []})
      end

      it '3つ同じ強さが存在する場合' do
        card_strs = ['strong', 'strong', 'strong']
        instance = PokerFacadeService.new
        expect(instance.check_strong_card(card_strs)).to eq({result: [{card: 'strong', hand: 'test', best: true, strength: 80},
                                                                      {card: 'strong', hand: 'test', best: true, strength: 80},
                                                                      {card: 'strong', hand: 'test', best: true, strength: 80}],
                                                             error: []})
      end

      it '2つ同じ強さで他2つが強い場合' do
        card_strs = ['weak', 'strong', 'weak', 'strong']
        instance = PokerFacadeService.new
        expect(instance.check_strong_card(card_strs)).to eq({result: [{card: 'weak', hand: 'test', best: false, strength: 0},
                                                                      {card: 'strong', hand: 'test', best: true, strength: 80},
                                                                      {card: 'weak', hand: 'test', best: false, strength: 0},
                                                                      {card: 'strong', hand: 'test', best: true, strength: 80}],
                                                             error: []})
      end

      it '2つ同じ強さで他2つが弱い場合' do
        card_strs = ['weak', 'strong', 'strong', 'weak']
        instance = PokerFacadeService.new
        expect(instance.check_strong_card(card_strs)).to eq({result: [{card: 'weak', hand: 'test', best: false, strength: 0},
                                                                      {card: 'strong', hand: 'test', best: true, strength: 80},
                                                                      {card: 'strong', hand: 'test', best: true, strength: 80},
                                                                      {card: 'weak', hand: 'test', best: false, strength: 0}],
                                                             error: []})
      end
    end
  end
end
