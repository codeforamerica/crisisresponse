require 'rails_helper'

RSpec.describe SafetyConcern, type: :model do
  describe "validations" do
    it { should validate_inclusion_of(:category).
         in_array(SafetyConcern::CATEGORIES) }
    it { should validate_presence_of :category }
    it { should validate_presence_of :description }
  end
end
