class AddImageToResponsePlans < ActiveRecord::Migration
  def change
    add_column :response_plans, :image, :string
  end
end
