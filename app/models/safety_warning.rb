class SafetyWarning < ActiveRecord::Base
  belongs_to :response_plan

  validates :description, presence: true
  validates :response_plan, presence: true
end
