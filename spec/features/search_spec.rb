require "rails_helper"

feature "Search" do
  scenario "Officer searches and finds a record" do
    sign_in_officer
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for(name: "John")
    expect(page).to have_content(response_plan.display_name)
    expect(page).to have_content(l(dob))
  end

  scenario "Officer searches and doesn't find a record" do
    sign_in_officer
    name = "John Doe"
    dob = Date.new(1980, 01, 02)
    response_plan = create(:response_plan, name: name, date_of_birth: dob)

    visit response_plans_path

    search_for(name: "Mary")
    expect(page).to have_content(t("search.results.none"))
    expect(page).not_to have_content(response_plan.display_name)
    expect(page).not_to have_content(l(dob))
  end

  def search_for(params)
    within(".search") do
      fill_form_and_submit(:response_plan_search, params)
    end
  end
end
