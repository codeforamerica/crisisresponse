# frozen_string_literal: true

class AddAssigneeToResponsePlan < ActiveRecord::Migration[5.0]
  def change
    add_column :response_plans, :assignee_id, :integer, index: true
    add_foreign_key :response_plans, :officers, column: :assignee_id
  end
end
