class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.string :description, null: false
      t.references :response_plan, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
