class RMS::CrisisIncident < ActiveRecord::Base
  belongs_to :rms_person, class_name: "RMS::Person"
end
