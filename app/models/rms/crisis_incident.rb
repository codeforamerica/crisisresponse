# frozen_string_literal: true

module RMS
  class CrisisIncident < ActiveRecord::Base
    belongs_to :rms_person, class_name: "RMS::Person"

    BEHAVIORS = [
      :weapon,
      :threaten_violence,
      :biologically_induced,
      :medically_induced,
      :chemically_induced,
      :unknown_crisis_nature,
      :neglect_self_care,
      :disorganize_communication,
      :disoriented_confused,
      :disorderly_disruptive,
      :unusual_fright_scared,
      :belligerent_uncooperative,
      :hopeless_depressed,
      :bizarre_unusual_behavior,
      :suicide_threat_attempt,
      :mania,
      :out_of_touch_reality,
      :halluc_delusion,
      :excited_delirium,
      :chronic,
      :treatment_referral,
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
      :verbalization,
    ].freeze

    def self.frequent_behaviors
      behaviors_by_incident = pluck(*BEHAVIORS)

      BEHAVIORS.map.with_index do |behavior, index|
        [
          behavior,
          behaviors_by_incident.count { |incident| incident[index] },
        ]
      end.reject { |_, count| count.zero? }.to_h
    end

    def behaviors
      BEHAVIORS.select { |behavior| public_send(behavior) }
    end
  end
end
