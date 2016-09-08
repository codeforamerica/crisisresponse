# frozen_string_literal: true

class Officer < ActiveRecord::Base
  include Analytics

  NORMAL = "normal"
  ADMIN = "admin"
  ROLES = [NORMAL, ADMIN].freeze

  before_create :generate_analytics_token

  validates :name, presence: true
  validates :role, inclusion: { in: ROLES }

  has_many(
    :authored_response_plans,
    class_name: "ResponsePlan",
    foreign_key: :author_id,
    dependent: :destroy,
  )

  has_many(
    :approved_response_plans,
    class_name: "ResponsePlan",
    foreign_key: :approver_id,
    dependent: :destroy,
  )

  def admin?
    role == ADMIN
  end
end
