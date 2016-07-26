class Image < ActiveRecord::Base
  belongs_to :person

  mount_uploader :source, ImageUploader
end
