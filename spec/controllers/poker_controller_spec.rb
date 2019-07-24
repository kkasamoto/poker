require 'rails_helper'
require 'spec_helper'


describe PokerController do
  describe 'GET #top' do
    before do
      get :top
    end

    it 'リクエストは200 OKとなること' do
      expect(response.status).to eq 200
    end

    it ':topテンプレートを表示すること' do
      expect(response).to render_template :top
    end
  end

  describe 'POST #check' do
    describe 'serviceの戻り値が成功結果の場合' do
      before do
        @mock_service = instance_double(PokerFacadeService)
        allow(PokerFacadeService).to receive(:new).and_return(@mock_service)
        allow(@mock_service).to receive(:hand_name).and_return(
          {hand_name: 'test_name', err_messages: [], has_error: false }
        )
        post :check, params: {card: "test_card"}
      end

      it 'リクエストは200 OKとなること' do
        expect(response.status).to eq 200
      end

      it 'session[:hand_name]に、service結果[:hand_name]が入っていること' do
        expect(session[:hand_name]).to eq 'test_name'
      end

      it ':topテンプレートを表示すること' do
        expect(response).to render_template :top
      end
    end
    describe 'serviceの戻り値が失敗結果の場合' do
      before do
        @mock_service = instance_double(PokerFacadeService)
        allow(PokerFacadeService).to receive(:new).and_return(@mock_service)
        allow(@mock_service).to receive(:hand_name).and_return(
          {hand_name: '', err_messages: ['error1', 'error2'], has_error: true }
        )
        post :check, params: {card: "test_card"}
      end

      it 'リクエストは400 となること' do
        expect(response.status).to eq 400
      end

      it 'flash[:err_messages]に、service結果[:err_messages]が入っていること' do
        expect(flash[:err_messages]).to eq ['error1', 'error2']
      end

      it 'session[:hand_name]に、nilが入っていること' do
        expect(session[:hand_name]).to eq nil
      end

      it ':topテンプレートを表示すること' do
        expect(response).to render_template :top
      end
    end
  end
end
