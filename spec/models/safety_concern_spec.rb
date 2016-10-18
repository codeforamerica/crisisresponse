require 'rails_helper'

RSpec.describe SafetyConcern, type: :model do
  describe "validations" do
    it { should validate_inclusion_of(:category).
         in_array(SafetyConcern::CATEGORIES) }
    it { should validate_presence_of :category }
    it { should validate_presence_of :title }
  end

  describe "#go_number=" do
    it "strips out all formatting" do
      concern = SafetyConcern.new(go_number: "GO #2016-01010101")

      expect(concern.go_number).to eq("201601010101")
    end
  end
end
