class Person < ActiveRecord::Base
  include PgSearch

  include Analytics
  before_create :generate_analytics_token

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

  EYE_COLORS = [
    :black,
    :blue,
    :brown,
    :gray,
    :green,
    :hazel,
    :maroon,
    :multicolored,
    :pink,
    :unknown,
  ].freeze

  HAIR_COLORS = [
    :bald,
    :black,
    :blonde,
    :brown,
    :grey,
    :red,
  ].freeze

  has_many :response_plans

  validates :sex, inclusion: SEX_CODES.keys, allow_nil: true
  validates :race, inclusion: RACE_CODES.keys, allow_nil: true
  validates :date_of_birth, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  pg_search_scope(
    :search,
    against: [:first_name, :last_name],
    using: [:tsearch, :dmetaphone, :trigram],
  )

  def active_response_plan
    response_plans.where.not(approved_at: nil).order(:approved_at).last
  end

  def display_name
    "#{last_name}, #{first_name}"
  end

  def eye_color
    super || "Unknown"
  end

  def hair_color
    super || "Unknown"
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name=(value)
    (self.first_name, self.last_name) = value.split
  end

  def response_plan
    response_plans.last
  end

  def shorthand_description
    [
      RACE_CODES.fetch(race) + SEX_CODES.fetch(sex),
      height_in_feet_and_inches,
      weight_in_pounds ? "#{weight_in_pounds} lb" : nil,
    ].compact.join(" – ")
  end

  private

  def height_in_feet_and_inches
    if height_in_inches
      "#{height_in_inches / 12}'#{height_in_inches % 12}\""
    else
      nil
    end
  end
end
