# frozen_string_literal: true

require "rails_helper"

feature "Core Profile" do
  it "displays the number of crisis incidents in the past year" do
    sign_in_officer
    person = create(:person)
    create(:incident, reported_at: 18.months.ago, person: person)
    create(:incident, reported_at: 6.months.ago, person: person)
    create(:incident, reported_at: 1.day.ago, person: person)

    visit person_path(person)

    expect(page).to have_content("2 CRISIS calls (in the last year)")
    expect(page).to have_content("1 CRISIS call within the last 7 days")
  end

  it "does not show the recent crisis count if there are no recent incidents" do
    sign_in_officer
    person = create(:person)

    visit person_path(person)

    expect(page).not_to have_content t("profile.core.incident_count.recent")
  end

  it "shows recent behaviors" do
    sign_in_officer
    person = create(:person)
    create(:incident, mania: true, person: person)
    create(:incident, mania: false, person: person)

    visit person_path(person)

    expect(page).to have_content "Mania 1 (50%)"
  end

  it "shows recent incident narratives" do
    sign_in_officer
    person = create(:person)
    narrative = "This is a crisis incident narrative."
    incident = create(:incident, narrative: narrative, person: person)

    visit person_path(person)
    expect(page).to have_content(narrative)

    click_on "Template Narrative >"
    expect(page).to have_content(narrative)
    expect(current_path).to eq(incident_path(incident))
  end

  it "shows 3-month and 2-year graphs", :js do
    sign_in_officer
    person = create(:person)
    create(:incident, reported_at: 2.months.ago, person: person)
    create(:incident, reported_at: 18.months.ago, person: person)

    visit person_path(person)
    within(".profile-incidents") do
      expect(page).to have_content("1 CRISIS calls")
    end

    find(".incident-charts-toggle").trigger(:click)
    within(".profile-incidents") do
      expect(page).to have_content("2 CRISIS calls")
    end
  end

  scenario "admins can view non-visible profiles" do
    admin = create(:officer, :admin)
    sign_in_officer(admin)
    person = create(:person, visible: false)

    visit person_path(person)

    expect(page).to have_content(l(person.date_of_birth))
  end

  scenario "non-admins can only view visible profiles" do
    officer = create(:officer)
    sign_in_officer(officer)
    person = create(:person, visible: false)

    expect do
      visit person_path(person)
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end
