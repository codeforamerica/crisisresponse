# frozen_string_literal: true

class AddMiddleInitialToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :middle_initial, :string
    add_column :rms_people, :middle_initial, :string
  end
end
