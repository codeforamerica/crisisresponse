class SafetyConcern < ActiveRecord::Base
  ASSAULTIVE_CATEGORIES = %w[
    assaultive_law
    assaultive_public
  ].freeze

  CATEGORIES = ASSAULTIVE_CATEGORIES + %w[
    weapon
    chemical
  ].freeze

  belongs_to :response_plan

  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :description, presence: true
end
