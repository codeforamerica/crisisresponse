# frozen_string_literal: true

class Officer < ApplicationRecord
  include Analytics
  include PgSearch

  NORMAL = "normal"
  ADMIN = "admin"
  ROLES = [NORMAL, ADMIN].freeze

  before_create :generate_analytics_token

  validates :name, presence: true
  validates :role, inclusion: { in: ROLES }
  validates :username, uniqueness: true

  has_many(
    :authored_response_plans,
    class_name: "ResponsePlan",
    dependent: :destroy,
    foreign_key: :author_id,
  )

  has_many(
    :approved_response_plans,
    class_name: "ResponsePlan",
    dependent: :destroy,
    foreign_key: :approver_id,
  )

  pg_search_scope(
    :search,
    against: [:name, :username],
    using: [:dmetaphone, :trigram, :tsearch],
  )

  def admin?
    role == ADMIN
  end
end
