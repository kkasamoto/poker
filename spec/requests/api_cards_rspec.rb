require 'rails_helper'


describe 'API Request to api/v1/cards', type: :request do
  describe 'post :check' do
    before do
      @headers = {ACCEPT: 'application/json'}
      @mock_service = instance_double(PokerFacadeService)
      allow(PokerFacadeService).to receive(:new).and_return(@mock_service)
      allow(@mock_service).to receive(:check_strong_card).and_return({result: {card: 'card', hand: 'hand', best:true},
                                                                      error: {card: 'card_err', msg: 'msg'}})
    end

    describe 'リクエストに対して200 OKを返すこと' do
      it '全てのcardが正しいフォーマットの時' do
        post '/api/v1/cards/check', {cards: ["S1 S2 S3 S4 S5", "D1 H1 H2 H3 D3"]}, @headers
        expect(response.status).to eq 200
      end

      it '一部のcardのフォーマットが不正の時' do
        post '/api/v1/cards/check', {cards: ["S1 S2 S3 4 S5", "D1 H1 H2 H3 D3"]}, @headers
        expect(response.status).to eq 200
      end

      it '全てのcardのフォーマットが不正の時' do
        post '/api/v1/cards/check', {cards: ["S1 S SS", "1H1 H2 H3 D3"]}, @headers
        expect(response.status).to eq 200
      end
    end

    describe 'リクエストのBodyデータを正しくValidateしていること' do
      it 'cardsというkeyが存在しない（NG）' do
        post '/api/v1/cards/check', {cars: ["S1 S SS", "1H1 H2 H3 D3"]}, @headers
        expect(response.status).to eq 400
      end

      it '配列の中身が空（NG）' do
        post '/api/v1/cards/check', {cards: []}, @headers
        expect(response.status).to eq 400
      end

      it '配列に数字が存在（OK）' do
        post '/api/v1/cards/check', {cards: ["S1 S2", 1]}, @headers
        expect(response.status).to eq 200
      end

      it '配列の中身が全て文字列（OK）' do
        post '/api/v1/cards/check', {cards: ["S1 S2", "s"]}, @headers
        expect(response.status).to eq 200
      end
    end

    describe 'Serviceからの結果を正しく整形すること' do
      before do
        @return_rslt = [{card: 'card', hand: 'hand', best: true},
                       {card: 'card', hand: 'hand', best: true}]
        @return_error = [{card: 'card', msg: 'msg'},
                        {card: 'card', msg: 'msg'}]
      end
      it '結果：result項目あり、error項目は空' do
        allow(@mock_service).to receive(:check_strong_card).and_return({result: @return_rslt, error: []})
        post '/api/v1/cards/check', {cards: ["test"]}, @headers
        expect(response.body).to eq({result: @return_rslt}.to_json)
      end

      it '結果：result項目あり、error項目あり' do
        allow(@mock_service).to receive(:check_strong_card).and_return({result: @return_rslt, error: @return_error})
        post '/api/v1/cards/check', {cards: ["test"]}, @headers
        expect(response.body).to eq({result: @return_rslt, error: @return_error}.to_json)
      end

      it '結果：result項目空、error項目あり' do
        allow(@mock_service).to receive(:check_strong_card).and_return({result: [], error: @return_error})
        post '/api/v1/cards/check', {cards: ["test"]}, @headers
        expect(response.body).to eq({error: @return_error}.to_json)
      end

      it 'CardEntityは不可分なく値を取れているか？' do
        @return_rslt = [{card: 'card', hand: 'hand', best: true, strength: 80}]
        allow(@mock_service).to receive(:check_strong_card).and_return({result: @return_rslt, error: []})
        post '/api/v1/cards/check', {cards: ["test"]}, @headers
        expect(response.body).to eq({result: [{card: 'card', hand: 'hand', best: true}]}.to_json)
      end

      it 'CardErrorEntityは不可分なく値を取れているか？' do
        @return_error = [{card: 'card', msg: 'msg', bland: true}]
        allow(@mock_service).to receive(:check_strong_card).and_return({result: [], error: @return_error})
        post '/api/v1/cards/check', {cards: ["test"]}, @headers
        expect(response.body).to eq({error: [{card: 'card', msg: 'msg'}]}.to_json)
      end
    end
  end
end
