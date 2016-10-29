# frozen_string_literal: true

require "rails_helper"

describe OfficerSearch do
  it "searches by name"
  it "searches by username"

  describe "searching by name" do
    it "does not return records whose names do not match" do
      _mismatch = create(:officer, name: "John Doe")

      matches = OfficerSearch.new(name: "Mary").results

      expect(matches).to eq([])
    end

    it "returns records that match on first name" do
      officer = create(:officer, name: "John Doe")

      matches = OfficerSearch.new(name: "John").results

      expect(matches).to eq([officer])
    end

    it "returns records that match on last name" do
      officer = create(:officer, name: "John Doe")

      matches = OfficerSearch.new(name: "Doe").results

      expect(matches).to eq([officer])
    end

    it "returns records that match on the full name" do
      officer = create(:officer, name: "John Doe")

      matches = OfficerSearch.new(name: "John Doe").results

      expect(matches).to eq([officer])
    end

    it "returns records that match on the reversed name" do
      officer = create(:officer, name: "John Doe")

      matches = OfficerSearch.new(name: "Doe John").results

      expect(matches).to eq([officer])
    end

    it "returns records whose first names sound similar" do
      officer = create(:officer, name: "John Doe")

      matches = OfficerSearch.new(name: "Jon").results

      expect(matches).to eq([officer])
    end

    it "returns records whose last names sound similar" do
      officer = create(:officer, name: "John Doe")

      matches = OfficerSearch.new(name: "Doh").results

      expect(matches).to eq([officer])
    end

    it "returns records whose full names sound similar" do
      officer = create(:officer, name: "John Doe")

      matches = OfficerSearch.new(name: "Jon Doh").results

      expect(matches).to eq([officer])
    end

    it "returns records whose reversed full names sound similar" do
      officer = create(:officer, name: "John Doe")

      matches = OfficerSearch.new(name: "Doh Jon").results

      expect(matches).to eq([officer])
    end

    it "returns matching or close usernames" do
      match = create(:officer, name: "Foo", username: "johnson")
      close = create(:officer, name: "Foo", username: "johnsen")
      _mismatch = create(:officer, name: "Foo", username: "adams")

      matches = OfficerSearch.new(name: "johnson").results

      expect(matches).to match_array([match, close])
    end
  end
end
