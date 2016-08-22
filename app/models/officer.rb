class Officer < ActiveRecord::Base
  include Analytics
  before_create :generate_analytics_token

  validates :name, presence: true

  has_many :authored_response_plans,
    class_name: "ResponsePlan",
    foreign_key: :author_id,
    dependent: :destroy

  has_many :approved_response_plans,
    class_name: "ResponsePlan",
    foreign_key: :approver_id,
    dependent: :destroy

  def admin?
    ENV.fetch("ADMIN_USERNAMES").to_s.split(",").include?(username)
  end

  # TODO temporary feature flag
  # This should be removed when we allow all officers
  # to view people without response plans.
  def can_view_people_without_response_plans?
    ENV.fetch("CAN_VIEW_WITHOUT_RESPONSE_PLANS").to_s.split(",").include?(username)
  end
end
