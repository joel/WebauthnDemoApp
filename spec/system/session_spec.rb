# frozen_string_literal: true

require "rails_helper"
require "webauthn/fake_client"

RSpec.describe "Session", :authentication do
  let(:fake_origin)      { Rails.configuration.webauthn_origin }
  let(:fake_client)      { WebAuthn::FakeClient.new(fake_origin, encoding: false) }
  let(:fixed_challenge)  { SecureRandom.random_bytes(32) }
  let(:fake_credentials) { fake_client.create(challenge: fixed_challenge, user_verified: true) }
  let(:fake_assertion)   { fake_client.get(challenge: fixed_challenge, user_verified: true) }

  before do
    allow_any_instance_of(WebAuthn::PublicKeyCredential::CreationOptions).to receive(:raw_challenge).and_return(fixed_challenge)
    allow_any_instance_of(WebAuthn::PublicKeyCredential::RequestOptions).to receive(:raw_challenge).and_return(fixed_challenge)
  end

  it "allows a user to login" do
    # Visit the page where the user can create a post
    visit new_registrations_path

    # Fill in the form fields
    fill_in "Username", with: "John"
    fill_in "Nickname", with: "John's Security Key"

    stub_create(fake_credentials)

    # Submit the form
    click_on "Save Registration"

    # Expect to see the success message or be redirected to the home page
    expect(page).to have_content("Welcome#home")

    # Click the menu button by its ID
    # find_by_id("user-menu-button").click

    # Ensure the 'Sign Out' link is visible
    # expect(page).to have_css("a#user-menu-item-0", visible: true)

    # Click on the 'Sign Out' link
    # find("a#user-menu-item-0").click

    click_on "Sign Out"
    # # Using CSS selectors
    # find("a", text: "Sign Out").click
    # Using XPath (if you're comfortable with it)
    # find(:xpath, "//a[text()='Sign Out']").click

    # Visit the page where the user can create a post
    visit new_session_path

    # Fill in the form fields
    fill_in "Username", with: "John"

    stub_get(fake_assertion)

    # Submit the form
    # click_on "session-submit-button"
    click_on "Save Session"

    # Expect to see the success message or be redirected to the home page
    expect(page).to have_content("Welcome#home")
  end
end
