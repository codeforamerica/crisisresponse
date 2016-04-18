require "rails_helper"

feature "Officer views a response plan" do
  scenario "They see the person's basic information" do
    person = create(
      :person,
      name: "John Doe",
      date_of_birth: Date.new(1980),
    )

    visit person_path(person)

    expect(page).to have_content(person.name)
    expect(page).to have_content(person.date_of_birth)
  end

  scenario "They see the person's physical characteristics" do
    person = create(
      :person,
      eye_color: "Green",
      hair_color: "Brown",
      height_in_inches: 70,
      race: "WHITE",
      scars_and_marks: "Skull tattoo on neck",
      sex: "Male",
      weight_in_pounds: 180,
    )

    visit person_path(person)

    expect(page).to have_content("WM – 5'10\" – 180 lb")
    expect(page).to have_css(".physical .eye-color", text: "Green")
    expect(page).to have_css(".physical .hair-color", text: "Brown")
    expect(page).to have_content("Skull tattoo on neck")
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
