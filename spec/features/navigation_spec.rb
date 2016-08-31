require "rails_helper"
require "support/permissions"

RSpec.describe "Navigation" do
  include Permissions

  context "as an admin" do
    before(:each) do
      officer = create(:officer)
      stub_admin_permissions(officer)
      sign_in_officer(officer)
    end

    scenario "officers can access drafts from home page", :js do
      visit root_path
      open_menu
      click_on t("response_plans.draft.index.link") # "Your Drafts"

      expect(page).to have_header t("response_plans.draft.index.header")
    end

    scenario "officers can access submissions from home page", :js do
      visit root_path
      open_menu
      click_on t("response_plans.submission.index.link") # "Pending approval"

      expect(page).to have_header t("response_plans.submission.index.header")
    end
  end

  context "as a non-admin" do
    scenario "officers cannot access drafts from home page", :js do
      visit root_path
      open_menu

      expect(page).not_to have_link t("response_plans.draft.index.link")
    end

    scenario "officers cannot access submissions from home page", :js do
      visit root_path
      open_menu

      expect(page).not_to have_link t("response_plans.submission.index.link")
    end
  end

  def open_menu
    find(".menu-icon").trigger("click")
  end

  def have_header(text)
    have_css("h1", text: text)
  end
end
