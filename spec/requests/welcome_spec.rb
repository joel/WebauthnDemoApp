require "rails_helper"

RSpec.describe "Welcomes" do
  let!(:user) { create(:user) }

  before do
    sign_in_as(user)
  end

  describe "GET /home" do
    it "returns http success" do
      get "/welcome/home"
      expect(response).to have_http_status(:success)
    end
  end
end
