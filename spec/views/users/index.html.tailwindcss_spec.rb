require "rails_helper"

RSpec.describe "users/index" do
  before do
    assign(:users, [
             create(:user, name: "Name 1"),
             create(:user, name: "Name 2")
           ])
  end

  it "renders a list of users" do
    render
    cell_selector = "div>p"
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
  end
end
