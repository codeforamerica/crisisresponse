class AddLocationToResponsePlans < ActiveRecord::Migration
  def change
    add_column :response_plans, :location_name, :string
    add_column :response_plans, :location_address, :string
  end
end
