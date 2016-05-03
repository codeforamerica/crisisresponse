class AddBackgroundInfoToResponsePlans < ActiveRecord::Migration
  def change
    add_column :response_plans, :background_info, :text
  end
end
