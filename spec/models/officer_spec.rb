require 'rails_helper'

RSpec.describe Officer, type: :model do
  describe "associations" do
    it { should have_many(:authored_response_plans).dependent(:destroy) }
    it { should have_many(:approved_response_plans).dependent(:destroy) }
  end
end
