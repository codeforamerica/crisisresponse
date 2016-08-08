require "rails_helper"

feature "Night mode" do
  scenario "Officer views the app in day mode", :js do
    visit new_authentication_path

    header_color = get_header_background_color

    expect(header_color).to eq("rgb(74, 74, 74)")
  end

  scenario "Officer switches to night mode", :js do
    pending "
    This must be tested in Javascript,
    because it appears that Poltergeist does not support
    swapping out CSS link tag `href` attributes."

    visit new_authentication_path

    find(".menu-icon").click
    find(".change-theme").trigger('click')

    header_color = get_header_background_color
    expect(header_color).to eq("rgb(33, 33, 33)")
  end

  scenario "Officer stays on the page they were viewing" do
    sign_in_officer
    person = create(:person)
    path = person_path(person)

    visit path
    find(".menu-icon").click
    find(".change-theme").click

    expect(current_path).to eq(path)
  end

  def get_header_background_color
    page.evaluate_script("$('.header').css('background-color')")
  end
end
