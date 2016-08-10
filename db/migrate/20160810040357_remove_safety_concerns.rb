class RemoveSafetyConcerns < ActiveRecord::Migration
  def change
    drop_table :safety_concerns do |t|
      t.belongs_to :response_plan, index: true, foreign_key: true, null: false
      t.string :category, null: false
      t.string :description, null: false
      t.string :physical_or_threat
      t.timestamps null: false
    end
  end
end
