# frozen_string_literal: true

class AddVeteranToRmsCrisisIncidents < ActiveRecord::Migration[5.0]
  def change
    add_column :rms_crisis_incidents, :veteran, :boolean
  end
end
