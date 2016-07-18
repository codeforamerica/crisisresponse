require "rails_helper"

describe Search do
  describe "validations" do
    it "validates that dates are in a recognized format" do
      search = Search.new(date_of_birth: "foo")

      search.validate

      expect(search.errors[:date_of_birth]).
        to include("Ignored invalid date. Try 'mm-dd-yyyy'")
    end

    it "accepts empty dates" do
      search = Search.new(date_of_birth: "")

      search.validate

      expect(search.errors[:date_of_birth]).to be_empty
    end
  end

  describe "#active_filters" do
    it "returns the attributes have been searched for" do
      search = Search.new name: "Someone", hair_color: ["Black", "Brown"]

      expect(search.active_filters).to match_array([:name, :hair_color])
    end

    it "is false if nothing was searched for" do
      search = Search.new()

      expect(search).not_to be_active
    end
  end

  describe "#active?" do
    it "is true if any of the attributes have been searched for" do
      search = Search.new name: "Someone"

      expect(search).to be_active
    end

    it "is false if nothing was searched for" do
      search = Search.new()

      expect(search).not_to be_active
    end
  end

  describe "#close_matches" do
    context "with no parameters" do
      it "returns all response plans" do
        person = create(:person, name: "John Doe")

        matches = Search.new({}).close_matches

        expect(matches).to eq([person])
      end
    end

    describe "searching by name" do
      it "does not return records whose names do not match" do
        mismatch = create(:person, name: "John Doe")

        matches = Search.new(name: "Mary").close_matches

        expect(matches).to eq([])
      end

      it "returns records that match on first name" do
        person = create(:person, name: "John Doe")

        matches = Search.new(name: "John").close_matches

        expect(matches).to eq([person])
      end

      it "returns records that match on last name" do
        person = create(:person, name: "John Doe")

        matches = Search.new(name: "Doe").close_matches

        expect(matches).to eq([person])
      end

      it "returns records that match on the full name" do
        person = create(:person, name: "John Doe")

        matches = Search.new(name: "John Doe").close_matches

        expect(matches).to eq([person])
      end

      it "returns records that match on the reversed name" do
        person = create(:person, name: "John Doe")

        matches = Search.new(name: "Doe John").close_matches

        expect(matches).to eq([person])
      end

      pending "returns records that contain the searched name" do
        person = create(:person, name: "Christopher Nolan")

        matches = Search.new(name: "Chris").close_matches

        expect(matches).to eq([person])
      end

      it "returns records whose first names sound similar" do
        person = create(:person, name: "John Doe")

        matches = Search.new(name: "Jon").close_matches

        expect(matches).to eq([person])
      end

      it "returns records whose last names sound similar" do
        person = create(:person, name: "John Doe")

        matches = Search.new(name: "Doh").close_matches

        expect(matches).to eq([person])
      end

      it "returns records whose full names sound similar" do
        person = create(:person, name: "John Doe")

        matches = Search.new(name: "Jon Doh").close_matches

        expect(matches).to eq([person])
      end

      it "returns records whose reversed full names sound similar" do
        person = create(:person, name: "John Doe")

        matches = Search.new(name: "Doh Jon").close_matches

        expect(matches).to eq([person])
      end
    end

    describe "searching by date of birth" do
      pending "ignores dates in an unrecognized format" do
        match = create(:person)
        mismatch = create(:person, date_of_birth: Date.new(1978, 01, 02))

        matches = Search.new(date_of_birth: "foo").close_matches

        expect(matches).to eq([person])
      end

      it "parses dates in 'mm-dd-yyyy'" do
        match = create(:person, date_of_birth: Date.new(1980, 01, 02))
        mismatch = create(:person, date_of_birth: Date.new(1978, 01, 02))

        matches = Search.new(date_of_birth: "01-02-1980").close_matches

        expect(matches).to eq([match])
      end

      it "returns records whose DOBs are a year earlier" do
        match = create(:person, date_of_birth: Date.new(1980, 01, 02))

        matches = Search.new(date_of_birth: "01-02-1981").close_matches

        expect(matches).to eq([match])
      end

      it "returns records whose DOBs are a year later" do
        match = create(:person, date_of_birth: Date.new(1980, 01, 02))

        matches = Search.new(date_of_birth: "01-02-1979").close_matches

        expect(matches).to eq([match])
      end

      it "returns records whose DOBs are within a year" do
        match = create(:person, date_of_birth: Date.new(1980, 01, 02))

        matches = Search.new(date_of_birth: "05-02-1980").close_matches

        expect(matches).to eq([match])
      end
    end

    describe "searching by name and DOB" do
      it "returns exact matches for name and DOB" do
        dob = Date.new(1980, 01, 02)
        person = create(:person, name: "John Doe", date_of_birth: dob)

        matches = Search.new(name: "Doe John", date_of_birth: "01-02-1980").close_matches

        expect(matches).to eq([person])
      end

      it "returns records whose name and DOB are slightly off" do
        dob = Date.new(1980, 01, 02)
        person = create(:person, name: "John Doe", date_of_birth: dob)

        matches = Search.new(name: "Jon Doh", date_of_birth: "01-02-1981").close_matches

        expect(matches).to eq([person])
      end

      it "does not return records whose name matches, and DOB doesn't" do
        person = create(
          :person,
          name: "John Doe",
          date_of_birth: Date.new(1980, 01, 02),
        )

        matches = Search.new(name: "Jon Doh", date_of_birth: "01-02-1985").close_matches

        expect(matches).to eq([])
      end

      it "does not return records whose DOB matches, and name doesn't" do
        dob = Date.new(1980, 01, 02)
        mismatch = create(:person, name: "John Doe", date_of_birth: dob)

        matches = Search.new(name: "Mary", date_of_birth: "01-02-1980").close_matches

        expect(matches).to eq([])
      end
    end
  end
end
