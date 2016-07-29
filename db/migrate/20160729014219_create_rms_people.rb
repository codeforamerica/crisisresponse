class CreateRmsPeople < ActiveRecord::Migration
  def change
    create_table :rms_people do |t|
      t.string :first_name
      t.string :last_name
      t.string :sex
      t.string :race
      t.integer :height_in_inches
      t.integer :weight_in_pounds
      t.string :hair_color
      t.string :eye_color
      t.date :date_of_birth
      t.string :scars_and_marks
      t.string :location_name
      t.string :location_address
      t.string :pin, null: false

      t.timestamps null: false
    end
  end
end
