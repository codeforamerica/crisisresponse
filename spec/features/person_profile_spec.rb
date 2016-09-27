require "rails_helper"

feature "Officer views a response plan" do
  scenario "They see the person's basic information", :js do
    sign_in_officer
    person = create(
      :person,
      name: "John Doe",
      date_of_birth: Date.new(1980),
    )

    visit people_path
    find(".person-description", text: person.shorthand_description).click

    expect(page).to have_content("DOE, John")
    expect(page).to have_content(l(person.date_of_birth))
    expect(page).to have_content(person.shorthand_description)
  end

  scenario "They see the person's pictures", :js do
    sign_in_officer
    images = [
      Image.new(source: File.open(Rails.root + "spec/fixtures/image.jpg")),
      Image.new(source: File.open(Rails.root + "spec/fixtures/secondary_image.jpg")),
    ]
    person = create(:person, images: images)

    visit person_path(person)
    expect(page).to have_focused_image(person.images.first)

    find(".image-scroll-arrow[data-direction='next']").click
    skip "
    This must be tested with Javascript.
    The Poltergeist driver can not handle finding the image on the page."
    expect(page).to have_focused_image(person.images.last)
  end

  scenario "when user has no pictures they cannot scroll images"

  def have_focused_image(image)
    have_css("img.focused-image[src='#{image.source_url}']")
  end

  scenario "They see the person's physical characteristics" do
    sign_in_officer
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

  scenario "They see the person's location" do
    sign_in_officer
    person = create(
      :person,
      location_name: "Residence",
      location_address: "123 Main St, Seattle, WA",
    )

    visit person_path(person)

    expect(page).to have_content("Residence")
    expect(page).to have_content("123 Main St")
    expect(page).to have_content("Seattle, WA")
  end

  scenario "They see the person's aliases" do
    sign_in_officer
    aliases = ["Mark Smith", "Joe Andrews"]
    person = create(:person, name: "John Doe")
    aliases.each { |aka| create(:alias, name: aka, person: person) }

    visit person_path(person)

    aliases.each { |aka| expect(page).to have_content(aka) }
  end

  scenario "They see deescalation techniques" do
    sign_in_officer
    response_plan = create(:response_plan)
    step_1 = create(:deescalation_technique, response_plan: response_plan, description: "Ask about their dog")
    step_2 = create(:deescalation_technique, response_plan: response_plan, description: "Talk about the weather")

    visit person_path(response_plan.person)

    expect(page).to have_content(step_1.description)
    expect(page).to have_content(step_2.description)
  end

  scenario "They see triggers" do
    sign_in_officer
    response_plan = create(:response_plan)
    step_1 = create(:trigger, response_plan: response_plan, description: "Ask about their dog")
    step_2 = create(:trigger, response_plan: response_plan, description: "Talk about the weather")

    visit person_path(response_plan.person)

    expect(page).to have_content(step_1.description)
    expect(page).to have_content(step_2.description)
  end

  scenario "They see the response plan steps" do
    sign_in_officer
    response_plan = create(:response_plan)
    step_1 = create(:response_strategy, response_plan: response_plan, title: "Call case manager")
    step_2 = create(:response_strategy, response_plan: response_plan, title: "Transport to Harborview")

    visit person_path(response_plan.person)

    expect(page).to have_content(step_1.title)
    expect(page).to have_content(step_2.title)
  end

  scenario "They see background information" do
    sign_in_officer
    background_text = "This is the person's background info"
    response_plan = create(:response_plan, background_info: background_text)

    visit person_path(response_plan.person)

    expect(page).to have_content(background_text)
  end

  scenario "They see emergency contacts" do
    sign_in_officer
    response_plan = create(:response_plan)
    contact = create(
      :contact,
      response_plan: response_plan,
      name: "Jane Doe",
      relationship: "Case Worker",
      cell: "222-333-4444",
      notes: "Only available from 9am - 5pm",
    )

    visit person_path(response_plan.person)

    expect(page).to have_content(contact.name)
    expect(page).to have_content(contact.relationship)
    expect(page).to have_content(contact.cell)
    expect(page).to have_content(contact.notes)
  end

  scenario "They see the author and approver" do
    sign_in_officer
    author = create(:officer, name: "Jacques Clouseau")
    approver = create(:officer, name: "Sherlock Holmes")
    response_plan = create(:response_plan, author: author, approver: approver)

    visit person_path(response_plan.person)

    expect(page).to have_content("Prepared by Jacques Clouseau")
    expect(page).to have_content("Approved by Sherlock Holmes")
  end

  context "when there are no safety concerns" do
    pending "they see a note saying there are no concerns" do
      sign_in_officer
      response_plan = create(:response_plan)

      visit person_path(response_plan.person)

      expect(page).to have_content(t("safety_concerns.none"))
    end
  end

  context "when there are safety concerns" do
    scenario "they see the safety concerns" do
      sign_in_officer
      response_plan = create(:response_plan)
      concern = create(
        :safety_concern,
        response_plan: response_plan,
        description: "Owns a gun",
      )

      visit person_path(response_plan.person)

      expect(page).to have_content("Owns a gun")
    end
  end
end
