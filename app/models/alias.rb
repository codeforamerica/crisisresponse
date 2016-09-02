class Alias < ActiveRecord::Base
  belongs_to :person, touch: true

  validates :person, presence: true
  validates :name,
    presence: true,
    uniqueness: { scope: :person_id }
end
