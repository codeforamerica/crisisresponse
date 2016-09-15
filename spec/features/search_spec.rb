# frozen_string_literal: true

require "rails_helper"

feature "Search" do
  scenario "Officer searches and finds a record" do
    sign_in_officer
    dob = Date.new(1980, 1, 2)
    person = create(:person, name: "John Doe", date_of_birth: dob)

    visit people_path

    search_for(name: "John")
    expect(page).to have_content("DOE, John")
    expect(page).to have_content(l(dob))
    expect(page).to have_content(person.shorthand_description)

    click_on "Profile"
    expect(current_path).to eq(person_path(person))
  end

  scenario "Officer searches and doesn't find a record" do
    sign_in_officer
    dob = Date.new(1980, 1, 2)
    create(:person, name: "John Doe", date_of_birth: dob)

    visit people_path

    search_for(name: "Mary")
    expect(page).to have_content(t("search.results.none"))
    expect(page).not_to have_content("John")
    expect(page).not_to have_content(l(dob))

    find(".filter-remove").click
    expect(page).to have_content("John")
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches for a malformed date" do
    sign_in_officer

    visit people_path

    search_for("DOB" => "foobar")
    expect(page).to have_content("Ignored invalid date. Try 'mm-dd-yyyy'")
  end

  def search_for(params)
    within(".search") do
      fill_form(:search, params)
      first(".actions input").click
    end
  end

  feature "Physicals search", :js do
    scenario "Officer searches by age" do
      match = create(:person, date_of_birth: 20.years.ago)
      close_match = create(:person, date_of_birth: 25.years.ago)
      other = create(:person, date_of_birth: 50.years.ago)

      sign_in_officer
      visit people_path
      open_physicals_search
      fill_in "Age", with: 20
      run_search

      expect(page).to have_content(l(match.date_of_birth))
      expect(page).to have_content(l(close_match.date_of_birth))
      expect(page).not_to have_content(l(other.date_of_birth))
    end

    scenario "Officer searches by gender" do
      male = create(:person, sex: "Male")
      female = create(:person, sex: "Female")

      sign_in_officer
      visit people_path
      open_physicals_search
      check_option(:sex, female.sex)
      run_search

      expect(page).to have_content(female.shorthand_description)
      expect(page).not_to have_content(male.shorthand_description)
    end

    scenario "Officer searches by race" do
      white = create(:person, race: "WHITE")
      asian = create(:person, race: "ASIAN (ALL)/PACIFIC ISLANDER")
      other = create(:person, race: "AFRICAN AMERICAN/BLACK")

      sign_in_officer
      visit people_path
      open_physicals_search
      check_option(:race, white.race)
      check_option(:race, asian.race)
      run_search

      expect(page).to have_content(white.shorthand_description)
      expect(page).to have_content(asian.shorthand_description)
      expect(page).not_to have_content(other.shorthand_description)
    end

    scenario "Officer searches by weight" do
      match = create(:person, weight_in_pounds: 150)
      close_match = create(:person, weight_in_pounds: 175)
      other = create(:person, weight_in_pounds: 300)

      sign_in_officer
      visit people_path
      open_physicals_search
      fill_in "Weight", with: 150
      run_search

      expect(page).to have_content(match.weight_in_pounds)
      expect(page).to have_content(close_match.weight_in_pounds)
      expect(page).not_to have_content(other.weight_in_pounds)
    end

    scenario "Officer searches by height" do
      create(:person, height_in_inches: 60)
      create(:person, height_in_inches: 63)
      create(:person, height_in_inches: 72)

      sign_in_officer
      visit people_path
      open_physicals_search
      fill_in :search_height_feet, with: 5
      fill_in :search_height_inches, with: 3
      run_search

      expect(page).to have_content("5'0\"")
      expect(page).to have_content("5'3\"")
      expect(page).not_to have_content("6'0\"")
    end

    scenario "Officer searches by hair color" do
      brown = create(:person, hair_color: "Brown")
      black = create(:person, hair_color: "Black")
      other = create(:person, hair_color: "Blonde")

      sign_in_officer
      visit people_path
      open_physicals_search
      check_option(:hair_color, "Brown")
      check_option(:hair_color, "Black")
      run_search

      expect(page).to have_content(brown.hair_color)
      expect(page).to have_content(black.hair_color)
      expect(page).not_to have_content(other.hair_color)
    end

    scenario "Officer searches by eye color" do
      blue = create(:person, eye_color: :blue, weight_in_pounds: 120)
      brown = create(:person, eye_color: :brown, weight_in_pounds: 130)
      other = create(:person, eye_color: :green, weight_in_pounds: 140)

      sign_in_officer
      visit people_path
      open_physicals_search
      check_option(:eye_color, "blue")
      check_option(:eye_color, "brown")
      run_search

      within(".search-results") do
        expect(page).to have_content(blue.shorthand_description)
        expect(page).to have_content(brown.shorthand_description)
        expect(page).not_to have_content(other.shorthand_description)
      end
    end

    def check_option(attr, option)
      page.execute_script("$('.search_#{attr} [value=\"#{option}\"]').click()")
    end

    def run_search
      first(".actions input").trigger("click")
    end

    def open_physicals_search
      find("a", text: t("search.physicals.show")).trigger("click")
    end
  end
end
