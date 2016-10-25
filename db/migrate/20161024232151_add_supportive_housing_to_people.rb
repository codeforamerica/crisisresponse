# frozen_string_literal: true

class AddSupportiveHousingToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :location_supportive_housing, :boolean, default: false
  end
end
