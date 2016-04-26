require "rails_helper"

RSpec.describe Feedback, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end
end
