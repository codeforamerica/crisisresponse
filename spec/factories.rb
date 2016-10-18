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
    name "Johnson"
    phone "222-333-4444"
    sequence(:username) { |n| "officer_#{n}" }
    title "Officer"
    unit "Crisis Response Unit"

    trait :admin do
      role Officer::ADMIN
    end
  end

  factory :page_view do
    officer
    person
  end

  factory :person do
    first_name "John"
    middle_initial "Q"
    last_name "Doe"
    sex "Male"
    race "AFRICAN AMERICAN/BLACK"
    height_in_inches 66
    weight_in_pounds 160
    hair_color "black"
    eye_color "blue"
    date_of_birth { 25.years.ago }
    visible true
  end

  factory :response_plan, aliases: [:plan] do
    person
    author
    approver
    updated_at { 1.second.ago }
    submitted_for_approval_at { 1.second.ago }

    trait :approved # This is the default

    trait :draft do
      submitted_for_approval_at nil
      approver nil
      approved_at nil
    end

    trait :submission do
      approver nil
      approved_at nil
    end
  end

  factory :suggestion do
    officer
    person
    body "MyText"
    urgent false
  end

  factory :response_strategy do
    priority 1
    title "Contact case worker"
    description "Case worker is Sam Smith at DESC"
    response_plan
  end

  factory :rms_person, class: "RMS::Person" do
    person
    first_name "John"
    middle_initial "Q"
    last_name "Doe"
    sex "Male"
    race "AFRICAN AMERICAN/BLACK"
    height_in_inches 66
    weight_in_pounds 160
    hair_color "black"
    eye_color "blue"
    date_of_birth { 25.years.ago }
    pin "0123456789abcdef"
  end

  factory(
    :rms_crisis_incident,
    aliases: [:incident],
    class: "RMS::CrisisIncident",
  ) do
    rms_person
    reported_at { 1.week.ago }
    go_number "2016001234"
    xml_crisis_id "12345"
  end

  factory :safety_concern do
    category { SafetyConcern::CATEGORIES.sample }
    title "History of violence"
    response_plan
  end

  factory :trigger do
    description "MyString"
    response_plan
  end
end
