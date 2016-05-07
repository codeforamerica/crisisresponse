require "rails_helper"

feature "Night mode", :js do
  scenario "Officer views the app in day mode" do
    visit response_plans_path

    header_color = get_header_background_color

    expect(header_color).to eq("rgb(74, 74, 74)")
  end

  scenario "Officer switches to night mode" do
    visit response_plans_path
    click_on "Night/Day"

    header_color = get_header_background_color

    expect(header_color).to eq("rgb(33, 33, 33)")
  end

  scenario "Officer stays on the page they were viewing" do
    plan = create(:response_plan)
    path = response_plan_path(plan)

    visit path
    click_on "Night/Day"

    expect(current_path).to eq(path)
  end

  def get_header_background_color
    page.evaluate_script("$('.header').css('background-color')")
  end
end
