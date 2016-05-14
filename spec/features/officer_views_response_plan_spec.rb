require "rails_helper"

feature "Officer views a response plan" do
  scenario "They see the person's basic information" do
    response_plan = create(
      :response_plan,
      name: "John Doe",
      date_of_birth: Date.new(1980),
    )

    visit response_plan_path(response_plan)

    expect(page).to have_content("DOE, John")
    expect(page).to have_content(l(response_plan.date_of_birth))
  end

  scenario "They see the person's physical characteristics" do
    response_plan = create(
      :response_plan,
      eye_color: "Green",
      hair_color: "Brown",
      height_in_inches: 70,
      race: "WHITE",
      scars_and_marks: "Skull tattoo on neck",
      sex: "Male",
      weight_in_pounds: 180,
    )

    visit response_plan_path(response_plan)

    expect(page).to have_content("WM – 5'10\" – 180 lb")
    expect(page).to have_css(".physical .eye-color", text: "Green")
    expect(page).to have_css(".physical .hair-color", text: "Brown")
    expect(page).to have_content("Skull tattoo on neck")
  end

  scenario "They see the response plan steps" do
    response_plan = create(:response_plan)
    step_1 = create(:response_strategy, response_plan: response_plan, title: "Call case manager")
    step_2 = create(:response_strategy, response_plan: response_plan, title: "Transport to Harborview")

    visit response_plan_path(response_plan)

    expect(page).to have_content(step_1.title)
    expect(page).to have_content(step_2.title)
  end

  scenario "They see background information" do
    background_text = "This is the person's background info"
    response_plan = create(:response_plan, background_info: background_text)

    visit response_plan_path(response_plan)

    expect(page).to have_content(background_text)
  end

  scenario "They see emergency contacts" do
    response_plan = create(:response_plan)
    contact = create(
      :contact,
      response_plan: response_plan,
      name: "Jane Doe",
      relationship: "Case Worker",
      cell: "222-333-4444",
      notes: "Only available from 9am - 5pm",
    )

    visit response_plan_path(response_plan)

    expect(page).to have_content(contact.name)
    expect(page).to have_content(contact.relationship)
    expect(page).to have_content(contact.cell)
    expect(page).to have_content(contact.notes)
  end

  scenario "They see the preparing officer" do
    officer = create(:officer, name: "Jacques Clouseau")
    response_plan = create(:response_plan, author: officer)

    visit response_plan_path(response_plan)

    expect(page).to have_content("Prepared By Jacques Clouseau")
  end

  scenario "They see the approving officer" do
    officer = create(:officer, name: "Jacques Clouseau")
    response_plan = create(:response_plan, approver: officer)

    visit response_plan_path(response_plan)

    expect(page).to have_content("Approved By Jacques Clouseau")
  end

  context "when there are no safety warnings" do
    pending "they see 'No history of violence'" do
      response_plan = create(:response_plan)

      visit response_plan_path(response_plan)

      expect(page).to have_content(t("response_plan.safety.none"))
    end
  end

  context "when there are safety warnings" do
    pending "they see the safety warnings" do
      response_plan = create(:response_plan)
      warning = create(
        :safety_warning,
        response_plan: response_plan,
        description: "Owns a gun",
      )

      visit response_plan_path(response_plan)

      expect(page).to have_content("Owns a gun")
    end
  end
end
