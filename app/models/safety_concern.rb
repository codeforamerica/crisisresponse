class SafetyConcern < ActiveRecord::Base
  CATEGORIES = %w[
    assaultive_law
    assaultive_public
    weapon
    chemical
  ].freeze

  belongs_to :response_plan

  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :title, presence: true
end
