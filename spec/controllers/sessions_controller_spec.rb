require "rails_helper"

RSpec.describe SessionsController do
  let(:user) do
    user = create(:user, name: "john")
    create(:credential, user:, external_id: "WebAuthn Generated ID")
    user
  end

  let(:valid_attributes) do
    { username: user.name }
  end

  let(:invalid_attributes) do
    { username: nil }
  end

  let(:valid_session) { {} }

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:relying_party) { instance_double(RelyingPartyService) }

      it "stores the options for authentication in the session" do
        options_for_authentication = double
        allow(options_for_authentication).to receive_messages(
          challenge: "Challenge",
          to_json: { options_for_authentication: :challenge }.to_json
        )

        allow(relying_party).to receive(:options_for_authentication).and_return(options_for_authentication)

        allow(controller).to receive(:relying_party).and_return(relying_party)

        post :create, params: { session: valid_attributes }, format: :json

        expect(relying_party).to have_received(:options_for_authentication).with(
          {
            allow: ["WebAuthn Generated ID"],
            user_verification: "required"
          }
        )

        expect(session[:current_authentication]).to eq(
          {
            challenge: "Challenge",
            username: "john"
          }
        )

        expect(response).to be_successful

        expect(response.parsed_body).to eq("options_for_authentication" => "challenge")
      end
    end

    context "with invalid params" do
      it "renders a response with 422 status" do
        post :create, params: { session: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)

        expect(response.parsed_body).to eq("errors" => ["User not registered!"])
      end
    end
  end

  describe "DELETE #destroy" do
    it "sign out the user" do
      delete :destroy, params: {}, session: { user_id: user.id }
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root path" do
      delete :destroy, params: {}, session: { user_id: user.id }
      expect(response).to redirect_to(root_path)
    end
  end
end
