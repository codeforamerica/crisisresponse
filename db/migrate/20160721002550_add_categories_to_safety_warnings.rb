class AddCategoriesToSafetyWarnings < ActiveRecord::Migration
  def change
    add_column :safety_warnings, :category, :string, null: false
    add_column :safety_warnings, :physical_or_threat, :string
  end
end
