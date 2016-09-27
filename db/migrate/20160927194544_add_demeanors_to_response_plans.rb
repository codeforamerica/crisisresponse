class AddDemeanorsToResponsePlans < ActiveRecord::Migration[5.0]
  def change
    add_column :response_plans, :baseline, :string
    add_column :response_plans, :elevated, :string
  end
end
