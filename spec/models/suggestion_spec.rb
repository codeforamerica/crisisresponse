require 'rails_helper'

RSpec.describe Suggestion, type: :model do
  describe "validations" do
    it { should validate_presence_of(:person) }
    it { should validate_presence_of(:officer) }
    it { should validate_presence_of(:body) }
  end
end
