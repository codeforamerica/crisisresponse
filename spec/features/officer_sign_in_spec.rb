require "rails_helper"

feature "Officer sign-in" do
  scenario "unauthenticated officer is redirected to sign in" do
    plan = create(:response_plan)

    visit response_plan_path(plan)

    expect(page).to have_content t("authentication.unauthenticated")
    expect(page).not_to have_content(t("authentication.sign_out.link"))
    expect(current_path).to eq(new_authentication_path)
  end

  scenario "user signs in" do
    officer_name = "Foo Bar"
    FakeAuthentication.new(name: officer_name).stub_success

    visit new_authentication_path
    fill_in :authentication_username, with: "Foobar"
    fill_in :authentication_password, with: "Password"
    click_on t("authentication.sign_in.link")

    expect(page).
      to have_content(t("authentication.sign_in.success", name: officer_name))
    expect(current_path).to eq(response_plans_path)
  end

  scenario "user fails to sign in" do
    FakeAuthentication.new.stub_failure

    visit new_authentication_path
    fill_in :authentication_username, with: "Foobar"
    fill_in :authentication_password, with: "Password"
    click_on t("authentication.sign_in.link")

    expect(page).to have_content t("authentication.sign_in.failure")
    expect(current_path).to eq(new_authentication_path)
  end

  scenario "authenticated user signs out" do
    plan = create(:response_plan)
    sign_in_officer(plan.author)

    visit response_plan_path(plan)
    click_on t("authentication.sign_out.link")

    expect(page).to have_content t("authentication.sign_out.success")
    expect(current_path).to eq(new_authentication_path)
    expect(page.get_rack_session["officer_id"]).to be_nil
  end
end
