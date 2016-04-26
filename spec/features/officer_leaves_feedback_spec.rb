require "rails_helper"

feature "Feedback" do
  scenario "Officer leaves feedback" do
    person = create(:person)

    visit person_path(person)
    click_on "Leave Feedback"
    fill_in :feedback_name, with: "Sandlin Grayson"
    fill_in :feedback_description, with: "foobar"
    click_on "Submit Feedback"

    expect(page).to have_content(t("feedbacks.create.success"))
    feedback = Feedback.last
    expect(feedback.name).to eq("Sandlin Grayson")
    expect(feedback.description).to eq("foobar")
  end
end
