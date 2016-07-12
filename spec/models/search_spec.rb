require "rails_helper"

describe Search do
  describe "validations" do
    it "validates that dates are in a recognized format" do
      search = Search.new(date_of_birth: "foo")

      search.validate

      expect(search.errors[:date_of_birth]).
        to include("Ignored invalid date. Try 'MM/DD/YY'")
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
        name = "John Doe"
        response_plan = create(:response_plan, name: name)

        plans = Search.new({}).close_matches

        expect(plans).to eq([response_plan])
      end
    end

    describe "searching by name" do
      it "does not return records whose names do not match" do
        name = "John Doe"
        response_plan = create(:response_plan, name: name)

        plans = Search.new(name: "Mary").close_matches

        expect(plans).to eq([])
      end

      it "returns records that match on first name" do
        name = "John Doe"
        response_plan = create(:response_plan, name: name)

        plans = Search.new(name: "John").close_matches

        expect(plans).to eq([response_plan])
      end

      it "returns records that match on last name" do
        name = "John Doe"
        response_plan = create(:response_plan, name: name)

        plans = Search.new(name: "Doe").close_matches

        expect(plans).to eq([response_plan])
      end

      it "returns records that match on the full name" do
        name = "John Doe"
        response_plan = create(:response_plan, name: name)

        plans = Search.new(name: "John Doe").close_matches

        expect(plans).to eq([response_plan])
      end

      it "returns records that match on the reversed name" do
        name = "John Doe"
        response_plan = create(:response_plan, name: name)

        plans = Search.new(name: "Doe John").close_matches

        expect(plans).to eq([response_plan])
      end

      pending "returns records that contain the searched name" do
        name = "Christopher Nolan"
        response_plan = create(:response_plan, name: name)

        plans = Search.new(name: "Chris").close_matches

        expect(plans).to eq([response_plan])
      end

      it "returns records whose first names sound similar" do
        name = "John Doe"
        response_plan = create(:response_plan, name: name)

        plans = Search.new(name: "Jon").close_matches

        expect(plans).to eq([response_plan])
      end

      it "returns records whose last names sound similar" do
        name = "John Doe"
        response_plan = create(:response_plan, name: name)

        plans = Search.new(name: "Doh").close_matches

        expect(plans).to eq([response_plan])
      end

      it "returns records whose full names sound similar" do
        name = "John Doe"
        response_plan = create(:response_plan, name: name)

        plans = Search.new(name: "Jon Doh").close_matches

        expect(plans).to eq([response_plan])
      end

      it "returns records whose reversed full names sound similar" do
        name = "John Doe"
        response_plan = create(:response_plan, name: name)

        plans = Search.new(name: "Doh Jon").close_matches

        expect(plans).to eq([response_plan])
      end
    end

    describe "searching by date of birth" do
      it "parses dates in 'mm/dd/yy'" do
        match = create(:response_plan, date_of_birth: Date.new(1980, 01, 02))
        _mismatch = create(:response_plan, date_of_birth: Date.new(1978, 01, 02))

        plans = Search.new(date_of_birth: "1/2/80").close_matches

        expect(plans).to eq([match])
      end

      it "parses dates in 'mm/dd/yyyy'" do
        match = create(:response_plan, date_of_birth: Date.new(1980, 01, 02))
        _mismatch = create(:response_plan, date_of_birth: Date.new(1978, 01, 02))

        plans = Search.new(date_of_birth: "1/2/1980").close_matches

        expect(plans).to eq([match])
      end

      it "parses dates in 'mmddyy'" do
        match = create(:response_plan, date_of_birth: Date.new(1980, 01, 02))
        _mismatch = create(:response_plan, date_of_birth: Date.new(1978, 01, 02))

        plans = Search.new(date_of_birth: "010280").close_matches

        expect(plans).to eq([match])
      end

      it "parses dates in 'mmddyyyy'" do
        match = create(:response_plan, date_of_birth: Date.new(1980, 01, 02))
        _mismatch = create(:response_plan, date_of_birth: Date.new(1978, 01, 02))

        plans = Search.new(date_of_birth: "01021980").close_matches

        expect(plans).to eq([match])
      end

      pending "ignores dates in an unrecognized format" do
        plan = create(:response_plan)
        _mismatch = create(:response_plan, date_of_birth: Date.new(1978, 01, 02))

        plans = Search.new(date_of_birth: "foo").close_matches

        expect(plans).to eq([plan])
      end

      it "parses dates in 'mm-dd-yyyy'" do
        match = create(:response_plan, date_of_birth: Date.new(1980, 01, 02))
        _mismatch = create(:response_plan, date_of_birth: Date.new(1978, 01, 02))

        plans = Search.new(date_of_birth: "1-2-1980").close_matches

        expect(plans).to eq([match])
      end

      it "parses dates in 'mm-dd-yy'" do
        match = create(:response_plan, date_of_birth: Date.new(1980, 01, 02))
        _mismatch = create(:response_plan, date_of_birth: Date.new(1978, 01, 02))

        plans = Search.new(date_of_birth: "1-2-80").close_matches

        expect(plans).to eq([match])
      end

      it "parses dates in 'yyyy-mm-dd'" do
        match = create(:response_plan, date_of_birth: Date.new(1980, 01, 02))
        _mismatch = create(:response_plan, date_of_birth: Date.new(1978, 01, 02))

        plans = Search.new(date_of_birth: "1980-1-2").close_matches

        expect(plans).to eq([match])
      end

      it "returns records whose DOBs are a year earlier" do
        match = create(:response_plan, date_of_birth: Date.new(1980, 01, 02))

        plans = Search.new(date_of_birth: "1/2/81").close_matches

        expect(plans).to eq([match])
      end

      it "returns records whose DOBs are a year later" do
        match = create(:response_plan, date_of_birth: Date.new(1980, 01, 02))

        plans = Search.new(date_of_birth: "1/2/79").close_matches

        expect(plans).to eq([match])
      end

      it "returns records whose DOBs are within a year" do
        match = create(:response_plan, date_of_birth: Date.new(1980, 01, 02))

        plans = Search.new(date_of_birth: "5/2/80").close_matches

        expect(plans).to eq([match])
      end
    end

    describe "searching by name and DOB" do
      it "returns exact matches for name and DOB" do
        name = "John Doe"
        dob = Date.new(1980, 01, 02)
        response_plan = create(:response_plan, name: name, date_of_birth: dob)

        plans = Search.new(name: "Doe John", date_of_birth: "1/2/80").close_matches

        expect(plans).to eq([response_plan])
      end

      it "returns records whose name and DOB are slightly off" do
        name = "John Doe"
        dob = Date.new(1980, 01, 02)
        response_plan = create(:response_plan, name: name, date_of_birth: dob)

        plans = Search.new(name: "Jon Doh", date_of_birth: "1/2/81").close_matches

        expect(plans).to eq([response_plan])
      end

      it "does not return records whose name matches, and DOB doesn't" do
        name = "John Doe"
        dob = Date.new(1980, 01, 02)
        response_plan = create(:response_plan, name: name, date_of_birth: dob)

        plans = Search.new(name: "Jon Doh", date_of_birth: "1/2/85").close_matches

        expect(plans).to eq([])
      end

      it "does not return records whose DOB matches, and name doesn't" do
        name = "John Doe"
        dob = Date.new(1980, 01, 02)
        response_plan = create(:response_plan, name: name, date_of_birth: dob)

        plans = Search.new(name: "Mary", date_of_birth: "1/2/80").close_matches

        expect(plans).to eq([])
      end
    end
  end
end
