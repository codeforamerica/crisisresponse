class AddSubmittedToResponsePlans < ActiveRecord::Migration
  def change
    add_column :response_plans, :submitted_for_approval_at, :datetime
  end
end
