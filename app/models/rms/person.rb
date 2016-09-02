class RMS::Person < ActiveRecord::Base
  include PersonValidations

  belongs_to :person, class_name: "::Person", touch: true
  has_many :crisis_incidents, foreign_key: "rms_person_id", dependent: :destroy

  validates :person, presence: true
end
