# frozen_string_literal: true

class Person < ApplicationRecord
  include PgSearch
  include PersonValidations
  include Analytics

  URGENT_TIMEFRAME = 7.days
  RECENT_TIMEFRAME = 1.year

  before_create :generate_analytics_token

  has_many :aliases, dependent: :destroy
  has_many :crisis_incidents
  has_many :images, dependent: :destroy
  has_many :response_plans
  has_many :visibilities, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # Easily access response plans that are in draft or submission mode.
  has_one :draft, -> { drafts }, class_name: "ResponsePlan"
  has_one :submission, -> { submitted }, class_name: "ResponsePlan"

  pg_search_scope(
    :search,
    against: [:first_name, :last_name, :middle_initial],
    associated_against: {
      aliases: [:name],
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

  def active_plan
    @active_plan ||= active_plan_at(Time.current)
  end

  def active_plan_at(time = Time.current)
    response_plans.
      approved.
      where("approved_at < :time", time: time).
      order(:approved_at).
      last
  end

  def address_line_one
    location_address.split(",").first
  end

  def address_line_two
    location_address.split(",")[1..-1].join(",")
  end

  def date_of_birth=(value)
    parsed = if value.respond_to?(:to_date) && !value.is_a?(String)
               value.to_date
             elsif value.present?
               Date.strptime(value, "%m-%d-%Y")
             else
               nil
             end

    super(parsed)
  end

  def display_name
    if middle_initial.present?
      "#{last_name}, #{first_name} #{middle_initial}"
    else
      "#{last_name}, #{first_name}"
    end
  end

  def due_for_review?
    cutoff = ENV.fetch("PROFILE_REVIEW_TIMEFRAME_IN_MONTHS").to_i.months.ago

    last_reviewed_on < cutoff
  end

  def has_nominal_response_plan?
    active_plan.try(:response_strategies).try(:any?)
  end

  def height_feet
    height_in_inches.to_i / 12
  end

  def height_feet=(value)
    height = value.to_i * 12 + height_inches

    self.height_in_inches = height.zero? ? nil : height
  end

  def height_inches
    height_in_inches.to_i % 12
  end

  def height_inches=(value)
    height = height_feet * 12 + value.to_i

    self.height_in_inches = height.zero? ? nil : height
  end

  def incidents_since(moment)
    crisis_incidents.where(reported_at: (moment..Time.current))
  end

  def last_reviewed_on
    [
      response_plans.approved.pluck(:approved_at),
      visibilities.active.pluck(:created_at),
      reviews.pluck(:created_at),
      created_at,
    ].flatten.compact.sort.last.to_date
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name=(value)
    parts = value.split
    self.first_name = parts.first
    self.last_name = parts.last

    if parts.count >= 3
      self.middle_initial = parts.second
    end
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

  def shorthand_description
    [
      RACE_CODES.fetch(race, "U") + SEX_CODES.fetch(sex, "U"),
      height_in_feet_and_inches,
      weight_in_pounds ? "#{weight_in_pounds} lb" : nil,
    ].compact.join(" – ")
  end

  def veteran?
    crisis_incidents.any?(&:veteran)
  end

  def visibility_status
    visibility = visibilities.last

    status = "HIDDEN"
    reason = "(auto)"

    if visible?
      status = "VISIBLE"
    end

    if visibility.try(:created_by) || visibility.try(:removed_by)
      reason = "(manual)"
    end

    "#{status} #{reason}"
  end

  def visible?
    visibilities.active.any?
  end

  private

  def height_in_feet_and_inches
    unless height_feet.zero? && height_inches.zero?
      "#{height_feet}'#{height_inches}\""
    end
  end

  def cache_if_record_is_persisted(cache_label)
    if persisted? && !changed?
      Rails.cache.fetch([self, cache_label]) { yield }
    else
      yield
    end
  end
end
