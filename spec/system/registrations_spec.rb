# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registration", :authentication do
  let(:fake_origin)      { Rails.configuration.webauthn_origin }
  let(:fake_client)      { WebAuthn::FakeClient.new(fake_origin, encoding: false) }
  let(:fixed_challenge)  { SecureRandom.random_bytes(32) }
  let(:fake_credentials) { fake_client.create(challenge: fixed_challenge, user_verified: true) }

  before do
    allow_any_instance_of(WebAuthn::PublicKeyCredential::CreationOptions).to receive(:raw_challenge).and_return(fixed_challenge)
  end

  it "allows a user to register" do
    # Visit the page where the user can create a post
    visit new_registrations_path

    stub_create(fake_credentials)

    # Fill in the form fields
    fill_in "Username", with: "John"
    fill_in "Nickname", with: "John's Security Key"

    # Submit the form
    click_on "Save Registration"

    # Expect to see the success message or be redirected to the home page
    expect(page).to have_content("Welcome#home")
  end
end
