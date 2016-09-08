class AddRoleToOfficer < ActiveRecord::Migration[5.0]
  def change
    add_column :officers, :role, :string, null: false, default: "normal"
  end
end
