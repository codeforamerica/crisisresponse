class CreateResponseStrategies < ActiveRecord::Migration
  def change
    create_table :response_strategies do |t|
      t.integer :priority
      t.string :title
      t.text :description
      t.references :person, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
