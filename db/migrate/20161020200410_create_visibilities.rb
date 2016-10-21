# frozen_string_literal: true

# This migration creates a new table to track who is visible to patrol officers.
# We are removing the `visible` column from `people` because,
# as a boolean column,
# it does not let us audit when plans were visible vs not.
#
# This migration is forgetful -
# everyone will be transitioned to non-visible.
# To correct this, we should run the RMS import script once.
# The script will reset everybody's visibility.
class CreateVisibilities < ActiveRecord::Migration[5.0]
  def change
    create_table :visibilities do |t|
      t.belongs_to :person, foreign_key: true, null: false
      t.text :creation_notes
      t.belongs_to :created_by, foreign_key: { to_table: :officers }
      t.datetime :removed_at
      t.text :removal_notes
      t.belongs_to :removed_by, foreign_key: { to_table: :officers }

      t.timestamps
    end

    remove_index :people, :visible
    remove_column :people, :visible, :boolean, null: false, default: false
  end
end
