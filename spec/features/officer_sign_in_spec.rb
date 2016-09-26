require "rails_helper"

feature "Officer sign-in" do
  scenario "officer is redirected to sign in then back to the requested page" do
    officer_name = "Foo Bar"
    FakeAuthentication.new(name: officer_name).stub_success
    person = create(:person)

    visit person_path(person)

    expect(page).to have_content t("authentication.unauthenticated")
    expect(page).not_to have_content(t("authentication.sign_out.link"))
    expect(current_path).to eq(new_authentication_path)

    fill_in :authentication_username, with: "Foobar"
    fill_in :authentication_password, with: "Password"
    click_on t("authentication.sign_in.link")

    expect(page).
      to have_content(t("authentication.sign_in.success", name: officer_name))
    expect(current_path).to eq(person_path(person))
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
    expect(current_path).to eq(people_path)
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
    sign_in_officer

    visit people_path
    click_on t("authentication.sign_out.link")

    expect(page).to have_content t("authentication.sign_out.success")
    expect(current_path).to eq(new_authentication_path)
    expect(page.get_rack_session["officer_id"]).to be_nil
  end
end
