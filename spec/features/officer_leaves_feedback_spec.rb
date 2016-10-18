require "rails_helper"
require "email_service"

feature "Feedback" do
  scenario "Officer leaves feedback" do
    allow(EmailService).to receive(:send)
    sign_in_officer
    response_plan = create(:response_plan)

    visit person_path(response_plan.person)
    find(".footer").click
    fill_in :feedback_name, with: "Sandlin Grayson"
    fill_in :feedback_description, with: "foobar"
    click_on "Submit Feedback"

    expect(page).to have_content(t("feedbacks.create.success"))
    feedback = Feedback.last
    expect(feedback.name).to eq("Sandlin Grayson")
    expect(feedback.description).to eq("foobar")
    expect(EmailService).to have_received(:send)
  end
end
