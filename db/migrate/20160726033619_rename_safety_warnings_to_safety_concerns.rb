class RenameSafetyWarningsToSafetyConcerns < ActiveRecord::Migration
  def self.up
    rename_table :safety_warnings, :safety_concerns
  end

  def self.down
    rename_table :safety_concerns, :safety_warnings
  end
end
