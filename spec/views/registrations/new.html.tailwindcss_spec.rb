require "rails_helper"

RSpec.describe "registrations/new" do
  before do
    username = FFaker::Name.first_name
    assign(:registration, OpenStruct.new(username:, nickname: "#{username}'s Security Key"))
  end

  it "renders new registration form" do
    render

    assert_select "form[action=?][method=?]", registrations_path, "post" do
      assert_select "input[name=?]", "registration[username]"
      assert_select "input[name=?]", "registration[nickname]"
    end
  end
end
