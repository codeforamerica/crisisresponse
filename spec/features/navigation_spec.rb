require "rails_helper"

RSpec.describe "Navigation" do
  context "as an admin" do
    scenario "officers can access drafts from home page", :js do
      officer = create(:officer, :admin)
      sign_in_officer(officer)

      visit root_path
      open_menu
      click_on t("drafts.index.link") # "Drafts"

      expect(page).to have_header t("drafts.index.title")
    end

    scenario "officers can access submissions from home page", :js do
      officer = create(:officer, :admin)
      sign_in_officer(officer)

      visit root_path
      open_menu
      click_on t("submissions.index.link") # "Pending approval"

      expect(page).to have_header t("submissions.index.title")
    end

    scenario "admin can view all officers", :js do
      officer = create(:officer, :admin)
      sign_in_officer(officer)

      visit root_path
      open_menu
      click_on t("menu.officers")

      expect(page).to have_content t("helpers.submit.officer_search.create")
    end
  end

  context "as a non-admin" do
    scenario "officers cannot access drafts from home page", :js do
      sign_in_officer
      visit root_path
      open_menu

      expect(page).not_to have_link t("drafts.index.link")
    end

    scenario "officers cannot access submissions from home page", :js do
      sign_in_officer
      visit root_path
      open_menu

      expect(page).not_to have_link t("submissions.index.link")
    end

    scenario "officers can access their account edit page", :js do
      sign_in_officer
      visit root_path
      open_menu
      click_on t("menu.edit_account")

      expect(page).to have_content t("accounts.edit.title")
    end
  end

  def open_menu
    find(".menu-icon").trigger("click")
  end

  def have_header(text)
    have_css("h1", text: text)
  end
end
