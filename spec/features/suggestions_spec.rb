# frozen_string_literal: true

require "rails_helper"
require "email_service"

feature "Suggestions" do
  scenario "patrol officer submits a suggestion" do
    allow(EmailService).to receive(:send)
    person = create(:person)
    officer = create(:officer)
    sign_in_officer(officer)
    suggestion_body = "This is a sample suggestion"

    visit person_path(person)
    click_on t("profile.suggestions.new")
    fill_in t("simple_form.labels.suggestion.body"), with: suggestion_body
    find("#suggestion_urgent").set(true)
    click_on "Submit"

    expect(page).to have_content(t("suggestions.create.success"))
    expect(page).to have_content(person.display_name)
    expect(page).to have_content(suggestion_body)

    suggestion = Suggestion.last
    expect(suggestion.officer).to eq(officer)
    expect(suggestion.person).to eq(person)
    expect(suggestion.body).to eq(suggestion_body)

    expect(EmailService).to have_received(:send)
  end
end
