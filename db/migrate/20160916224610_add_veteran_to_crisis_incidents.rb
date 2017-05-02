# frozen_string_literal: true

class AddVeteranToCrisisIncidents < ActiveRecord::Migration[5.0]
  def change
    add_column :crisis_incidents, :veteran, :boolean
  end
end
