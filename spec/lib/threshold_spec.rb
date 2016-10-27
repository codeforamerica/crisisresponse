# frozen_string_literal: true

require "rails_helper"
require "threshold"

describe Threshold do
  context "when the person has not been visible before" do
    it "makes them visible to patrol officers" do
      person = create(:person, visible: false)
      rms_person = create(:rms_person, person: person)
      create(:incident, rms_person: rms_person)

      expect do
        Threshold.new(1).create_visibilities_over_threshold
      end.to change(Visibility, :count).by(1)

      visibility = Visibility.last
      expect(visibility.person).to eq(person)
      expect(visibility.creation_notes).
        to eq("[AUTO] Person crossed the threshold of 1 RMS Crisis Incident")
      expect(person.reload).to be_visible
    end
  end

  context "when the person has been manually set to visible" do
    it "doesn't change their visibility" do
      person = create(:person)
      visibility = create(:visibility, person: person, created_by: nil)

      expect do
        Threshold.new.remove_visibilities_below_threshold
      end.not_to change(Visibility, :count)

      expect(visibility.person).to eq(person)
      expect(person.reload).to be_visible
    end
  end

  context "when the person has been automatically removed from visiblity" do
    it "updates their visibility" do
      person = create(:person, visible: false)
      rms_person = create(:rms_person, person: person)
      create(:incident, rms_person: rms_person)
      create(:visibility, :removed, person: person, removed_by: nil)

      expect do
        Threshold.new(1).create_visibilities_over_threshold
      end.to change(Visibility, :count)

      expect(person.reload).to be_visible
    end
  end

  context "when a person has been manually removed from visibility" do
    it "does not update their visibility" do
      incident = create(:incident)
      person = create(:person, rms_person: incident.rms_person, visible: false)
      create(
        :visibility,
        :removed,
        person: person,
        removed_by: create(:officer),
      )

      expect do
        Threshold.new(1).create_visibilities_over_threshold
      end.not_to change(Visibility, :count)

      expect(person.reload).not_to be_visible
    end
  end

  context "when the person has automatically been marked as visible" do
    it "removes their visibility" do
      person = create(:person, visible: false)
      visibility = create(:visibility, created_by: nil, person: person)

      Threshold.new.remove_visibilities_below_threshold

      expect(person.reload).not_to be_visible
      expect(visibility.reload).to be_removed_automatically
    end
  end
end
