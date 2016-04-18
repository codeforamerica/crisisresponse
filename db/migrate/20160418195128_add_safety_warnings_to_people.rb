class AddSafetyWarningsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :gun, :boolean, default: false, null: false
    add_column :people, :knife, :boolean, default: false, null: false
    add_column :people, :needles, :boolean, default: false, null: false
    add_column :people, :other_weapon, :boolean, default: false, null: false
    add_column :people, :police_assault, :boolean, default: false, null: false
    add_column :people, :spitting, :boolean, default: false, null: false
    add_column :people, :suicide_by_cop, :boolean, default: false, null: false
    add_column :people, :violence, :boolean, default: false, null: false
  end
end
