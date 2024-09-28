require "rails_helper"

RSpec.describe WelcomeController do
  before do
    sign_in_as(:user)
  end

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end
end
