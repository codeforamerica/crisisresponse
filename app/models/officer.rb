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

  private

  def username_defined_in_env_variable?(env_var)
    ENV.fetch(env_var).
      to_s.
      gsub(/["']/, "").
      split(",").
      include?(username)
  end
end
