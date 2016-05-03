class AddHorsepowerToResponsePlans < ActiveRecord::Migration
  def change
    add_column :response_plans, :first_name, :string
    add_column :response_plans, :last_name, :string
    add_column :response_plans, :sex, :string
    add_column :response_plans, :race, :string
    add_column :response_plans, :height_in_inches, :integer
    add_column :response_plans, :weight_in_pounds, :integer
    add_column :response_plans, :hair_color, :string
    add_column :response_plans, :eye_color, :string
    add_column :response_plans, :date_of_birth, :date
  end
end
