require 'rails_helper'

RSpec.describe CrisisIncident, type: :model do
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

      expect(CrisisIncident.frequent_behaviors).to eq(
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

  describe "#dispositions" do
    it "returns a list of dispositions that have been displayed" do
      incident = create(
        :incident,
        emergent_ita: true,
        grat: true,
        shelter: false,
      )

      expect(incident.dispositions).to match_array([:emergent_ita, :grat])
    end
  end
end
