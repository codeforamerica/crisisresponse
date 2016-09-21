# frozen_string_literal: true

require "rails_helper"

feature "Core Profile" do
  it "displays the number of crisis incidents in the past year" do
    sign_in_officer
    rms_person = create(:rms_person)
    create(:incident, reported_at: 18.months.ago, rms_person: rms_person)
    create(:incident, reported_at: 6.months.ago, rms_person: rms_person)
    create(:incident, reported_at: 1.day.ago, rms_person: rms_person)

    visit person_path(rms_person.person)

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
    rms_person = create(:rms_person)
    create(:incident, mania: true, rms_person: rms_person)
    create(:incident, mania: false, rms_person: rms_person)

    visit person_path(rms_person.person)

    expect(page).to have_content "Mania 1 (50%)"
  end

  it "shows recent incident narratives" do
    sign_in_officer
    rms_person = create(:rms_person)
    narrative = "This is a crisis incident narrative."
    incident = create(:incident, narrative: narrative, rms_person: rms_person)

    visit person_path(rms_person.person)
    expect(page).to have_content(narrative)

    click_on "Template Narrative >"
    expect(page).to have_content(narrative)
    expect(current_path).to eq(incident_path(incident))
  end
end
