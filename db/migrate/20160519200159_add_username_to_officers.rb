class AddUsernameToOfficers < ActiveRecord::Migration
  def change
    add_column :officers, :username, :string
    add_index :officers, :username, unique: true
  end
end
