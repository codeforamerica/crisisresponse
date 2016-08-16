require 'rails_helper'
require "shared/person_validations"

RSpec.describe RMS::Person, type: :model do
  describe "associations" do
    it "belongs to a Person model in the root namespace" do
      rms_person = create(:rms_person)

      rms_person.reload

      expect(rms_person.person).to be_instance_of(Person)
    end
  end

  describe "validations" do
    it_should_behave_like "a validated person"
  end
end
