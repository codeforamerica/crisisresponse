require "active_support/core_ext/string/inflections"
require_relative "../app/models/rms"

class RMSPersonParser
  RMS_PERSON_ATTRIBUTES = [
    :date_of_birth,
    :eye_color,
    :first_name,
    :hair_color,
    :height_in_inches,
    :last_name,
    :location_address,
    :race,
    :sex,
    :weight_in_pounds,
  ].freeze

  def initialize(data)
    @data = data
  end

  def parsed_attributes
    RMS_PERSON_ATTRIBUTES.map do |attr|
      [attr, send(attr)]
    end.to_h
  end

  def date_of_birth
    dob = data.fetch("DOB")

    if dob
      dob.to_date
    end
  end

  def eye_color
    code = data.fetch("EYE_COLOR").to_s.strip
    RMS::EYE_COLOR_CODES[code] || RMS::UNKNOWN
  end

  def hair_color
    code = data.fetch("HAIR_COLOR").to_s.strip
    RMS::HAIR_COLOR_CODES[code] || RMS::UNKNOWN
  end

  def height_in_inches
    height = data.fetch("HEIGHT")

    if height
      feet = height.strip[0]
      inches = height.strip[1..-1].scan(/\d+/).first
      feet.to_i * 12 + inches.to_i
    end
  end

  def first_name
    name = data.fetch("G1")

    if name
      name.strip.titlecase
    end
  end

  def last_name
    name = data.fetch("SURNAME")

    if name
      name.strip.titlecase
    end
  end

  def location_address
    address_components = [
      data.fetch("ADDRESS").to_s,
      data.fetch("APARTMENT").to_s,
      data.fetch("MUNICIPALITY").to_s,
      data.fetch("CITY").to_s.titlecase,
      data.fetch("STATE").to_s,
      # Remove trailing dashes from the zip code
      data.fetch("ZIP").to_s.strip.gsub(/-$/, ""),
    ]

    address_components.
      compact.
      map(&:strip).
      reject(&:empty?).
      join(", ")
  end

  def race
    RMS::RACE_CODES.invert.fetch(data.fetch("RACE").to_s.strip, "UNKNOWN")
  end

  def sex
    RMS::SEX_CODES.invert.fetch(data.fetch("SEX").to_s.strip, "unknown")
  end

  def weight_in_pounds
    weight = data.fetch("WEIGHT")

    if weight
      weight.to_i
    end
  end

  private

  attr_reader :data
end
