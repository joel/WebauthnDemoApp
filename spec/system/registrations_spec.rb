# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registration", :authentication do
  it "allows a user to register" do
    # Visit the page where the user can create a post
    visit new_registrations_path

    # Fill in the form fields
    fill_in "Username", with: "John"
    fill_in "Nickname", with: "John's Security Key"

    # Submit the form
    click_on "Save Registration"

    # Expect to see the success message or be redirected to the home page
    expect(page).to have_content("Welcome#home")
  end
end
