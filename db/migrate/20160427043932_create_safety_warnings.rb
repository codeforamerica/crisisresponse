class CreateSafetyWarnings < ActiveRecord::Migration
  def change
    create_table :safety_warnings do |t|
      t.string :description, null: false
      t.belongs_to :person, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
