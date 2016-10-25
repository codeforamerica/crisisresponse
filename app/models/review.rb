# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :person
  belongs_to :created_by, class_name: "Officer"
end
