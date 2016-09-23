# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :person, touch: true

  mount_uploader :source, ImageUploader
end
