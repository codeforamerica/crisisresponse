require "rails_helper"

feature "nested forms", :js do
  scenario "adding a nested response strategy" do
    person = create(:person)

    visit edit_admin_person_path(person)
    click_on "Add Response Strategy"
    first("input[name*='[title]']").set("Response strategy 1")
    first("textarea[name*='[description]']").set("Response strategy description 1")
    click_on "Update Person"

    expect(page).to have_content("Response strategy 1")
    expect(person.reload.response_strategies.first.description).
      to eq("Response strategy description 1")
  end

  scenario "removing a nested response strategy" do
    title = "Call case manager"
    person = create(:person)
    create(:response_strategy, person: person, title: title)

    visit edit_admin_person_path(person)
    click_on "Remove Response Strategy"
    click_on "Update Person"

    expect(page).not_to have_content(title)
  end

  scenario "updating a nested response strategy" do
    title = "Call case manager"
    person = create(:person)
    create(:response_strategy, person: person, title: title)

    visit edit_admin_person_path(person)
    first("input[name*='[title]']").set("Response strategy 1")
    click_on "Update Person"

    expect(page).not_to have_content(title)
    expect(page).to have_content("Response strategy 1")
  end
end
