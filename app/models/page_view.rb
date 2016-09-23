# frozen_string_literal: true

class PageView < ApplicationRecord
  belongs_to :officer
  belongs_to :person
end
