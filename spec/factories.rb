FactoryGirl.define do
  factory :contact do
    response_plan nil
    name "MyString"
    relationship "MyString"
    cell "MyString"
    notes "MyString"
  end

  factory :feedback do
    name "MyString"
    description "MyText"
  end

  factory :officer, aliases: [:author, :approver] do
    title "Officer"
    name "Johnson"
    unit "Crisis Response Unit"
    phone "222-333-4444"
  end

  factory :response_plan do
    author
    approver
    name "John Doe"
    sex "Male"
    race "AFRICAN AMERICAN/BLACK"
    height_in_inches 66
    weight_in_pounds 160
    hair_color "black"
    eye_color "blue"
    date_of_birth { 25.years.ago }
  end

  factory :response_strategy do
    priority 1
    title "Contact case worker"
    description "Case worker is Sam Smith at DESC"
    response_plan
  end

  factory :safety_warning do
    description "History of violence"
    response_plan
  end
end
