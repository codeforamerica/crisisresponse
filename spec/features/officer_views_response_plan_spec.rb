require "rails_helper"

feature "Officer views a response plan" do
  scenario "They see the person's basic information" do
    person = create(
      :person,
      name: "John Doe",
      sex: "M",
      race: "W",
      height_in_inches: 66,
      weight_in_pounds: 160,
      hair_color: "black",
      eye_color: "blue",
      date_of_birth: Date.new(1980),
    )

    visit person_path(person)

    expect(page).to have_content(person.name)
    expect(page).to have_content(person.sex)
    expect(page).to have_content(person.race)
    expect(page).to have_content(person.height_in_inches)
    expect(page).to have_content(person.weight_in_pounds)
    expect(page).to have_content(person.hair_color)
    expect(page).to have_content(person.eye_color)
    expect(page).to have_content(person.date_of_birth)
  end

  scenario "They see the response plan steps" do
    person = create(:person)
    step_1 = create(:response_strategy, person: person, title: "Call case manager")
    step_2 = create(:response_strategy, person: person, title: "Transport to Harborview")

    visit person_path(person)

    expect(page).to have_content(step_1.title)
    expect(page).to have_content(step_2.title)
  end
end
