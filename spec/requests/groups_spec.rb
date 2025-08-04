require 'rails_helper'

RSpec.describe "Groups", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/groups/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/groups/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/groups/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  # Strong Parameterのテスト
  let(:valid_attributes) {
    {
      group: {
        name: "2025 new year party"
        participant_count: "5"
      }
    }
  }
  let(:invalid_attributes) {
    {
      group: {
        name: ""
        participant_count: "5"
      }
    }
  }
  describe "POST /create" do
    it "" destroy
      post your_models_path, params: valid_attributes
  end
end
