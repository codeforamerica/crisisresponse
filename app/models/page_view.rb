class PageView < ActiveRecord::Base
  belongs_to :officer
  belongs_to :person
end
