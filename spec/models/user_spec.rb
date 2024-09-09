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

  describe "callbacks" do
    describe "after_initialize" do
      it "sets the webauthn_id" do
        user = described_class.new
        expect(user.webauthn_id).to be_present
      end
    end
  end

  describe "#can_delete_credentials?" do
    it "returns true if the user has more than one credential" do
      user = described_class.new
      user.credentials.build
      user.credentials.build
      expect(user.can_delete_credentials?).to be true
    end

    it "returns false if the user has one credential" do
      user = described_class.new
      user.credentials.build
      expect(user.can_delete_credentials?).to be false
    end
  end
end
