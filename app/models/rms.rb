module RMS
  def self.table_name_prefix
    'rms_'
  end

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
    "BLK" => "black",
    "BLU" => "blue",
    "BRO" => "brown",
    "GRN" => "green",
    "GRY" => "gray",
    "HAZ" => "hazel",
    "MAR" => "maroon",
    "MUL" => "multicolored",
    "PNK" => "pink",
    "XXX" => UNKNOWN,
  }.freeze

  HAIR_COLOR_CODES = {
    "BLK" => "black",
    "BLN" => "blonde",
    "BLU" => "blue",
    "BRO" => "brown",
    "GRN" => "green",
    "GRY" => "gray",
    "HAZ" => "hazel",
    "MAR" => "maroon",
    "MUL" => "multicolored",
    "ONG" => "orange",
    "PNK" => "pink",
    "RED" => "red",
    "SDY" => "sandy",
    "WHI" => "white",
    "XXX" => UNKNOWN,
  }.freeze

  EYE_COLORS = EYE_COLOR_CODES.values.freeze
  HAIR_COLORS = HAIR_COLOR_CODES.values.freeze
end
