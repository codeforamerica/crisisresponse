class RMS::Person < ActiveRecord::Base
  belongs_to :person

  validates :person, presence: true
end
