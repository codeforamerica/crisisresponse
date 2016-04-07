class AddHorsepowerToPeople < ActiveRecord::Migration
  def change
    add_column :people, :first_name, :string
    add_column :people, :last_name, :string
    add_column :people, :sex, :string
    add_column :people, :race, :string
    add_column :people, :height_in_inches, :integer
    add_column :people, :weight_in_pounds, :integer
    add_column :people, :hair_color, :string
    add_column :people, :eye_color, :string
    add_column :people, :date_of_birth, :date
  end
end
