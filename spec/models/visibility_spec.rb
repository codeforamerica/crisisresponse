# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Visibility, type: :model do
  describe "validations" do
    it "requires `creation_notes` on create" do
      visibility = build(:visibility, creation_notes: nil)

      expect(visibility).not_to be_valid
      expect(visibility.errors[:creation_notes]).to include("can't be blank")
    end

    it "does not require `removal_notes` on create" do
      visibility = build(:visibility, removal_notes: nil)

      expect(visibility).to be_valid
      expect(visibility.errors[:removal_notes]).to be_empty
    end

    it "requires `removed_by` and `removal_notes` if `removed_at` is set" do
      visibility = build(:visibility)

      visibility.removed_at = Time.current

      expect(visibility).not_to be_valid
      expect(visibility.errors[:removal_notes]).to include("can't be blank")
      expect(visibility.errors[:removed_by]).to include("can't be blank")
    end
  end
end
