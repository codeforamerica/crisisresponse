class SafetyWarning < ActiveRecord::Base
  belongs_to :person

  validates :description, presence: true
  validates :person, presence: true
end
