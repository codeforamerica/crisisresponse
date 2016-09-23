# frozen_string_literal: true

class Alias < ApplicationRecord
  belongs_to :person, touch: true

  validates :person, presence: true
  validates :name,
    presence: true,
    uniqueness: { scope: :person_id }
end
