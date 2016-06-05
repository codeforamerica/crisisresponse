require 'rails_helper'

RSpec.describe ResponsePlan, type: :model do
  describe "validations" do
    it { should allow_value("Female").for(:sex) }
    it { should allow_value("Male").for(:sex) }
    it { should allow_value(nil).for(:sex) }
    it { should_not allow_value("FEMALE").for(:sex) }
    it { should_not allow_value("M").for(:sex) }

    it { should allow_value("AFRICAN AMERICAN/BLACK").for(:race) }
    it { should allow_value("AMERICAN INDIAN/ALASKAN NATIVE").for(:race) }
    it { should allow_value("ASIAN (ALL)/PACIFIC ISLANDER").for(:race) }
    it { should allow_value("UNKNOWN").for(:race) }
    it { should allow_value("WHITE").for(:race) }
    it { should allow_value(nil).for(:race) }
    it { should_not allow_value("BLACK").for(:race) }
    it { should_not allow_value("W").for(:race) }
    it { should_not allow_value("White").for(:race) }

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
  end

  describe "#aliases=" do
    it "destroys the associated alias object when it gets overwritten" do
      plan = create(:response_plan, aliases: ["foo"])

      plan.aliases = ["bar"]
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

  describe "#display_name" do
    it "displays last name, first name" do
      response_plan = build(:response_plan, first_name: "John", last_name: "Doe")

      expect(response_plan.display_name).to eq("Doe, John")
    end
  end

  describe "#image_url" do
    context "when no image is uploaded" do
      it "returns a URL to the default profile image" do
        response_plan = ResponsePlan.new

        expect(response_plan.image_url).to eq("/assets/default_image.png")
      end
    end
  end

  describe "#shorthand_description" do
    it "starts with a letter representing race" do
      expect(shorthand_for(race: "AFRICAN AMERICAN/BLACK")).to start_with("B")
      expect(shorthand_for(race: "AMERICAN INDIAN/ALASKAN NATIVE")).to start_with("I")
      expect(shorthand_for(race: "ASIAN (ALL)/PACIFIC ISLANDER")).to start_with("A")
      expect(shorthand_for(race: "UNKNOWN")).to start_with("U")
      expect(shorthand_for(race: "WHITE")).to start_with("W")
    end

    it "has a letter for gender in the second position" do
      expect(shorthand_for(sex: "Male")[1]).to eq("M")
      expect(shorthand_for(sex: "Female")[1]).to eq("F")
    end

    it "uses a character for other gender"

    it "Formats the height in feet and inches" do
      expect(shorthand_for(height_in_inches: 70)).to include("5'10\"")
    end

    it "includes the weight in pounds" do
      expect(shorthand_for(weight_in_pounds: 180)).to include("180 lb")
    end

    it "gracefully handles missing information" do
      expect(shorthand_for(height_in_inches: nil).chars.count("–")).to eq(1)
      expect(shorthand_for(weight_in_pounds: nil).chars.count("–")).to eq(1)
      expect(shorthand_for(height_in_inches: nil, weight_in_pounds: nil)).
        not_to include("–")
    end

    def shorthand_for(response_plan_attrs)
      build(:response_plan, response_plan_attrs).shorthand_description
    end
  end

  describe "#safety_warnings" do
    it "returns an empty array if there are no safety warnings" do
      response_plan = build(:response_plan)

      expect(response_plan.safety_warnings).to be_empty
    end
  end
end
