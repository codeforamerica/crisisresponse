class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :source, null: false
      t.belongs_to :response_plan, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    remove_column :response_plans, :image, :string
  end
end
