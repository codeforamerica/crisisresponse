class AddScarsAndMarksToPeople < ActiveRecord::Migration
  def change
    add_column :people, :scars_and_marks, :string
  end
end
