require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/groups/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create' do
    it 'returns http success' do
      get '/groups/create'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/groups/destroy'
      expect(response).to have_http_status(:success)
    end
  end

  # Strong Parameterのテスト
  let(:valid_attributes) {
    {
      group: {
        name: '2025 new year party',
        participant_count: '5'
      }
    }
  }
  let(:invalid_attributes) {
    {
      group: {
        name: '2026 new year party',
        participant_count: '5',
        malicious_param: 'invalid_atr'
      }
    }
  }
  describe 'POST #create' do
    context 'グループ作成時許可されたパラメータの場合' do
      it 'モデルが作成されること' do
        expect {
          post groups_path, params: valid_attributes
        }.to change(Group, :count).by(1)
      end
      it '正しい属性でモデルが作成されること' do
        post groups_path, params: valid_attributes
        expect(Group.last.name).to eq('2025 new year party')
      end
    end

    context 'グループ作成時許可されていないパラメータが含まれる場合' do
      it '悪意のあるパラメータが保存されないこと' do
        post groups_path, params: invalid_attributes
        expect(Group.last).not_to respond_to(:malicious_param)
        expect(Group.last.attributes.keys).not_to include('malicious_param')
      end
      it 'モデルが作成されるが、悪意のあるパラメータは無視されること' do
        expect {
          post groups_path, params: invalid_attributes
        }.to change(Group, :count).by(1)
        expect(Group.last.name).to eq('2026 new year party')
      end
    end
  end
end
