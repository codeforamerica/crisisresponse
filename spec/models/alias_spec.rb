require 'rails_helper'

RSpec.describe Alias, type: :model do
  describe "validations" do
    it { should validate_presence_of(:response_plan) }
    it { should validate_presence_of(:name) }

    context "uniqueness" do
      subject { build(:alias) }

      it { should validate_uniqueness_of(:name).scoped_to(:response_plan_id) }
    end
  end
end
