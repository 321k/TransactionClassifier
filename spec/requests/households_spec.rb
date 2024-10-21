require 'rails_helper'

RSpec.describe "Households", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/households/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/households/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/households/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/households/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
