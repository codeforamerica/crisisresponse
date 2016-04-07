require "rails_helper"

feature "Officer views a response plan" do
  scenario "They see the person's basic information" do
    person = create(:person, name: "John Doe")

    visit person_path(person)

    expect(page).to have_content(person.name)
#    expect(page).to have_content(person.sex)
#    expect(page).to have_content(person.race)
#    expect(page).to have_content(person.height)
#    expect(page).to have_content(person.weight)
#    expect(page).to have_content(person.hair_color)
#    expect(page).to have_content(person.eye_color)
#    expect(page).to have_content(person.date_of_birth)
  end
end
