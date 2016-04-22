class Person < ActiveRecord::Base
  include PgSearch

  has_many :contacts

  SAFETY_CRITERIA = [
    :gun_warning,
    :knife_warning,
    :needle_warning,
    :other_weapon_warning,
    :police_assault_warning,
    :spit_warning,
    :suicide_by_cop_warning,
    :violence_warning,
  ]

  has_many :response_strategies

  RACE_CODES = {
    "AFRICAN AMERICAN/BLACK" => "B",
    "AMERICAN INDIAN/ALASKAN NATIVE" => "I",
    "ASIAN (ALL)/PACIFIC ISLANDER" => "A",
    "UNKNOWN" => "U",
    "WHITE" => "W",
  }.freeze

  SEX_CODES = {
    "Male" => "M",
    "Female" => "F",
  }.freeze


  validates :sex, inclusion: SEX_CODES.keys, allow_nil: true
  validates :race, inclusion: RACE_CODES.keys, allow_nil: true

  pg_search_scope(
    :search,
    against: [:first_name, :last_name],
    using: [:tsearch, :dmetaphone, :trigram],
  )

  accepts_nested_attributes_for(
    :response_strategies,
    reject_if: :all_blank,
    allow_destroy: true,
  )

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

  def safety_warnings
    SAFETY_CRITERIA.select { |criteria| self.send(criteria) }
  end

  def to_param
    name
  end

  private

  def height_in_feet_and_inches
    "#{height_in_inches / 12}'#{height_in_inches % 12}\""
  end
end
