# Source: https://github.com/rspec/rspec-rails/blob/6-1-maintenance/lib/generators/rspec/model/templates/model_spec.rb
require "rails_helper"

RSpec.describe User do
  describe "associations" do
    it { is_expected.to have_many(:credentials).dependent(:destroy) }
    it { is_expected.to have_many(:posts).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
