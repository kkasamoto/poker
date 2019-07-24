require 'rails_helper'
require 'spec_helper'


describe PokerFacadeService do
  describe '#hand_name' do
    before do
      @mock_judge = instance_double(HandJudge)
      allow(HandJudge).to receive(:new).and_return(@mock_judge)
      allow(@mock_judge).to receive(:judge_name).and_return('test')
      allow(@mock_judge).to receive(:err_messages).and_return(['error1', 'error2'])
    end

    it 'HandJudgeのvalid?がtrueの時正しい結果を返すか？' do
      allow(@mock_judge).to receive(:valid?).and_return(true)
      instance = PokerFacadeService.new
      expect(instance.hand_name('S1 S2 S3 S4 S5')).to eq(
                                                        {hand_name: 'test', err_messages: [], has_error: false})
    end

    it 'HandJudgeのvalid?がfalseの時正しい結果を返すか？' do
      allow(@mock_judge).to receive(:valid?).and_return(false)
      instance = PokerFacadeService.new
      expect(instance.hand_name('S1 S2 S3 S4 S5')).to eq(
                                                        {hand_name: '', err_messages: ['error1', 'error2'], has_error: true})
    end

    it 'card_strは5つの要素に分けられているかどうか'
    it 'card_strの端っこに空白があっても気にせず、5つの要素に分けれているかどうか'
  end
end
