require "rails_helper"

describe ResponsePlanSearch do
  context "with no parameters" do
    it "returns all response plans" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new({}).close_matches

      expect(plans).to eq([response_plan])
    end
  end

  describe "searching by name" do
    it "does not return records whose names do not match" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Mary").close_matches

      expect(plans).to eq([])
    end

    it "returns records that match on first name" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "John").close_matches

      expect(plans).to eq([response_plan])
    end

    it "returns records that match on last name" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Doe").close_matches

      expect(plans).to eq([response_plan])
    end

    it "returns records that match on the full name" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "John Doe").close_matches

      expect(plans).to eq([response_plan])
    end

    it "returns records that match on the reversed name" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Doe John").close_matches

      expect(plans).to eq([response_plan])
    end

    pending "returns records that contain the searched name" do
      name = "Christopher Nolan"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Chris").close_matches

      expect(plans).to eq([response_plan])
    end

    it "returns records whose first names sound similar" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Jon").close_matches

      expect(plans).to eq([response_plan])
    end

    it "returns records whose last names sound similar" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Doh").close_matches

      expect(plans).to eq([response_plan])
    end

    it "returns records whose full names sound similar" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Jon Doh").close_matches

      expect(plans).to eq([response_plan])
    end

    it "returns records whose reversed full names sound similar" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Doh Jon").close_matches

      expect(plans).to eq([response_plan])
    end
  end

  describe "searching by date of birth" do
    it "does not return records whose dob does not match" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(date_of_birth: "2/3/86").close_matches

      expect(plans).to eq([])
    end

    it "parses dates in 'mm/dd/yy'" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(date_of_birth: "1/2/80").close_matches

      expect(plans).to eq([response_plan])
    end

    it "parses dates in 'mm-dd-yyyy'" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(date_of_birth: "1-2-1980").close_matches

      expect(plans).to eq([response_plan])
    end

    it "parses dates in 'mm-dd-yy'" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(date_of_birth: "1-2-80").close_matches

      expect(plans).to eq([response_plan])
    end

    it "parses dates in 'yyyy-mm-dd'" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(date_of_birth: "1980-1-2").close_matches

      expect(plans).to eq([response_plan])
    end

    it "returns records whose DOBs are a year earlier" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(date_of_birth: "1/2/81").close_matches

      expect(plans).to eq([response_plan])
    end

    it "returns records whose DOBs are a year later" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(date_of_birth: "1/2/79").close_matches

      expect(plans).to eq([response_plan])
    end

    it "returns records whose DOBs are within a year" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(date_of_birth: "5/2/80").close_matches

      expect(plans).to eq([response_plan])
    end
  end

  describe "searching by name and DOB" do
    it "returns exact matches for name and DOB" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Doe John", date_of_birth: "1/2/80").close_matches

      expect(plans).to eq([response_plan])
    end

    it "returns records whose name and DOB are slightly off" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Jon Doh", date_of_birth: "1/2/81").close_matches

      expect(plans).to eq([response_plan])
    end

    it "does not return records whose name matches, and DOB doesn't" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Jon Doh", date_of_birth: "1/2/85").close_matches

      expect(plans).to eq([])
    end

    it "does not return records whose DOB matches, and name doesn't" do
      name = "John Doe"
      dob = Date.new(1980, 01, 02)
      response_plan = create(:response_plan, name: name, date_of_birth: dob)

      plans = ResponsePlanSearch.new(name: "Mary", date_of_birth: "1/2/80").close_matches

      expect(plans).to eq([])
    end
  end
end
