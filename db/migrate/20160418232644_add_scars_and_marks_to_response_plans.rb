class AddScarsAndMarksToResponsePlans < ActiveRecord::Migration
  def change
    add_column :response_plans, :scars_and_marks, :string
  end
end
