require "rails_helper"

feature "Officer sign-in" do
  scenario "unauthenticated officer is redirected to sign in" do
    plan = create(:response_plan)

    visit response_plan_path(plan)

    expect(page).to have_content t("devise.failure.unauthenticated")
    expect(current_path).to eq(new_officer_session_path)
  end

  scenario "authenticated user signs out" do
    plan = create(:response_plan)
    set_signed_in_officer(plan.author)

    visit response_plan_path(plan)
    click_on "Sign Out"

    expect(page).to have_content t("devise.sessions.signed_out")
    expect(current_path).to eq(new_officer_session_path)
  end

  def set_signed_in_officer(officer)
    officer_session = [[officer.id], officer.encrypted_password[0..28]]

    { "warden.user.officer.key" => officer_session }
  end
end
