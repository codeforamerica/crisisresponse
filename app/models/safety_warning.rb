class SafetyWarning < ActiveRecord::Base
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
  validates :response_plan, presence: true

  validate :physical_or_threat_if_in_those_categories
  validate :not_physical_or_threat_if_not_in_those_categories

  def physical_or_threat_if_in_those_categories
    if ASSAULTIVE_CATEGORIES.include? category
      unless physical? || threat?
        errors.add(:physical_or_threat, "Must be 'physical' or 'threat'")
      end
    end
  end

  def not_physical_or_threat_if_not_in_those_categories
    unless ASSAULTIVE_CATEGORIES.include? category
      unless physical_or_threat.nil?
        errors.add(:physical_or_threat, "must be blank")
      end
    end
  end

  def physical?
    physical_or_threat.to_s == "physical"
  end

  def threat?
    physical_or_threat.to_s == "threat"
  end
end
