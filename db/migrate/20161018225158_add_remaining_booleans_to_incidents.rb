# frozen_string_literal: true

class AddRemainingBooleansToIncidents < ActiveRecord::Migration[5.0]
  def change
    change_table :crisis_incidents do |t|
      t.boolean :dicv
      t.boolean :bodycam
      t.boolean :cit_officer_requested
      t.boolean :cit_officer_dispatched
      t.boolean :cit_officer_arrived
      t.boolean :behavior_other
      t.boolean :weapon_knife
      t.boolean :weapon_gun
      t.boolean :weapon_other
      t.boolean :handcuffs
      t.boolean :reportable_force_used
      t.boolean :unable_to_contact
      t.boolean :cit_certified
      t.boolean :supervisor_responded_to_scene
      t.boolean :injuries
    end
  end
end
