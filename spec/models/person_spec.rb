require "rails_helper"
require "shared/analytics_token"
require "shared/person_validations"

RSpec.describe Person, type: :model do
  it_should_behave_like "it has an analytics token"

  describe "associations" do
    it { should have_many(:response_plans) }
    it { should have_many(:aliases).dependent(:destroy) }
    it { should have_many(:images).dependent(:destroy) }
  end

  describe "validations" do
    it_should_behave_like "a validated person"
  end

  describe "#active_plan" do
    it "returns the most recent approved response plan" do
      person = create(:person)
      plans = [
        create(:response_plan, person: person, approved_at: 1.month.ago),
        create(:response_plan, person: person, approved_at: 1.week.ago),
        create(:response_plan, person: person, approved_at: nil, approver: nil),
      ]

      expect(person.active_plan).to eq(plans.second)
    end

    it "returns nil if there is no approved response plan" do
      person = create(:person)
      create(:response_plan, person: person, approved_at: nil, approver: nil)

      expect(person.active_plan).to eq(nil)
    end
  end

  describe "#date_of_birth=" do
    it "parses dates in mm-dd-yyyy format" do
      person = Person.new(date_of_birth: "01-30-1980")

      expect(person.date_of_birth).to eq(Date.new(1980, 1, 30))
    end

    it "parses empty strings" do
      person = Person.new(date_of_birth: "")

      expect(person.date_of_birth).to be_nil
    end

    it "parses nil" do
      person = Person.new(date_of_birth: nil)

      expect(person.date_of_birth).to be_nil
    end
  end

  describe "#display_name" do
    it "displays last name, first name, middle initial" do
      person = build(
        :person,
        first_name: "John",
        last_name: "Doe",
        middle_initial: "Q",
      )

      expect(person.display_name).to eq("Doe, John Q")
    end

    context "with a missing middle initial" do
      it "just displays first and last names" do
      person = build(
        :person,
        first_name: "John",
        last_name: "Doe",
        middle_initial: nil,
      )

      expect(person.display_name).to eq("Doe, John")
      end
    end
  end

  describe "#due_for_review?" do
    it "is false if the person is not visible" do
      person = create(:person, visible: false)

      expect(person).not_to be_due_for_review
    end

    it "is false if the person has been visible less than the threshold" do
      person = create(:person, visible: false)
      visibility = create(:visibility, person: person, created_at: after_threshold)

      expect(person).not_to be_due_for_review
    end

    it "is false if the person has been reviewed less than the threshold ago" do
      person = create(:person, visible: false, created_at: before_threshold)
      visibility = create(:visibility, person: person, created_at: before_threshold)
      review = create(:review, person: person, created_at: after_threshold)

      expect(person).not_to be_due_for_review
    end

    it "is false if the person's response plan has been updated recently" do
      person = create(:person, visible: false)
      visibility = create(:visibility, person: person, created_at: before_threshold)
      response_plan = create(
        :response_plan,
        :approved,
        person: person,
        created_at: after_threshold,
      )

      expect(person).not_to be_due_for_review
    end

    it "is true if the person has been visible longer than the threshold" do
      person = create(:person, visible: false, created_at: before_threshold)
      create(:visibility, person: person, created_at: before_threshold)

      expect(person).to be_due_for_review
    end

    it "is true if the person has not been reviewed within the threshold" do
      person = create(:person, visible: false, created_at: before_threshold)
      visibility = create(:visibility, person: person, created_at: before_threshold)
      review = create(:review, person: person, created_at: before_threshold)

      expect(person).to be_due_for_review
    end

    def after_threshold
      (threshold - 1).months.ago
    end

    def before_threshold
      (threshold + 1).months.ago
    end

    def threshold
      ENV.fetch("PROFILE_REVIEW_TIMEFRAME_IN_MONTHS").to_i
    end
  end

  describe "#incidents_since" do
    it "returns the number of incidents since a given time" do
      has_incidents = create(:person)
      _old = create(:incident, reported_at: 3.days.ago, person: has_incidents)
      recent = create(:incident, reported_at: 1.day.ago, person: has_incidents)

      has_no_incidents = build_stubbed(:person)

      expect(has_no_incidents.incidents_since(2.days.ago)).to eq([])
      expect(has_incidents.incidents_since(2.days.ago)).to eq([recent])
    end
  end

  describe "#profile_image_url" do
    context "when no image is uploaded" do
      it "returns a URL to the default profile image" do
        person = Person.new

        expect(person.profile_image_url).to eq("/default_profile.png")
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

    def shorthand_for(person_attrs)
      build(:person, person_attrs).shorthand_description
    end
  end

  describe "#visible?" do
    it "is true if there is an active visibility" do
      person = create(:visibility).person

      expect(person).to be_visible
    end

    it "is false if there are only removed visibilities" do
      person = create(:person, visible: false)
      create(:visibility, :removed, person: person)

      expect(person).not_to be_visible
    end

    it "is false if there are no visibilities" do
      person = create(:person)

      expect(person).to be_visible
    end
  end

end
