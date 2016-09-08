require 'rails_helper'

RSpec.describe RMS::CrisisIncident, type: :model do
  describe ".frequent_behaviors" do
    it "returns a hash of behavior -> count based on incidents" do
      create(
        :incident,
        mania: true,
        disoriented_confused: true,
        excited_delirium: false,
      )
      create(
        :incident,
        mania: false,
        disoriented_confused: true,
        excited_delirium: false,
      )

      expect(RMS::CrisisIncident.frequent_behaviors).to eq(
        disoriented_confused: 2,
        mania: 1,
      )
    end
  end

  describe "#behaviors" do
    it "returns a list of behaviors that have been displayed" do
      incident = create(
        :incident,
        mania: true,
        disoriented_confused: true,
        excited_delirium: false,
      )

      expect(incident.behaviors).to match_array([:mania, :disoriented_confused])
    end
  end
end
