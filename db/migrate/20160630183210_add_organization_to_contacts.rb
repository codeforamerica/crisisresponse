class AddOrganizationToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :organization, :string
  end
end
