require "rails_helper"
require "shared/analytics_token"

RSpec.describe Officer, type: :model do
  it_should_behave_like "it has an analytics token"

  describe "associations" do
    it { should have_many(:authored_response_plans).dependent(:destroy) }
    it { should have_many(:approved_response_plans).dependent(:destroy) }
  end

  describe "#admin?" do
    it "is true if officer's username is in the ADMIN_USERNAMES env variable" do
      allow(ENV).to receive(:fetch).
        with("ADMIN_USERNAMES").
        and_return("foo,bar")

      admin = build(:officer, username: "foo")
      non_admin = build(:officer, username: "other")

      expect(admin).to be_admin
      expect(non_admin).not_to be_admin
    end

    it "can handle quotes in the env variable" do
      allow(ENV).to receive(:fetch).
        with("ADMIN_USERNAMES").
        and_return('"foo,bar"')

      admin = build(:officer, username: "foo")
      non_admin = build(:officer, username: "other")

      expect(admin).to be_admin
      expect(non_admin).not_to be_admin
    end
  end
end
