# frozen_string_literal: true

class ChangeDescriptionsToText < ActiveRecord::Migration[5.0]
  def self.up
    change_column :safety_concerns, :description, :text
    change_column :triggers, :description, :text
  end

  def self.down
    change_column :safety_concerns, :description, :string
    change_column :triggers, :description, :string
  end
end
