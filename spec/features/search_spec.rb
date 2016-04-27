require "rails_helper"

feature "Search", :js do
  scenario "Officer searches by a person's name" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    person = create(:person, name: name, date_of_birth: dob)

    visit people_path

    fill_form_and_submit(:person_search, name: "John")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))

    fill_form_and_submit(:person_search, name: "Doe")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))

    fill_form_and_submit(:person_search, name: "John Doe")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))

    fill_form_and_submit(:person_search, name: "Doe John")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a person's DOB" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    person = create(:person, name: name, date_of_birth: dob)

    visit people_path

    fill_form_and_submit(:person_search, "DOB" => "1/2/80")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))

    fill_form_and_submit(:person_search, "DOB" => "1-2-1980")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))

    fill_form_and_submit(:person_search, "DOB" => "1-2-80")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))

    fill_form_and_submit(:person_search, "DOB" => "1980-1-2")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a person's name and DOB" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    person = create(:person, name: name, date_of_birth: dob)

    visit people_path

    fill_form_and_submit(:person_search, name: "Doe John", "DOB" => "1/2/80")

    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a name with no match" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    person = create(:person, name: name, date_of_birth: dob)

    visit people_path
    fill_form_and_submit(:person_search, name: "Mary")

    expect(page).to have_content(t("search.results.none"))
    expect(page).not_to have_content(person.display_name.upcase)
    expect(page).not_to have_content(l(dob))
  end

  scenario "Officer searches by a DOB with no match" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    person = create(:person, name: name, date_of_birth: dob)

    visit people_path

    fill_form_and_submit(:person_search, "DOB" => "2/3/86")
    expect(page).to have_content(t("search.results.none"))
    expect(page).not_to have_content(person.display_name.upcase)
    expect(page).not_to have_content(l(dob))
  end

  scenario "Officer searches by a name that's slightly off" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    person = create(:person, name: name, date_of_birth: dob)

    visit people_path

    fill_form_and_submit(:person_search, name: "Jon")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))

    fill_form_and_submit(:person_search, name: "Doh")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))

    fill_form_and_submit(:person_search, name: "Jon Doh")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))

    fill_form_and_submit(:person_search, name: "Doh Jon")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a DOB that's slightly off" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    person = create(:person, name: name, date_of_birth: dob)

    visit people_path

    fill_form_and_submit(:person_search, "DOB" => "1/2/81")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))

    fill_form_and_submit(:person_search, "DOB" => "1/2/79")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))

    fill_form_and_submit(:person_search, "DOB" => "1/2/80")
    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a name and DOB that are slightly off" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    person = create(:person, name: name, date_of_birth: dob)

    visit people_path

    fill_form_and_submit(:person_search, name: "Jon Doh", "DOB" => "1/2/81")

    expect(page).to have_content(person.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a name that matches, and DOB that doesn't" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    person = create(:person, name: name, date_of_birth: dob)

    visit people_path

    fill_form_and_submit(:person_search, name: "Jon Doh", "DOB" => "1/2/85")

    expect(page).to have_content(t("search.results.none"))
    expect(page).not_to have_content(person.display_name.upcase)
    expect(page).not_to have_content(l(dob))
  end

  scenario "Officer searches by a DOB that matches, and name that doesn't" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    person = create(:person, name: name, date_of_birth: dob)

    visit people_path

    fill_form_and_submit(:person_search, name: "Mary", "DOB" => "1/2/80")

    expect(page).to have_content(t("search.results.none"))
    expect(page).not_to have_content(person.display_name.upcase)
    expect(page).not_to have_content(l(dob))
  end
end
