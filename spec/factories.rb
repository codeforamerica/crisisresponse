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

  factory :officer, aliases: [:author, :approver, :created_by, :removed_by] do
    name "Johnson"
    phone "222-333-4444"
    sequence(:username) { |n| "officer_#{n}" }

    trait :admin do
      role Officer::ADMIN
    end

    trait :owner do
      role Officer::OWNER
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

    transient do
      visible true
    end

    after(:create) do |person, evaluator|
      if evaluator.visible
        create(:visibility, person: person)
      end
    end
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

  factory :review do
    person
    created_by
    notes "Looks good to me."
  end

  factory(
    :crisis_incident,
    aliases: [:incident]
  ) do
    person
    reported_at { 1.week.ago }
    go_number "2016001234"
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

  factory :visibility do
    person
    created_by
    creation_notes "Crossed incident threshold"
    removed_at nil
    removal_notes nil
    removed_by nil

    trait :removed do
      removed_by
      removed_at { Time.current }
      removal_notes "They've moved away from Seattle"
    end
  end
end
