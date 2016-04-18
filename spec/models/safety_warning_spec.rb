require 'rails_helper'

RSpec.describe SafetyWarning, type: :model do
  it { should validate_presence_of :description }
  it { should validate_presence_of :person }
end
