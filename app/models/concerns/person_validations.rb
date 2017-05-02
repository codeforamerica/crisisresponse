module PersonValidations
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  UNKNOWN = "unknown".freeze

  # TODO Invert this hash to align with EYE_COLOR_CODES and HAIR_COLOR_CODES
  # "A" => "asian (all)/pacific islander",
  # "B" => "african american/black",
  # "I" => "american indian/alaskan native",
  # "U" => UNKNOWN,
  # "W" => "white",
  #
  # This will require a migration to `#downcase` all of the `race` codes
  RACE_CODES = {
      "AFRICAN AMERICAN/BLACK" => "B",
      "AMERICAN INDIAN/ALASKAN NATIVE" => "I",
      "ASIAN (ALL)/PACIFIC ISLANDER" => "A",
      "UNKNOWN" => "U",
      "WHITE" => "W",
  }.freeze

  # TODO Invert this hash to align with EYE_COLOR_CODES and HAIR_COLOR_CODES
  # "M" => "male",
  # "F" => "female",
  # "U" => UNKNOWN,
  #
  # This will require a migration to `#downcase` all of the `sex` codes
  SEX_CODES = {
      "Male" => "M",
      "Female" => "F",
      UNKNOWN => "U",
  }.freeze

  EYE_COLOR_CODES = {
      "BRO" => "brown",
      "BLU" => "blue",
      "GRN" => "green",
      "BLK" => "black",
      "GRY" => "gray",
      "HAZ" => "hazel",
      "MAR" => "maroon",
      "MUL" => "multicolored",
      "PNK" => "pink",
      "XXX" => UNKNOWN,
  }.freeze

  HAIR_COLOR_CODES = {
      "BLK" => "black",
      "BRO" => "brown",
      "BLN" => "blonde",
      "GRY" => "gray",
      "BAL" => "bald",
      "RED" => "red",
      "BLU" => "blue",
      "GRN" => "green",
      "HAZ" => "hazel",
      "MAR" => "maroon",
      "MUL" => "multicolored",
      "ONG" => "orange",
      "PNK" => "pink",
      "SDY" => "sandy",
      "WHI" => "white",
      "XXX" => UNKNOWN,
  }.freeze

  EYE_COLORS = EYE_COLOR_CODES.values.freeze
  HAIR_COLORS = HAIR_COLOR_CODES.values.freeze

  included do
    validates :first_name, presence: true
    validates :last_name, presence: true

    validates :sex, inclusion: SEX_CODES.keys, allow_blank: true
    validates :race, inclusion: RACE_CODES.keys, allow_blank: true

    validates(
      :hair_color,
      inclusion: HAIR_COLOR_CODES.values,
      allow_blank: true,
    )

    validates(
      :eye_color,
      inclusion: EYE_COLOR_CODES.values,
      allow_blank: true,
    )

    validates :middle_initial, format: {
      allow_blank: true,
      message: "must be a single letter",
      with: /\A.\z/,
    }
  end
end
