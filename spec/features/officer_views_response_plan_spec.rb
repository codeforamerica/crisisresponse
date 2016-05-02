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

  scenario "They see emergency contacts" do
    person = create(:person)
    contact = create(
      :contact,
      person: person,
      name: "Jane Doe",
      relationship: "Case Worker",
      cell: "222-333-4444",
      notes: "Only available from 9am - 5pm",
    )

    visit person_path(person)

    expect(page).to have_content(contact.name)
    expect(page).to have_content(contact.relationship)
    expect(page).to have_content(contact.cell)
    expect(page).to have_content(contact.notes)
  end

  scenario "They see the preparing officer" do
    officer = create(:officer, name: "Jacques Clouseau")
    person = create(:person, author: officer)

    visit person_path(person)

    expect(page).to have_content("Prepared By Jacques Clouseau")
  end

  scenario "They see the approving officer" do
    officer = create(:officer, name: "Jacques Clouseau")
    person = create(:person, approver: officer)

    visit person_path(person)

    expect(page).to have_content("Approved By Jacques Clouseau")
  end

  context "when there are no safety warnings" do
    scenario "they see 'No history of violence'" do
      person = create(:person)

      visit person_path(person)

      expect(page).to have_content(t("response_plan.safety.none"))
    end
  end

  context "when there are safety warnings" do
    scenario "they see the safety warnings" do
      person = create(:person)
      warning = create(
        :safety_warning,
        person: person,
        description: "Owns a gun",
      )

      visit person_path(person)

      expect(page).to have_content("Owns a gun")
    end
  end
end
