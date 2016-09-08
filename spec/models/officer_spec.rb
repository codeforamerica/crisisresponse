require "rails_helper"
require "shared/analytics_token"

RSpec.describe Officer, type: :model do
  it_should_behave_like "it has an analytics token"

  describe "associations" do
    it { should have_many(:authored_response_plans).dependent(:destroy) }
    it { should have_many(:approved_response_plans).dependent(:destroy) }
  end

  describe "#validations" do
    it { is_expected.to allow_value(:admin).for(:role) }
    it { is_expected.to allow_value(:normal).for(:role) }
    it { is_expected.not_to allow_value(:other).for(:role) }
  end

  describe "#admin?" do
    it "is true if officer's role is `admin`" do
      admin = build_stubbed(:officer, role: "admin")

      expect(admin).to be_admin
    end

    it "is false if the officer's role is `normal`" do
      non_admin = build_stubbed(:officer, role: "normal")

      expect(non_admin).not_to be_admin
    end
  end
end
