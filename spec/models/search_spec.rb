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

      it "returns records that match on alias" do
        person = create(:person, name: "Foo Bar")
        create(:alias, person: person, name: "Buddy")

        matches = Search.new(name: "Bud").close_matches

        expect(matches).to eq([person])
      end

      it "uses equivalent fuzzy matching on aliases and proper names" do
        a = create(:person, first_name: "Christopher")
        b = create(:person, first_name: "Kristina")

        matches = Search.new(name: "Kris").close_matches

        expect(matches).to match_array([b])
        Person.destroy_all

        a = create(:alias, name: "Christopher").person
        b = create(:alias, name: "Kristina").person

        matches = Search.new(name: "Kris").close_matches
        expect(matches).to match_array([b])
      end

      it "returns records that match on the reversed name" do
        person = create(:person, name: "John Doe")

        matches = Search.new(name: "Doe John").close_matches

        expect(matches).to eq([person])
      end

      it "returns records that contain the searched name" do
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

      it "returns results with names stored in RMS::Person record" do
        people = build_list(:person, 3, first_name: nil, last_name: nil)
        people.each { |p| p.save!(validate: false) }
        first_name_match = create(:rms_person, person: people[0], first_name: "John", last_name: "Doe")
        last_name_match = create(:rms_person, person: people[1], first_name: "Doe", last_name: "John")
        _mismatch = create(:rms_person, person: people[2], first_name: "Foo", last_name: "Bar")

        matches = Search.new(name: "John").close_matches

        expect(matches).to match_array([first_name_match.person, last_name_match.person])
      end
    end

    describe "searching by date of birth" do
      it "ignores dates in an unrecognized format" do
        match = create(:person, date_of_birth: Date.new(1978, 01, 02))

        matches = Search.new(date_of_birth: "foo").close_matches

        expect(matches).to eq([match])
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

      it "returns results with date of birth stored in an RMS::Person record" do
        people = build_list(:person, 2, date_of_birth: nil)
        people.each { |p| p.save!(validate: false) }
        match = create(:rms_person, person: people[0], date_of_birth: 20.years.ago)
        _mismatch = create(:rms_person, person: people[1], date_of_birth: 10.years.ago)

        dob = I18n.l(20.years.ago.to_date)
        matches = Search.new(date_of_birth: dob).close_matches

        expect(matches).to match_array([match.person])
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

    describe "searching by height" do
      it "returns results when attributes are pulled from RMS" do
        match = create(:person, height_in_inches: nil)
        create(:rms_person, person: match, height_in_inches: 78)
        mismatch = create(:person, height_in_inches: nil)
        create(:rms_person, person: mismatch, height_in_inches: 50)

        search = Search.new(height_feet: 6, height_inches: 6)

        expect(search.close_matches).to eq([match])
      end

      it "returns results when attributes from RMS are overridden by Person" do
        person = create(:person, height_in_inches: 78)
        _associated = create(:rms_person, height_in_inches: 50)

        search = Search.new(height_feet: 6, height_inches: 6)

        expect(search.close_matches).to eq([person])
      end

      it "does not return results for the attributes that have been overridden" do
        person = create(:person, height_in_inches: 50)
        create(:rms_person, height_in_inches: 78, person: person)

        search = Search.new(height_feet: 6, height_inches: 6)

        expect(search.close_matches).to eq([])
      end

      it "returns results when there is no backing RMS record" do
        match = create(:person, height_in_inches: 78)
        _mismatch = create(:person, height_in_inches: 50)

        search = Search.new(height_feet: 6, height_inches: 6)

        expect(search.close_matches).to eq([match])
      end
    end

    describe "searching by weight" do
      it "returns results when attributes are pulled from RMS" do
        match = create(:person, weight_in_pounds: nil)
        create(:rms_person, person: match, weight_in_pounds: 200)
        mismatch = create(:person, weight_in_pounds: nil)
        create(:rms_person, person: mismatch, weight_in_pounds: 100)

        search = Search.new(weight_in_pounds: 200)

        expect(search.close_matches).to eq([match])
      end

      it "returns results when attributes from RMS are overridden by Person" do
        person = create(:person, weight_in_pounds: 200)
        _associated = create(:rms_person, person: person, weight_in_pounds: 100)

        search = Search.new(weight_in_pounds: 200)

        expect(search.close_matches).to eq([person])
      end

      it "does not return results for the attributes that have been overridden" do
        person = create(:person, weight_in_pounds: 100)
        create(:rms_person, weight_in_pounds: 200, person: person)

        search = Search.new(weight_in_pounds: 200)

        expect(search.close_matches).to eq([])
      end

      it "returns results when there is no backing RMS record" do
        match = create(:person, weight_in_pounds: 200)
        _mismatch = create(:person, weight_in_pounds: 100)

        search = Search.new(weight_in_pounds: 200)

        expect(search.close_matches).to eq([match])
      end
    end

    describe "searching by sex" do
      it "returns results when attributes are pulled from RMS" do
        match = create(:person, sex: nil)
        create(:rms_person, person: match, sex: "Male")
        mismatch = create(:person, sex: nil)
        create(:rms_person, person: mismatch, sex: "Female")

        search = Search.new(sex: "Male")

        expect(search.close_matches).to eq([match])
      end

      it "returns results when attributes from RMS are overridden by Person" do
        person = create(:person, sex: "Male")
        create(:rms_person, person: person, sex: "Female")

        search = Search.new(sex: "Male")

        matches = search.close_matches
        expect(matches).to eq([person])
      end

      it "does not return results for the attributes that have been overridden" do
        person = create(:person, sex: "Female")
        create(:rms_person, sex: "Male", person: person)

        search = Search.new(sex: "Male")

        expect(search.close_matches).to eq([])
      end

      it "returns results when there is no backing RMS record" do
        match = create(:person, sex: "Male")
        _mismatch = create(:person, sex: "Female")

        search = Search.new(sex: "Male")

        expect(search.close_matches).to eq([match])
      end
    end

    describe "searching by race" do
      it "returns results when attributes are pulled from RMS" do
        match = create(:person, race: nil)
        create(:rms_person, person: match, race: "WHITE")
        mismatch = create(:person, race: nil)
        create(:rms_person, person: mismatch, race: "UNKNOWN")

        search = Search.new(race: "WHITE")

        expect(search.close_matches).to eq([match])
      end

      it "returns results when attributes from RMS are overridden by Person" do
        person = create(:person, race: "WHITE")
        _associated = create(:rms_person, race: "UNKNOWN")

        search = Search.new(race: "WHITE")

        expect(search.close_matches).to eq([person])
      end

      it "does not return results for the attributes that have been overridden" do
        person = create(:person, race: "UNKNOWN")
        create(:rms_person, race: "WHITE", person: person)

        search = Search.new(race: "WHITE")

        expect(search.close_matches).to eq([])
      end

      it "returns results when there is no backing RMS record" do
        match = create(:person, race: "WHITE")
        _mismatch = create(:person, race: "UNKNOWN")

        search = Search.new(race: "WHITE")

        expect(search.close_matches).to eq([match])
      end
    end

    describe "searching by hair_color" do
      it "returns results when attributes are pulled from RMS" do
        match = create(:person, hair_color: nil)
        create(:rms_person, person: match, hair_color: :black)
        mismatch = create(:person, hair_color: nil)
        create(:rms_person, person: mismatch, hair_color: :brown)

        search = Search.new(hair_color: :black)

        expect(search.close_matches).to eq([match])
      end

      it "returns results when attributes from RMS are overridden by Person" do
        person = create(:person, hair_color: :black)
        _associated = create(:rms_person, person: person, hair_color: :brown)

        search = Search.new(hair_color: :black)

        expect(search.close_matches).to eq([person])
      end

      it "does not return results for the attributes that have been overridden" do
        person = create(:person, hair_color: :brown)
        create(:rms_person, hair_color: :black, person: person)

        search = Search.new(hair_color: :black)

        expect(search.close_matches).to eq([])
      end

      it "returns results when there is no backing RMS record" do
        match = create(:person, hair_color: :black)
        _mismatch = create(:person, hair_color: :brown)

        search = Search.new(hair_color: :black)

        expect(search.close_matches).to eq([match])
      end
    end

    describe "searching by eye_color" do
      it "returns results when attributes are pulled from RMS" do
        match = create(:person, eye_color: nil)
        create(:rms_person, person: match, eye_color: :blue)
        mismatch = create(:person, eye_color: nil)
        create(:rms_person, person: mismatch, eye_color: :black)

        search = Search.new(eye_color: :blue)

        expect(search.close_matches).to eq([match])
      end

      it "returns results when attributes from RMS are overridden by Person" do
        person = create(:person, eye_color: :blue)
        create(:rms_person, person: person, eye_color: :black)

        search = Search.new(eye_color: :blue)

        expect(search.close_matches).to eq([person])
      end

      it "does not return results for the attributes that have been overridden" do
        person = create(:person, eye_color: :black)
        create(:rms_person, eye_color: :blue, person: person)

        search = Search.new(eye_color: :blue)

        expect(search.close_matches).to eq([])
      end

      it "returns results when there is no backing RMS record" do
        match = create(:person, eye_color: :blue)
        _mismatch = create(:person, eye_color: :black)

        search = Search.new(eye_color: :blue)

        expect(search.close_matches).to eq([match])
      end

      describe "searching by one ranged value and one list value" do
        it "returns matches" do
          match = create(:person, eye_color: :blue, weight_in_pounds: 200)
          _mismatch = create(:person, eye_color: :green, weight_in_pounds: 200)

          search = Search.new(eye_color: :blue, weight_in_pounds: 200)

          expect(search.close_matches).to eq([match])
        end
      end
    end
  end
end
