class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :response_plan, index: true, foreign_key: true
      t.string :name
      t.string :relationship
      t.string :cell
      t.string :notes

      t.timestamps null: false
    end
  end
end
