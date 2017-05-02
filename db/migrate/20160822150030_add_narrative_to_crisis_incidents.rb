class AddNarrativeToCrisisIncidents < ActiveRecord::Migration
  def change
    add_column :crisis_incidents, :narrative, :text
  end
end
