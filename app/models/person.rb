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

  has_many :aliases, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :response_plans
  has_one :rms_person, class_name: "RMS::Person"

  def sex; super || SEX_CODES.invert[rms_person.sex] rescue nil; end
  def race; super || RACE_CODES.invert[rms_person.race] rescue nil; end
  def date_of_birth; super || rms_person.date_of_birth rescue nil; end
  def first_name; super || rms_person.first_name rescue nil; end
  def last_name; super || rms_person.last_name rescue nil; end
  def height_in_inches; super || rms_person.height_in_inches rescue nil; end
  def weight_in_pounds; super || rms_person.weight_in_pounds rescue nil; end
  def hair_color; super || rms_person.hair_color rescue nil; end
  def eye_color; super || rms_person.eye_color rescue nil; end
  def scars_and_marks; super || rms_person.scars_and_marks rescue nil; end
  def location_name; super || rms_person.location_name rescue nil; end
  def location_address; super || rms_person.location_address rescue nil; end

  validates :sex, inclusion: SEX_CODES.keys, allow_nil: true
  validates :race, inclusion: RACE_CODES.keys, allow_nil: true
  validates :date_of_birth, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  pg_search_scope(
    :search,
    against: [:first_name, :last_name],
    associated_against: { rms_person: [:first_name, :last_name] },
    using: [:tsearch, :dmetaphone, :trigram],
  )

  accepts_nested_attributes_for(
    :aliases,
    reject_if: :all_blank,
    allow_destroy: true,
  )
  accepts_nested_attributes_for(
    :images,
    reject_if: :all_blank,
    allow_destroy: true,
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

  def profile_image_url
    if images.any?
      images.first.source_url
    else
      "/assets/default_image.png"
    end
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
