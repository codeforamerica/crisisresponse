require "rails_helper"

feature "image upload" do
  scenario "officer uploads an image through admin dashboard" do
    response_plan = create(:response_plan)

    visit edit_admin_response_plan_path(response_plan)
    attach_file("Image", Rails.root + "spec/fixtures/image.jpg")
    click_on "Update Response plan"

    response_plan.reload
    expect(response_plan.image_url).not_to be_nil
    visit response_plan_path(response_plan)
    expect(page).to have_image(response_plan.image_url)
  end

  def have_image(image_url)
    have_css("img[src='#{image_url}']")
  end
end
