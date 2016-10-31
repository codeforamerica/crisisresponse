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

  def occurred_on=(value)
    if value.present?
      super(Date.strptime(value, "%m-%d-%Y"))
    else
      super(nil)
    end
  end

  def go_number=(value)
    super(value.scan(/\d/).join)
  end
end
