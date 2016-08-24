class Person < ActiveRecord::Base
  include PgSearch
  include PersonValidations
  include Analytics

  attr_accessor :height_feet, :height_inches

  before_create :generate_analytics_token

  has_many :aliases, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :response_plans
  has_one :rms_person, class_name: "RMS::Person"

  pg_search_scope(
    :search,
    against: [:first_name, :last_name],
    associated_against: {
      aliases: [:name],
      rms_person: [:first_name, :last_name],
    },
    using: {
      dmetaphone: {},
      trigram: { threshold: 0.12 },
      tsearch: {},
    },
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

  def self.fallback_to_rms_person(attribute)
    define_method(attribute) do |*args|
      super(*args) ||
        (rms_person && rms_person.public_send(attribute))
    end

    define_method("#{attribute}=") do |value|
      if rms_person.try(attribute) == value
        super(nil)
      else
        super(value)
      end
    end
  end

  fallback_to_rms_person(:date_of_birth)
  fallback_to_rms_person(:eye_color)
  fallback_to_rms_person(:first_name)
  fallback_to_rms_person(:hair_color)
  fallback_to_rms_person(:height_in_inches)
  fallback_to_rms_person(:last_name)
  fallback_to_rms_person(:location_address)
  fallback_to_rms_person(:location_name)
  fallback_to_rms_person(:race)
  fallback_to_rms_person(:scars_and_marks)
  fallback_to_rms_person(:sex)
  fallback_to_rms_person(:weight_in_pounds)
  fallback_to_rms_person(:weight_in_pounds)
  fallback_to_rms_person(:weight_in_pounds)

  def active_response_plan
    response_plans.where.not(approved_at: nil).order(:approved_at).last
  end

  def display_name
    "#{last_name}, #{first_name}"
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

  def save(*args)
    if height_feet && height_inches
      self.height_in_inches = height_feet.to_i * 12 + height_inches.to_i
    end

    super(*args)
  end

  def shorthand_description
    [
      RMS::RACE_CODES.fetch(race) + RMS::SEX_CODES.fetch(sex),
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
