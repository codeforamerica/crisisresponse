require 'rails_helper'

RSpec.describe Person, type: :model do
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
  end

  describe "associations" do
    it { should have_many :safety_warnings }
  end

  describe "#display_name" do
    it "displays last name, first name" do
      person = build(:person, first_name: "John", last_name: "Doe")

      expect(person.display_name).to eq("Doe, John")
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

    def shorthand_for(person_attrs)
      build(:person, person_attrs).shorthand_description
    end
  end

  describe "#safety_warnings" do
    it "returns an empty array if there are no safety warnings" do
      person = build(:person)

      expect(person.safety_warnings).to be_empty
    end
  end
end
