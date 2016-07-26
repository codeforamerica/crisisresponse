FactoryGirl.define do
  factory :alias do
    name "John Doe"
    response_plan
  end

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
    aliases []
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
