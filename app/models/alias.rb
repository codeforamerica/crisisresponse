class Alias < ActiveRecord::Base
  belongs_to :response_plan

  validates :response_plan, presence: true
  validates :name,
    presence: true,
    uniqueness: { scope: :response_plan_id }
end
