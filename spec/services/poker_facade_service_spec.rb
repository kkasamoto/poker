require 'rails_helper'
require 'spec_helper'


describe PokerFacadeService do
  describe '#hand_name' do
    describe "HandJudgeの成否によって違う結果を返せているか" do
      before do
        @mock_judge = instance_double(HandJudge)
        allow(HandJudge).to receive(:new).and_return(@mock_judge)
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
end
