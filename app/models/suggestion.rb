# frozen_string_literal: true

class Suggestion < ApplicationRecord
  belongs_to :officer
  belongs_to :person

  validates :person, presence: true
  validates :officer, presence: true
  validates :body, presence: true

  def person_name
    person.display_name
  end
end
