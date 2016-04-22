class AddSafetyWarningsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :gun_warning, :string
    add_column :people, :knife_warning, :string
    add_column :people, :needle_warning, :string
    add_column :people, :other_weapon_warning, :string
    add_column :people, :police_assault_warning, :string
    add_column :people, :spit_warning, :string
    add_column :people, :suicide_by_cop_warning, :string
    add_column :people, :violence_warning, :string
  end
end
