class Image < ActiveRecord::Base
  belongs_to :response_plan

  mount_uploader :source, ImageUploader
end
