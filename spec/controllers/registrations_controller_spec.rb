require "rails_helper"

RSpec.describe RegistrationsController do
  let(:valid_attributes) do
    { name => FFaker::Name.name }
  end

  let(:invalid_attributes) do
    { name: nil }
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
      it "stores in session the create options" do
        allow(WebAuthn).to receive(:generate_user_id).and_return("Generated ID")

        create_options = double
        allow(create_options).to receive_messages(challenge: "Challenge", to_json: { foo: :bar }.to_json)

        relying_party = instance_double(RelyingPartyService)
        allow(relying_party).to receive(:options_for_registration).and_return(create_options)

        allow(controller).to receive(:relying_party).and_return(relying_party)

        post :create, params: { registration: { username: "Bob" } }, session: valid_session, format: :json

        expect(response).to be_successful

        expect(response.parsed_body).to eq("foo" => "bar")

        expect(relying_party).to have_received(:options_for_registration).with(
          {
            user: {
              name: "Bob",
              id: "Generated ID"
            },
            authenticator_selection: { user_verification: "required" }
          }
        )

        expect(session[:current_registration]).to eq(
          {
            challenge: "Challenge",
            registration_info: {
              username: "Bob",
              webauthn_id: "Generated ID"
            }
          }
        )
      end

      context "when the user already exists" do
        let!(:user)      { create(:user, name: "Bob") }
        let(:credential) { build(:credential, user:) }

        it "responds with the error message" do
          allow(controller).to receive(:relying_party).and_return(NullObject.new)

          post :create, params: { registration: { username: user.name } }, session: valid_session, format: :json

          expect(response).to be_unprocessable

          expect(response.parsed_body).to eq("errors" => ["Name has already been taken"])
        end
      end
    end
  end

  describe "POST #callback" do
    context "with valid params" do
      let(:authenticator) { WebAuthn::FakeAuthenticator.new }

      let(:fake_rp) do
        WebAuthn::RelyingParty.new(
          origin: "https://fake.relying_party.test",
          id: "fake.relying_party.test",
          name: "Fake RelyingParty"
        )
      end

      let(:fake_client) do
        WebAuthn::FakeClient.new("https://fake.relying_party.test", authenticator:)
      end

      let(:user) do
        OpenStruct.new(id: WebAuthn.generate_user_id, name: "John Doe", credentials: [])
      end

      it "creates a new User and Credential" do
        options = fake_rp.options_for_registration(
          user: user.to_h.slice(:id, :name),
          exclude: user.credentials
        )
        challenge = options.challenge
        webauthn_credential = fake_client.create(challenge:, rp_id: fake_rp.id)

        allow(controller).to receive(:relying_party).and_return(fake_rp)

        session = {
          current_registration: {
            challenge:,
            registration_info: {
              username: "John Doe",
              webauthn_id: user.id
            }
          }
        }

        expect do
          expect do
            post(
              :callback,
              params: {
                credential_nickname: "John's Security Key",
                user: user.to_h.slice(:id, :name),
                authenticator_selection: { user_verification: "required" }
              }.merge(webauthn_credential),
              session:,
              format: :json
            )
          end.to change(User, :count).by(1)
        end.to change(Credential, :count).by(1)

        expect(response).to be_successful
      end
    end

    context "with invalid params" do
      let(:fake_rp) do
        WebAuthn::RelyingParty.new(
          origin: "https://fake.relying_party.test",
          id: "fake.relying_party.test",
          name: "Fake RelyingParty"
        )
      end

      it "renders a response with 422 status" do
        allow(fake_rp).to receive(:verify_registration).and_raise(WebAuthn::Error, "WebAuthn::UserVerifiedVerificationError")
        allow(controller).to receive(:relying_party).and_return(fake_rp)

        session = { current_registration: { challenge: "Challenge" } }

        expect do
          expect do
            post :callback, params: { registration: invalid_attributes }, session:
          end.not_to change(User, :count)
        end.not_to change(Credential, :count)

        expect(response).to have_http_status(:unprocessable_entity)

        expect(response.parsed_body).to eq({ "error" => "Verification failed: WebAuthn::UserVerifiedVerificationError" })
      end
    end
  end
end
