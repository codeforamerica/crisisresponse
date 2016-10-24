# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Visibility" do
  scenario "an admin marks someone as visible" do
    person = create(:person, visible: false)

    sign_in_officer create(:officer, :admin)
    visit person_path(person)
    click_on t("people.show.visibility.new")
    fill_in "Notes", with: "This person is dangerous to officers"
    click_on "Create Visibility"

    expect(page).
      to have_content t("visibilities.create.success", name: person.last_name)
    expect(page).
      to have_content t("people.show.visibility.exists", name: person.last_name)
    expect(person.reload).to be_visible
  end

  scenario "an admin removes someone from view" do
    person = create(:person, visible: true)

    sign_in_officer create(:officer, :admin)
    visit person_path(person)
    click_on t("people.show.visibility.show")
    fill_in "Notes", with: "This person has moved out of Seattle"
    click_on "Update Visibility"

    expect(page).
      to have_content t("visibilities.update.success", name: person.last_name)
    expect(page).to have_content t(
      "people.show.visibility.does_not_exist",
      name: person.last_name,
    )
    expect(person.reload).not_to be_visible
  end
end
