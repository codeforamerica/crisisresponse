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

    it "requires `removal_notes` if `removed_at` is set" do
      visibility = build(:visibility)

      visibility.removed_at = Time.current

      expect(visibility).not_to be_valid
      expect(visibility.errors[:removal_notes]).to include("can't be blank")
    end
  end

  describe "removed_automatically?" do
    it "is true if there is no remover" do
      visibility = build(:visibility, :removed, removed_by: nil)

      expect(visibility).to be_removed_automatically
    end

    it "is false if it was removed by an offier" do
      visibility = build(:visibility, :removed, removed_by: create(:officer))

      expect(visibility).not_to be_removed_automatically
    end

    it "is false if it is not removed" do
      visibility = build(:visibility)

      expect(visibility).not_to be_removed_automatically
    end
  end
end
