# frozen_string_literal: true

class CrisisIncident < ActiveRecord::Base
  belongs_to :person

  BEHAVIORS = [
    :suicide_threat_attempt,
    :excited_delirium,
    :halluc_delusion,
    :belligerent_uncooperative,
    :mania,
    :disorderly_disruptive,
    :hopeless_depressed,
    :bizarre_unusual_behavior,
    :out_of_touch_reality,
    :disorganize_communication,
    :disoriented_confused,
    :unusual_fright_scared,
    :neglect_self_care,
  ].freeze

  OTHER = [
    :threaten_violence,
    :weapon,
  ].freeze

  NATURE_OF_CRISIS = [
    :biologically_induced,
    :medically_induced,
    :chemically_induced,
    :unknown_crisis_nature,
  ].freeze

  DISPOSITIONS = [
    :treatment_referral,
    :chronic,
    :resource_declined,
    :mobile_crisis_team,
    :grat,
    :shelter,
    :no_action_poss_necc,
    :casemanager_notice,
    :dmhp_refer,
    :crisis_clinic,
    :emergent_ita,
    :voluntary_commit,
    :arrested,
  ].freeze

  def self.frequent_behaviors
    by_frequency(:behaviors)
  end

  def self.by_frequency(category)
    observations = CrisisIncident.const_get(category.to_s.upcase)
    observations_by_incident = pluck(*observations)

    observations.map.with_index do |observation, index|
      [
        observation,
        observations_by_incident.count { |incident| incident[index] },
      ]
    end.
      reject { |_, count| count.zero? }.
      sort_by { |_, count| count }.
      reverse.
      to_h
  end

  def behaviors
    BEHAVIORS.select { |behavior| public_send(behavior) }
  end

  def dispositions
    DISPOSITIONS.select { |disposition| public_send(disposition) }
  end

  def formatted_go_number
    GO.new(go_number).display
  end
end

