class AddPrivateNotesToResponsePlans < ActiveRecord::Migration
  def change
    add_column :response_plans, :private_notes, :text
  end
end
