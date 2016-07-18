require "rails_helper"
require "shared/analytics_token"

RSpec.describe ResponsePlan, type: :model do
  describe "validations" do
    it "does not allow the same officer to both author and approve" do
      officer = build(:officer)
      response_plan = build(:response_plan, author: officer, approver: officer)

      expect(response_plan).not_to be_valid
      expect(response_plan.errors[:approver]).
        to include("can not be the person who authored the plan")
    end

    it "does not allow approval without a timestamp" do
      officer = build(:officer)
      response_plan = build(:response_plan, approver: officer)
      response_plan.approved_at = nil

      expect(response_plan).not_to be_valid
      expect(response_plan.errors[:approved_at]).
        to include("must be set in order to be approved")
    end

    it "does not allow approval without an approver" do
      response_plan = build(:response_plan, approved_at: Time.current, approver: nil)

      expect(response_plan).not_to be_valid
      expect(response_plan.errors[:approved_at]).
        to include("cannot be set without an approver")
    end
  end

  describe "associations" do
    it { should have_many(:safety_warnings).dependent(:destroy) }
    it { should have_many(:aliases).dependent(:destroy) }
    it { should have_many(:contacts).dependent(:destroy) }
    it { should have_many(:response_strategies).dependent(:destroy) }
    it { should belong_to(:author) }
    it { should belong_to(:approver) }
    it { should belong_to(:person) }
  end

  describe "#alias_list=" do
    it "destroys the associated alias object when it gets overwritten" do
      plan = create(:response_plan, alias_list: ["foo"])

      plan.alias_list = ["bar"]
      plan.save

      expect(Alias.find_by(name: "foo")).to be_nil
      expect(Alias.find_by(name: "bar")).to be_persisted
    end
  end

  describe "#approved?" do
    it "returns true if both `approved_at` and `approver` are non-nil" do
      officer = build(:officer)
      response_plan = build_stubbed(
        :response_plan,
        approved_at: Time.current,
        approver: officer,
      )

      expect(response_plan).to be_approved
    end

    it "returns false if `approved_at` is nil" do
      officer = build(:officer)
      response_plan = build_stubbed(
        :response_plan,
        approved_at: nil,
        approver: officer,
      )

      expect(response_plan).not_to be_approved
    end

    it "returns false if `approver` is nil" do
      officer = build(:officer)
      response_plan = build_stubbed(
        :response_plan,
        approved_at: Time.current,
        approver: nil,
      )

      expect(response_plan).not_to be_approved
    end

    it "returns false if the plan has been edited since it was approved" do
      officer = build(:officer)
      response_plan = build_stubbed(
        :response_plan,
        approved_at: 1.day.ago,
        approver: officer,
        updated_at: Time.current,
      )

      expect(response_plan).not_to be_approved
    end
  end

  describe "#approver=" do
    it "updates the `approved_at` timestamp" do
      officer = build(:officer)
      response_plan = build_stubbed(:response_plan, approved_at: nil, approver: nil)

      Timecop.freeze do
        response_plan.approver = officer

        expect(response_plan.approved_at).to eq(Time.current)
      end
    end

    it "sets `approved_at` to nil when approver is nil" do
      officer = build(:officer)
      response_plan = build_stubbed(
        :response_plan,
        approved_at: Time.current,
        approver: officer,
      )

      response_plan.approver = nil

      expect(response_plan.approved_at).to eq(nil)
    end
  end

  describe "#profile_image_url" do
    context "when no image is uploaded" do
      it "returns a URL to the default profile image" do
        response_plan = ResponsePlan.new

        expect(response_plan.profile_image_url).to eq("/assets/default_image.png")
      end
    end
  end

  describe "#safety_warnings" do
    it "returns an empty array if there are no safety warnings" do
      response_plan = build(:response_plan)

      expect(response_plan.safety_warnings).to be_empty
    end
  end
end
