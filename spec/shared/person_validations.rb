RSpec.shared_examples "a validated person" do
  it { should allow_value("Female").for(:sex) }
  it { should allow_value("Male").for(:sex) }
  it { should allow_value(nil).for(:sex) }
  it { should_not allow_value("FEMALE").for(:sex) }
  it { should_not allow_value("M").for(:sex) }

  it { should allow_value("AFRICAN AMERICAN/BLACK").for(:race) }
  it { should allow_value("AMERICAN INDIAN/ALASKAN NATIVE").for(:race) }
  it { should allow_value("ASIAN (ALL)/PACIFIC ISLANDER").for(:race) }
  it { should allow_value("UNKNOWN").for(:race) }
  it { should allow_value("WHITE").for(:race) }
  it { should allow_value(nil).for(:race) }
  it { should_not allow_value("BLACK").for(:race) }
  it { should_not allow_value("W").for(:race) }
  it { should_not allow_value("White").for(:race) }

  it { should allow_value("A").for(:middle_initial) }
  it { should_not allow_value("AB").for(:middle_initial) }
end
