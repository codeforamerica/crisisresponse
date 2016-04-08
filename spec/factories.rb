FactoryGirl.define do
  factory :response_strategy do
    priority 1
    title "Contact case worker"
    description "Case worker is Sam Smith at DESC"
    person
  end

  factory :person do
    name "John Doe"
    sex "M"
    race "W"
    height_in_inches 66
    weight_in_pounds 160
    hair_color "black"
    eye_color "blue"
    date_of_birth { 25.years.ago }
  end
end
