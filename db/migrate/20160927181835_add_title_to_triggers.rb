# frozen_string_literal: true

class AddTitleToTriggers < ActiveRecord::Migration[5.0]
  def up
    rename_column :triggers, :description, :title
    add_column :triggers, :description, :string
  end

  def down
    remove_column :triggers, :description, :string
    rename_column :triggers, :title, :description
  end
end
