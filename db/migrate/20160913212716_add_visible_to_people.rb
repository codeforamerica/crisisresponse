# frozen_string_literal: true

class AddVisibleToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :visible, :boolean, null: false, default: false
    add_index :people, :visible
  end
end
