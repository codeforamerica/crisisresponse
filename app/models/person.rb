class Person < ActiveRecord::Base
  include PgSearch
  include PersonValidations
  include Analytics

  URGENT_TIMEFRAME = 7.days
  RECENT_TIMEFRAME = 1.year
  RECENT_INCIDENT_THRESHOLD = 12

  attr_accessor :height_feet, :height_inches

  before_create :generate_analytics_token

  has_many :aliases, dependent: :destroy
  has_many(
    :crisis_incidents,
    through: :rms_person,
    class_name: "RMS::CrisisIncident",
  )
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
      cache_if_record_is_persisted(attribute) do
        super(*args) || (rms_person && rms_person.public_send(attribute))
      end
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

  def self.update_visibility
    Person.update_all(visible: false)

    over_threhsold = RMS::CrisisIncident.
      where(reported_at: (RECENT_TIMEFRAME.ago..Time.current)).
      group(:rms_person_id).
      count.
      reject { |_, incident_count| incident_count < RECENT_INCIDENT_THRESHOLD }.
      keys

    people_ids =
      RMS::Person.find(over_threhsold).pluck(:person_id) +
      ResponsePlan.approved.pluck(:person_id)

    Person.where(id: people_ids).update_all(visible: true)
  end

  def self.visible
    where(visible: true)
  end

  def active_plan
    @active_plan ||= response_plans.
      approved.
      order(:approved_at).
      last
  end

  def display_name
    "#{last_name}, #{first_name}"
  end

  def incidents_since(moment)
    crisis_incidents.where(reported_at: (moment..Time.current))
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name=(value)
    (self.first_name, self.last_name) = value.split
  end

  def profile_image_url
    Rails.cache.fetch([self, "profile_image_url"]) do
      images.first.try(:source_url) || "/default_profile.png"
    end
  end

  def recent_incidents
    @recent_incidents ||= incidents_since(RECENT_TIMEFRAME.ago).
      order(reported_at: :desc)
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

  def cache_if_record_is_persisted(cache_label)
    if persisted?
      Rails.cache.fetch([self, cache_label]) { yield }
    else
      yield
    end
  end
end
