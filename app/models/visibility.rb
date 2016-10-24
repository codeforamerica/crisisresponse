# frozen_string_literal: true

class Visibility < ApplicationRecord
  belongs_to :person
  belongs_to :removed_by, class_name: "Officer"
  belongs_to :created_by, class_name: "Officer"

  validates :person, presence: true
  validates :creation_notes, presence: true

  validates :removed_by, presence: true, if: -> { removed_at.present? }
  validates :removal_notes, presence: true, if: -> { removed_at.present? }

  def self.active
    where(removed_at: nil)
  end
end
