# frozen_string_literal: true

class Visibility < ApplicationRecord
  belongs_to :person
  belongs_to :removed_by, class_name: "Officer"
  belongs_to :created_by, class_name: "Officer"
end
