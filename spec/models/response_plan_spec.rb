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
    it { should have_many(:contacts).dependent(:destroy) }
    it { should have_many(:response_strategies).dependent(:destroy) }
    it { should belong_to(:author) }
    it { should belong_to(:approver) }
    it { should belong_to(:person) }
  end

  describe ".drafts" do
    it "returns response plans that have not been submitted for approval" do
      draft = create(:response_plan, :draft)
      create(:response_plan, :submission)
      create(:response_plan, :approved)

      expect(ResponsePlan.drafts).to eq([draft])
    end
  end

  describe ".submitted" do
    it "returns response plans that have not been submitted for approval" do
      create(:response_plan, :draft)
      submission = create(:response_plan, :submission)
      create(:response_plan, :approved)

      expect(ResponsePlan.submitted).to eq([submission])
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

  describe "#draft?" do
    it "is true if the plan has not been submitted for approval or approved" do
      plan = build_stubbed(
        :response_plan,
        approved_at: nil,
        approver: nil,
        submitted_for_approval_at: nil,
      )

      expect(plan).to be_draft
    end

    it "is false if the plan has been submitted and not approved" do
      plan = build_stubbed(
        :response_plan,
        approved_at: nil,
        approver: nil,
        submitted_for_approval_at: 1.minute.ago,
      )

      expect(plan).not_to be_draft
    end

    it "is false if the plan has been approved" do
      plan = build_stubbed(
        :response_plan,
        approved_at: 1.second.ago,
        approver: build_stubbed(:officer),
        submitted_for_approval_at: 1.minute.ago,
      )

      expect(plan).not_to be_draft
    end
  end

  describe "#submitted?" do
    it "is true if the plan has been submitted for approval and not approved" do
      plan = build_stubbed(
        :response_plan,
        approved_at: nil,
        approver: nil,
        submitted_for_approval_at: 1.minute.ago,
      )

      expect(plan).to be_submitted
    end

    it "is false if the plan is still a draft" do
      plan = build_stubbed(
        :response_plan,
        approved_at: nil,
        approver: nil,
        submitted_for_approval_at: nil,
      )

      expect(plan).not_to be_submitted
    end

    it "is false if the plan has been approved" do
      plan = build_stubbed(
        :response_plan,
        approved_at: 1.second.ago,
        approver: build_stubbed(:officer),
        submitted_for_approval_at: 1.minute.ago,
      )

      expect(plan).not_to be_submitted
    end
  end
end
