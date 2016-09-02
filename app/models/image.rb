class Image < ActiveRecord::Base
  belongs_to :person, touch: true

  mount_uploader :source, ImageUploader
end
