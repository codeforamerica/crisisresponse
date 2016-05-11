require "rails_helper"

feature "Search", :js do
  scenario "Officer searches by a person's name" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for(name: "John")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))

    search_for(name: "Doe")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))

    search_for(name: "John Doe")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))

    search_for(name: "Doe John")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  pending "Officer searches by part of a person's name" do
    name = "Christopher Nolan"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for(name: "Chris")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a person's DOB" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for("DOB" => "1/2/80")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))

    search_for("DOB" => "1-2-1980")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))

    search_for("DOB" => "1-2-80")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))

    search_for("DOB" => "1980-1-2")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a person's name and DOB" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for(name: "Doe John", "DOB" => "1/2/80")

    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a name with no match" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path
    search_for(name: "Mary")

    expect(page).to have_content(t("search.results.none"))
    expect(page).not_to have_content(response_plan.display_name.upcase)
    expect(page).not_to have_content(l(dob))
  end

  scenario "Officer searches by a DOB with no match" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for("DOB" => "2/3/86")
    expect(page).to have_content(t("search.results.none"))
    expect(page).not_to have_content(response_plan.display_name.upcase)
    expect(page).not_to have_content(l(dob))
  end

  scenario "Officer searches by a name that's slightly off" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for(name: "Jon")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))

    search_for(name: "Doh")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))

    search_for(name: "Jon Doh")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))

    search_for(name: "Doh Jon")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a DOB that's slightly off" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for("DOB" => "1/2/81")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))

    search_for("DOB" => "1/2/79")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))

    search_for("DOB" => "1/2/80")
    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a name and DOB that are slightly off" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for(name: "Jon Doh", "DOB" => "1/2/81")

    expect(page).to have_content(response_plan.display_name.upcase)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches by a name that matches, and DOB that doesn't" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for(name: "Jon Doh", "DOB" => "1/2/85")

    expect(page).to have_content(t("search.results.none"))
    expect(page).not_to have_content(response_plan.display_name.upcase)
    expect(page).not_to have_content(l(dob))
  end

  scenario "Officer searches by a DOB that matches, and name that doesn't" do
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for(name: "Mary", "DOB" => "1/2/80")

    expect(page).to have_content(t("search.results.none"))
    expect(page).not_to have_content(response_plan.display_name.upcase)
    expect(page).not_to have_content(l(dob))
  end

  def search_for(params)
    within(".search") do
      fill_form_and_submit(:response_plan_search, params)
    end
  end
end
