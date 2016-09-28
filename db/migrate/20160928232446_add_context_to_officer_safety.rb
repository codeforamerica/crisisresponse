# frozen_string_literal: true

class AddContextToOfficerSafety < ActiveRecord::Migration[5.0]
  def up
    rename_column :safety_concerns, :description, :title
    add_column :safety_concerns, :description, :string

    add_column :safety_concerns, :go_number, :string
    add_column :triggers, :go_number, :string
  end

  def down
    remove_column :safety_concerns, :description, :string
    rename_column :safety_concerns, :title, :description

    remove_column :safety_concerns, :go_number, :string
    remove_column :triggers, :go_number, :string
  end
end
