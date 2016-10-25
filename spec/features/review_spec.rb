# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Review profiles" do
  scenario "officer reviews a profile" do
    person = create(:person, visible: false, created_at: before_threshold)
    create(:visibility, person: person, created_at: before_threshold)

    sign_in_officer create(:officer, :admin)
    visit person_path(person)
    expect(page).
      to have_content t("people.show.review.required", name: person.last_name)
    click_on t("people.show.review.new")
    fill_in "Notes", with: "Looks good to me"
    click_on t("helpers.submit.review.create")

    expect(page).to have_content \
      t("reviews.create.success", name: person.last_name)
    expect(page).not_to have_content \
      t("people.show.review.required", name: person.last_name)
    expect(page).not_to have_link t("people.show.review.new")
  end

  scenario "officer views profiles that need review" do
    person = create(:person, visible: false, created_at: before_threshold)
    create(:visibility, person: person, created_at: before_threshold)

    sign_in_officer create(:officer, :admin)
    visit profiles_path

    expect(page).to have_content(person.name)
    click_on "REVIEW"

    expect(current_path).to eq(person_path(person))
  end

  def before_threshold
    (review_threshold + 1).months.ago
  end

  def review_threshold
    ENV.fetch("PROFILE_REVIEW_TIMEFRAME_IN_MONTHS").to_i
  end
end
