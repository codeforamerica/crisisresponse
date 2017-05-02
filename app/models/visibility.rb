# frozen_string_literal: true

# If `created_by` or `removed_by` are nil,
# we assume that the visibility was automatically created or removed
class Visibility < ApplicationRecord
  belongs_to :person
  belongs_to :removed_by, class_name: "Officer"
  belongs_to :created_by, class_name: "Officer"

  validates :person, presence: true
  validates :creation_notes, presence: true
  validates :removal_notes, presence: true, if: -> { removed_at.present? }

  def self.active
    where(removed_at: nil)
  end

  def removed_automatically?
    removed_at.present? && removed_by.nil?
  end
end
