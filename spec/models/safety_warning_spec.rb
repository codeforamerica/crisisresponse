require 'rails_helper'

RSpec.describe SafetyWarning, type: :model do
  describe "validations" do
    it { should validate_inclusion_of(:category).
         in_array(SafetyWarning::CATEGORIES) }
    it { should validate_presence_of :category }
    it { should validate_presence_of :description }
    it { should validate_presence_of :response_plan }

    it "must be marked threat or physical if it's p1 or p2" do
      threat = build(:safety_warning, category: :assaultive_law, physical_or_threat: :threat)
      assault = build(:safety_warning, category: :assaultive_public, physical_or_threat: :physical)
      other = build(:safety_warning, category: :assaultive_law, physical_or_threat: :verbal)
      none = build(:safety_warning, category: :assaultive_public, physical_or_threat: nil)

      expect(threat).to be_valid
      expect(assault).to be_valid
      expect(other).not_to be_valid
      expect(none).not_to be_valid
    end

    it "cannot be marked threat or physical if it's p3 or p4" do
      threat = build(:safety_warning, category: :weapon, physical_or_threat: :threat)
      assault = build(:safety_warning, category: :chemical, physical_or_threat: :physical)
      other = build(:safety_warning, category: :weapon, physical_or_threat: :verbal)
      none = build(:safety_warning, category: :chemical, physical_or_threat: nil)

      expect(threat).not_to be_valid
      expect(assault).not_to be_valid
      expect(other).not_to be_valid
      expect(none).to be_valid
    end
  end

  describe "#physical?" do
    it "returns true if the concern has a physical component" do
      concern = build(:safety_warning, category: :assaultive_law, physical_or_threat: :physical)

      expect(concern).to be_physical
    end

    it "returns false if the concern does not have a physical component" do
      concern = build(:safety_warning, category: :assaultive_law, physical_or_threat: :threat)

      expect(concern).not_to be_physical
    end
  end

  describe "#threat?" do
    it "returns true if the concern has a threat component" do
      concern = build(:safety_warning, category: :assaultive_law, physical_or_threat: :threat)

      expect(concern).to be_threat
    end

    it "returns false if the concern does not have a threat component" do
      concern = build(:safety_warning, category: :assaultive_law, physical_or_threat: :physical)

      expect(concern).not_to be_threat
    end
  end
end
