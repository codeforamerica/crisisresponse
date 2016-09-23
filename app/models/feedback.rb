# frozen_string_literal: true

class Feedback < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
end
