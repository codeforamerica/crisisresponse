class CreateResponsePlans < ActiveRecord::Migration
  def change
    create_table :response_plans do |t|

      t.timestamps null: false
    end
  end
end
