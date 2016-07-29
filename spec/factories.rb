FactoryGirl.define do
  factory :alias do
    name "John Doe"
    person
  end

  factory :contact do
    response_plan
    name "MyString"
    relationship "MyString"
    cell "MyString"
    notes "MyString"
  end

  factory :deescalation_technique do
    description "MyString"
    response_plan
  end

  factory :feedback do
    name "MyString"
    description "MyText"
  end

  factory :image do
    source { File.open(Rails.root + "spec/fixtures/image.jpg") }
    response_plan
  end

  factory :officer, aliases: [:author, :approver] do
    title "Officer"
    name "Johnson"
    unit "Crisis Response Unit"
    phone "222-333-4444"
  end

  factory :person do
    name "John Doe"
    sex "Male"
    race "AFRICAN AMERICAN/BLACK"
    height_in_inches 66
    weight_in_pounds 160
    hair_color "black"
    eye_color "blue"
    date_of_birth { 25.years.ago }
  end

  factory :response_plan do
    person
    author
    approver
    updated_at { 1.second.ago }
  end

  factory :response_strategy do
    priority 1
    title "Contact case worker"
    description "Case worker is Sam Smith at DESC"
    response_plan
  end

  factory :rms_person, :class => 'Rms::Person' do
    name "John Doe"
    sex "Male"
    race "AFRICAN AMERICAN/BLACK"
    height_in_inches 66
    weight_in_pounds 160
    hair_color "black"
    eye_color "blue"
    date_of_birth { 25.years.ago }
    pin "0123456789abcdef"
  end

  factory :rms_crisis_incident, :class => 'Rms::CrisisIncident' do
    rms_person
    reported_at { 1.week.ago }
    go_number "2016001234"
  end

  factory :safety_concern do
    category { SafetyConcern::CATEGORIES.sample }
    description "History of violence"
    response_plan

    physical_or_threat do
      if SafetyConcern::ASSAULTIVE_CATEGORIES.include? category
        [:physical, :threat].sample
      else
        nil
      end
    end
  end
end
