class AddXmlCrisisIdToRmsCrisisIncidents < ActiveRecord::Migration
  def change
    add_column :rms_crisis_incidents, :xml_crisis_id, :integer, null: false
    add_column :rms_crisis_incidents, :narrative, :text
  end
end
