class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.belongs_to :response_plan, index: true, foreign_key: true
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
