class CreateCrisisIncidents < ActiveRecord::Migration
  def change
    create_table :crisis_incidents do |t|
      t.references :person, index: true, foreign_key: true, null: false
      t.datetime :reported_at
      t.string :go_number
      t.boolean :weapon
      t.boolean :threaten_violence
      t.boolean :biologically_induced
      t.boolean :medically_induced
      t.boolean :chemically_induced
      t.boolean :unknown_crisis_nature
      t.boolean :neglect_self_care
      t.boolean :disorganize_communication
      t.boolean :disoriented_confused
      t.boolean :disorderly_disruptive
      t.boolean :unusual_fright_scared
      t.boolean :belligerent_uncooperative
      t.boolean :hopeless_depressed
      t.boolean :bizarre_unusual_behavior
      t.boolean :suicide_threat_attempt
      t.boolean :mania
      t.boolean :out_of_touch_reality
      t.boolean :halluc_delusion
      t.boolean :excited_delirium
      t.boolean :chronic
      t.boolean :treatment_referral
      t.boolean :resource_declined
      t.boolean :mobile_crisis_team
      t.boolean :grat
      t.boolean :shelter
      t.boolean :no_action_poss_necc
      t.boolean :casemanager_notice
      t.boolean :dmhp_refer
      t.boolean :crisis_clinic
      t.boolean :emergent_ita
      t.boolean :voluntary_commit
      t.boolean :arrested
      t.boolean :verbalization

      t.timestamps null: false
    end
  end
end
