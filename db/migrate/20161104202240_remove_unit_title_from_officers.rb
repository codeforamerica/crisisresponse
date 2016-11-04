class RemoveUnitTitleFromOfficers < ActiveRecord::Migration[5.0]
  def change
    remove_column :officers, :unit, :string
    remove_column :officers, :title, :string
    add_column :officers, :email, :string
  end
end
