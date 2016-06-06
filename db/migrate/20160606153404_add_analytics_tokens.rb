class AddAnalyticsTokens < ActiveRecord::Migration
  def change
    add_column :officers, :analytics_token, :string
    add_column :response_plans, :analytics_token, :string
  end
end
