require "rms_person_parser"

describe RMSPersonParser do
  describe "#date_of_birth" do
    it "parses the date of birth" do
      parser = RMSPersonParser.new("DOB" => Time.new(1975, 1, 2))

      expect(parser.date_of_birth).to eq(Date.new(1975, 1, 2))
    end

    it "handles nil" do
      parser = RMSPersonParser.new("DOB" => nil)

      expect(parser.date_of_birth).to eq(nil)
    end
  end

  describe "#eye_color" do
    it "parses eye color into the appropriate format" do
      expect(RMSPersonParser.new("EYE_COLOR" => "BLK").eye_color).to eq("black")
      expect(RMSPersonParser.new("EYE_COLOR" => "BLU").eye_color).to eq("blue")
      expect(RMSPersonParser.new("EYE_COLOR" => "BRO").eye_color).to eq("brown")
      expect(RMSPersonParser.new("EYE_COLOR" => "GRN").eye_color).to eq("green")
      expect(RMSPersonParser.new("EYE_COLOR" => "GRY").eye_color).to eq("gray")
      expect(RMSPersonParser.new("EYE_COLOR" => "HAZ").eye_color).to eq("hazel")
      expect(RMSPersonParser.new("EYE_COLOR" => "MAR").eye_color).to eq("maroon")
      expect(RMSPersonParser.new("EYE_COLOR" => "MUL").eye_color).to eq("multicolored")
      expect(RMSPersonParser.new("EYE_COLOR" => "PNK").eye_color).to eq("pink")
      expect(RMSPersonParser.new("EYE_COLOR" => "XXX").eye_color).to eq("unknown")
      expect(RMSPersonParser.new("EYE_COLOR" => nil).eye_color).to eq("unknown")

      # For these eye color codes, we don't know what they translate into.
      # If we learn, we should update these tests and the code to match.
      # The next import will correct those records in our database.
      expect(RMSPersonParser.new("EYE_COLOR" => "B").eye_color).to eq("unknown")
      expect(RMSPersonParser.new("EYE_COLOR" => "BKL").eye_color).to eq("unknown")
      expect(RMSPersonParser.new("EYE_COLOR" => "BRN").eye_color).to eq("unknown")
      expect(RMSPersonParser.new("EYE_COLOR" => "FRN").eye_color).to eq("unknown")
      expect(RMSPersonParser.new("EYE_COLOR" => "HZL").eye_color).to eq("unknown")
      expect(RMSPersonParser.new("EYE_COLOR" => "RO").eye_color).to eq("unknown")
      expect(RMSPersonParser.new("EYE_COLOR" => "WHI").eye_color).to eq("unknown")
    end
  end

  describe "#hair_color" do
    it "parses hair color into the appropriate format" do
      # These colors, we've translated based on their similarity to the eye colors.
      expect(RMSPersonParser.new("HAIR_COLOR" => "BLK").hair_color).to eq("black")
      expect(RMSPersonParser.new("HAIR_COLOR" => "BLU").hair_color).to eq("blue")
      expect(RMSPersonParser.new("HAIR_COLOR" => "BRO").hair_color).to eq("brown")
      expect(RMSPersonParser.new("HAIR_COLOR" => "GRN").hair_color).to eq("green")
      expect(RMSPersonParser.new("HAIR_COLOR" => "GRY").hair_color).to eq("gray")
      expect(RMSPersonParser.new("HAIR_COLOR" => "HAZ").hair_color).to eq("hazel")
      expect(RMSPersonParser.new("HAIR_COLOR" => "MAR").hair_color).to eq("maroon")
      expect(RMSPersonParser.new("HAIR_COLOR" => "MUL").hair_color).to eq("multicolored")
      expect(RMSPersonParser.new("HAIR_COLOR" => "PNK").hair_color).to eq("pink")
      expect(RMSPersonParser.new("HAIR_COLOR" => "XXX").hair_color).to eq("unknown")
      expect(RMSPersonParser.new("HAIR_COLOR" => nil).hair_color).to eq("unknown")

      # These colors, we can make a pretty good guess about the translations.
      expect(RMSPersonParser.new("HAIR_COLOR" => "BLN").hair_color).to eq("blonde")
      expect(RMSPersonParser.new("HAIR_COLOR" => "ONG").hair_color).to eq("orange")
      expect(RMSPersonParser.new("HAIR_COLOR" => "RED").hair_color).to eq("red")
      expect(RMSPersonParser.new("HAIR_COLOR" => "SDY").hair_color).to eq("sandy")
      expect(RMSPersonParser.new("HAIR_COLOR" => "WHI").hair_color).to eq("white")

      # For these hair color codes, we don't know what they translate into.
      # If we learn, we should update these tests and the code to match.
      # The next import will correct those records in our database.
      expect(RMSPersonParser.new("HAIR_COLOR" => "BAL").hair_color).to eq("unknown")
      expect(RMSPersonParser.new("HAIR_COLOR" => "BO").hair_color).to eq("unknown")
      expect(RMSPersonParser.new("HAIR_COLOR" => "FO").hair_color).to eq("unknown")
      expect(RMSPersonParser.new("HAIR_COLOR" => "PLE").hair_color).to eq("unknown")
    end
  end

  describe "#height_in_inches" do
    it "converts the height string into inches" do
      parser = RMSPersonParser.new("HEIGHT" => " 5'6  ")

      expect(parser.height_in_inches).to eq(66)
    end

    it "handles nil" do
      parser = RMSPersonParser.new("HEIGHT" => nil)

      expect(parser.height_in_inches).to eq(nil)
    end
  end

  describe "#first_name" do
    it "retrieves, strips, and capitalizes the first name" do
      parser = RMSPersonParser.new("G1" => "  JOE      ")

      expect(parser.first_name).to eq("Joe")
    end

    it "handles nil" do
      parser = RMSPersonParser.new("G1" => nil)

      expect(parser.first_name).to eq(nil)
    end
  end

  describe "#last_name" do
    it "retrieves, strips, and capitalizes the last name" do
      parser = RMSPersonParser.new("SURNAME" => "  JOHNSON      ")

      expect(parser.last_name).to eq("Johnson")
    end

    it "handles nil" do
      parser = RMSPersonParser.new("SURNAME" => nil)

      expect(parser.last_name).to eq(nil)
    end
  end

  describe "#location_address" do
    it "retrieves address fields and joins them together" do
      parser = RMSPersonParser.new(
        "ADDRESS" => "123 Main St",
        "APARTMENT" => "#8",
        "MUNICIPALITY" => "ED        ",
        "CITY" => "SEATTLE                                 ",
        "STATE" => "WA",
        "ZIP" => "98026-    ",
      )

      expect(parser.location_address).
        to eq("123 Main St, #8, ED, Seattle, WA, 98026")
    end

    it "leaves out fields that aren't present" do
      parser = RMSPersonParser.new(
        "ADDRESS" => "123 Main St",
        "APARTMENT" => "   ",
        "MUNICIPALITY" => nil,
        "CITY" => "                                        ",
        "STATE" => "WA",
        "ZIP" => nil,
      )

      expect(parser.location_address).
        to eq("123 Main St, WA")
    end
  end

  describe "#location_name" do
    xit "calculates the name corresponding to the location address"
  end

  describe "#race" do
    it "parses race into the appropriate format" do
      expect(RMSPersonParser.new("RACE" => "A").race).to eq("ASIAN (ALL)/PACIFIC ISLANDER")
      expect(RMSPersonParser.new("RACE" => "B").race).to eq("AFRICAN AMERICAN/BLACK")
      expect(RMSPersonParser.new("RACE" => "I").race).to eq("AMERICAN INDIAN/ALASKAN NATIVE")
      expect(RMSPersonParser.new("RACE" => "U").race).to eq("UNKNOWN")
      expect(RMSPersonParser.new("RACE" => "W").race).to eq("WHITE")
      expect(RMSPersonParser.new("RACE" => "-").race).to eq("UNKNOWN")
      expect(RMSPersonParser.new("RACE" => nil).race).to eq("UNKNOWN")
    end
  end

  describe "#scars_and_marks" do
    xit "pulls scars and marks from the RMS"
  end

  describe "#sex" do
    it "parses sex into the appropriate format" do
      expect(RMSPersonParser.new("SEX" => "F").sex).to eq("Female")
      expect(RMSPersonParser.new("SEX" => "M").sex).to eq("Male")
      expect(RMSPersonParser.new("SEX" => "U").sex).to eq("unknown")
      expect(RMSPersonParser.new("SEX" => nil).sex).to eq("unknown")
    end
  end

  describe "#weight_in_pounds" do
    it "parses the weight in pounds" do
      parser = RMSPersonParser.new("WEIGHT" => "  135")

      expect(parser.weight_in_pounds).to eq(135)
    end

    it "handles nil" do
      parser = RMSPersonParser.new("WEIGHT" => nil)

      expect(parser.weight_in_pounds).to eq(nil)
    end
  end
end
