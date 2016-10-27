# frozen_string_literal: true

require "action_view/helpers/text_helper"

class Threshold
  include ActionView::Helpers::TextHelper

  DEFAULT_THRESHOLD = ENV.fetch("RECENT_CRISIS_INCIDENT_THRESHOLD").to_i

  def initialize(threshold = DEFAULT_THRESHOLD)
    @threshold = threshold
  end

  attr_reader :threshold

  def create_visibilities_over_threshold
    new_visibilities = []

    new_people_over_threshold.each do |person_id|
      new_visibilities << Visibility.create!(
        person_id: person_id,
        creation_notes: crossed_threshold_message,
      )
    end

    new_visibilities
  end

  # Limit this method to `where(created_by: nil)`
  # so that we don't remove someone that CRT has manually marked as visible.
  def remove_visibilities_below_threshold
    Visibility.
      active.
      where(created_by: nil, person_id: people_ids_under_threshold).
      each do |visibility|
        visibility.update!(
          removed_by: nil,
          removal_notes: crossed_threshold_message,
          removed_at: Time.current,
        )
      end
  end

  private

  def new_people_over_threshold
    people_ids_over_threshold -
      people_with_current_visibility -
      people_with_manually_removed_visibility
  end

  def people_ids_over_threshold
    RMS::Person.
      where(id: rms_people_ids_over_threshold).
      pluck(:person_id)
  end

  def people_with_current_visibility
    Visibility.active.pluck(:person_id).uniq
  end

  def people_with_manually_removed_visibility
    Visibility.
      where.not(removed_by: nil).
      pluck(:person_id)
  end

  def rms_people_ids_over_threshold
    rms_people_incident_counts.
      select { |_, incident_count| incident_count >= threshold }.
      keys
  end

  def manually_visible_people_ids
    Visibility.active.where.not(created_by: nil).pluck(:person_id).uniq
  end

  def people_ids_under_threshold
    Person.
      where.not(id: people_ids_over_threshold).
      pluck(:id)
  end

  def rms_people_incident_counts
    RMS::CrisisIncident.
      where(reported_at: (Person::RECENT_TIMEFRAME.ago..Time.current)).
      group(:rms_person_id).
      count
  end

  def crossed_threshold_message
    threshold_text = pluralize(threshold, "RMS Crisis Incident")
    "[AUTO] Person crossed the threshold of #{threshold_text}"
  end
end
