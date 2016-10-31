# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Officer profiles" do
  scenario "officer updates name" do
    officer = create(:officer)

    sign_in_officer(officer)
    visit edit_account_path
    fill_in :officer_name, with: "Jacques Closeau"
    fill_in :officer_unit, with: "CRU"
    fill_in :officer_title, with: "Sergeant"
    fill_in :officer_phone, with: "2223334444"
    click_on "Update Account"

    expect(page).to have_content t("accounts.update.success")
    officer.reload
    expect(officer.name).to eq("Jacques Closeau")
    expect(officer.unit).to eq("CRU")
    expect(officer.title).to eq("Sergeant")
    expect(officer.phone).to eq("2223334444")
  end

  scenario "admin updates a person's role", :js do
    officer = create(:officer, username: "jenkins")
    admin = create(:officer, :owner)

    sign_in_officer(admin)
    visit officers_path
    fill_in "Filter by name", with: "jenkins"
    page.execute_script("$('.new_officer_search').submit()")
    find("a[href='#{edit_officer_path(officer)}']", text: "Edit").
      trigger("click")
    select t("officers.roles.admin"), from: "Role"
    click_on "Update Officer"

    expect(page).
      to have_content t("officers.update.success", name: officer.name)
    expect(officer.reload).to be_admin
  end
end
