class Person < ActiveRecord::Base
  RACE_CODES = {
    "AFRICAN AMERICAN/BLACK" => "B",
    "AMERICAN INDIAN/ALASKAN NATIVE" => "I",
    "ASIAN (ALL)/PACIFIC ISLANDER" => "A",
    "UNKNOWN" => "U",
    "WHITE" => "W",
  }

  SEX_CODES = {
    "Male" => "M",
    "Female" => "F",
  }

  has_many :response_strategies

  accepts_nested_attributes_for(
    :response_strategies,
    reject_if: :all_blank,
    allow_destroy: true,
  )

  validates :sex, inclusion: SEX_CODES.keys, allow_nil: true
  validates :race, inclusion: RACE_CODES.keys, allow_nil: true

  mount_uploader :image, ImageUploader

  def name=(value)
    (self.first_name, self.last_name) = value.split
  end

  def name
    "#{first_name} #{last_name}"
  end

  def shorthand_description
    [
      RACE_CODES.fetch(race) + SEX_CODES.fetch(sex),
      height_in_feet_and_inches,
      "#{weight_in_pounds} lb"
    ].join(" – ")
  end

  def to_param
    name
  end

  private

  def height_in_feet_and_inches
    "#{height_in_inches / 12}'#{height_in_inches % 12}\""
  end
end
