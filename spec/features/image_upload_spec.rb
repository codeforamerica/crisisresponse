require "rails_helper"

feature "image upload" do
  scenario "officer uploads an image through admin dashboard" do
    person = create(:person)

    visit edit_admin_person_path(person)
    attach_file("Image", Rails.root + "spec/fixtures/image.png")
    click_on "Update Person"

    person.reload
    expect(person.image_url).not_to be_nil
    visit person_path(person)
    expect(page).to have_image(person.image_url)
  end

  def have_image(image_url)
    have_css("img[src='#{image_url}']")
  end
end
