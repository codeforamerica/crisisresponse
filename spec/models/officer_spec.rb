require "rails_helper"
require "shared/analytics_token"

RSpec.describe Officer, type: :model do
  it_should_behave_like "it has an analytics token"

  describe "associations" do
    it { should have_many(:authored_response_plans).dependent(:destroy) }
    it { should have_many(:approved_response_plans).dependent(:destroy) }
  end
end
