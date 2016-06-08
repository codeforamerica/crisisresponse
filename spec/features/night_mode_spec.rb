require "rails_helper"

feature "Night mode" do
  scenario "Officer views the app in day mode", :js do
    visit new_authentication_path

    header_color = get_header_background_color

    expect(header_color).to eq("rgb(74, 74, 74)")
  end

  scenario "Officer switches to night mode", :js do
    visit new_authentication_path
    click_on "Light/Dark"

    header_color = get_header_background_color

    expect(header_color).to eq("rgb(33, 33, 33)")
  end

  scenario "Officer stays on the page they were viewing" do
    sign_in_officer
    plan = create(:response_plan)
    path = response_plan_path(plan)

    visit path
    click_on "Light/Dark"

    expect(current_path).to eq(path)
  end

  def get_header_background_color
    page.evaluate_script("$('.header').css('background-color')")
  end
end
