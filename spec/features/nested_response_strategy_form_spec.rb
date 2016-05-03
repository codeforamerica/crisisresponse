require "rails_helper"

feature "nested forms", :js do
  scenario "adding a nested response strategy" do
    response_plan = create(:response_plan)

    visit edit_admin_response_plan_path(response_plan)
    click_on "Add Response Strategy"
    first("input[name*='[title]']").set("Response strategy 1")
    first("textarea[name*='[description]']").set("Response strategy description 1")
    click_on "Update Response plan"

    expect(page).to have_content("Response strategy 1")
    expect(response_plan.reload.response_strategies.first.description).
      to eq("Response strategy description 1")
  end

  scenario "removing a nested response strategy" do
    title = "Call case manager"
    response_plan = create(:response_plan)
    create(:response_strategy, response_plan: response_plan, title: title)

    visit edit_admin_response_plan_path(response_plan)
    click_on "Remove Response Strategy"
    click_on "Update Response plan"

    expect(page).not_to have_content(title)
  end

  scenario "updating a nested response strategy" do
    title = "Call case manager"
    response_plan = create(:response_plan)
    create(:response_strategy, response_plan: response_plan, title: title)

    visit edit_admin_response_plan_path(response_plan)
    first("input[name*='[title]']").set("Response strategy 1")
    click_on "Update Response plan"

    expect(page).not_to have_content(title)
    expect(page).to have_content("Response strategy 1")
  end
end
