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
    username_defined_in_env_variable?("ADMIN_USERNAMES")
  end

  # TODO temporary feature flag
  # This should be removed when we allow all officers
  # to view people without response plans.
  def can_view_people_without_response_plans?
    username_defined_in_env_variable?("CAN_VIEW_WITHOUT_RESPONSE_PLANS")
  end

  private

  def username_defined_in_env_variable?(env_var)
    ENV.fetch(env_var).
      to_s.
      gsub(/["']/, "").
      split(",").
      include?(username)
  end
end
