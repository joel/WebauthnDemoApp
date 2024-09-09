# Source: https://github.com/rspec/rspec-rails/blob/6-1-maintenance/lib/generators/rspec/model/templates/model_spec.rb
require "rails_helper"

RSpec.describe Credential do
  it "has a valid factory" do
    expect(build(:credential)).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_presence_of(:public_key) }
    it { is_expected.to validate_presence_of(:nickname) }
    it { is_expected.to validate_presence_of(:sign_count) }
    it { is_expected.to validate_numericality_of(:sign_count).only_integer }
    it { is_expected.to validate_numericality_of(:sign_count).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:sign_count).is_less_than_or_equal_to((2**32) - 1) }
  end

  describe "indexes" do
    it { is_expected.to have_db_index(:external_id).unique }
  end

  describe "uninique attributes" do
    subject { create(:credential) }

    it { is_expected.to validate_uniqueness_of(:external_id) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end
end
