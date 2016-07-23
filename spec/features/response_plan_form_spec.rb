require "rails_helper"

feature "Response Plan Form" do
  include Permissions

  context "Creating a new response plan" do
    scenario "Officer fills in minimum information" do
      admin_officer = create(:officer, username: "admin")
      sign_in_officer(admin_officer)
      stub_admin_permissions(admin_officer)

      visit new_response_plan_path
      fill_in "First name", with: "John"
      fill_in "Last name", with: "Doe"
      fill_in "DOB", with: "1980-01-02"
      select "WHITE", from: "Race"
      select "Male", from: "Sex"
      click_on "Create Response plan"

      expect(page).to have_content(t("response_plans.create.success", name: "John Doe"))
      expect(page).to have_content(t("response_plans.approval.required"))
      expect(page).to have_content("John")
      expect(page).to have_content("Doe")
      expect(page).to have_content(l(Date.new(1980, 1, 2)))
    end

    scenario "Officer fills in all information" do
      admin_officer = create(:officer, username: "admin")
      sign_in_officer(admin_officer)
      stub_admin_permissions(admin_officer)

      visit new_response_plan_path
      fill_in "First name", with: "John"
      fill_in "Last name", with: "Doe"
      fill_in "DOB", with: "1980-01-02"
      fill_in "Weight", with: 160
      fill_in "Height", with: 72
      fill_in "Eye color", with: "Blue"
      fill_in "Hair color", with: "Brown"
      fill_in "Scars and marks", with: "Spider tattoo on neck"
      select "WHITE", from: "Race"
      select "Male", from: "Sex"
      fill_in "Background info", with: "Lorem Ipsum Dolor Si Amet"
      fill_in "Location name", with: "The Morrison Hotel"
      fill_in "Location address", with: "509 3rd Ave"
      fill_in "Private notes", with: "These notes should be private"
      click_on "Create Response plan"

      expect(page).
        to have_content(t("response_plans.create.success", name: "John Doe"))
      expect(page).to have_content(t("response_plans.approval.required"))
      expect(page).to have_content("John")
      expect(page).to have_content("Doe")
      expect(page).to have_content(l(Date.new(1980, 1, 2)))
      expect(page).to have_content("160 lb")
      expect(page).to have_content("6'0\"")
      expect(page).to have_content("Blue")
      expect(page).to have_content("Brown")
      expect(page).to have_content("Spider tattoo on neck")
      expect(page).to have_content("Lorem Ipsum Dolor Si Amet")
      expect(page).not_to have_content("These notes should be private")
    end

    scenario "Officer fills out form with errors" do
      admin_officer = create(:officer, username: "admin")
      sign_in_officer(admin_officer)
      stub_admin_permissions(admin_officer)

      visit new_response_plan_path
      click_on "Create Response plan"

      expect(page).to have_content "is not included in the list"
    end

    scenario "Non-admin officer is not allowed access" do
      sign_in_officer

      visit new_response_plan_path

      expect(page).
        to have_content(t("authentication.unauthorized.new_response_plan"))
    end
  end

  context "Editing an existing response plan" do
    scenario "updated plan needs re-approval" do
      person = create(:person, first_name: "Jane", last_name: "Doe")
      plan = create(:response_plan, person: person, approved_at: 1.day.ago)
      officer = create(:officer, username: "foo")
      stub_admin_permissions(officer)
      sign_in_officer(officer)

      visit edit_response_plan_path(plan)
      fill_in "First name", with: "Mary"
      click_on "Create Response plan"

      expect(page).to have_content(t("response_plans.approval.required"))
      # expect(page).
      #   to have_content(t("response_plans.update.success", name: "Mary Doe"))
    end
  end

  feature "nested forms", :js do
    scenario "adding a nested response strategy" do
      admin_officer = create(:officer, username: "admin")
      sign_in_officer(admin_officer)
      stub_admin_permissions(admin_officer)
      plan = create(:response_plan)
      person = plan.person

      visit edit_response_plan_path(plan)
      click_on "add response strategy"
      first("input[name*='[title]']").set("Response strategy 1")
      first("textarea[name*='[description]']").set("Response strategy description 1")
      click_on "Create Response plan"

      person.reload
      new_plan = person.response_plans.last
      expect(page).to have_content("Response strategy 1")
      expect(new_plan.response_strategies.first.description).
        to eq("Response strategy description 1")
    end

    scenario "removing a nested alias" do
      admin_officer = create(:officer, username: "admin")
      sign_in_officer(admin_officer)
      stub_admin_permissions(admin_officer)
      plan = create(:response_plan, alias_list: ["Foo"])

      visit edit_response_plan_path(plan)
      click_on "remove alias"
      expect(first(".alias-field input")).to be_nil
      click_on "Create Response plan"

      expect(page).not_to have_content("Foo")
    end

    scenario "removing a nested response strategy" do
      admin_officer = create(:officer, username: "admin")
      sign_in_officer(admin_officer)
      stub_admin_permissions(admin_officer)
      title = "Call case manager"
      plan = create(:response_plan)
      create(:response_strategy, response_plan: plan, title: title)

      visit edit_response_plan_path(plan)
      click_on "remove step"
      click_on "Create Response plan"

      expect(page).not_to have_content(title)
    end

    scenario "updating a nested response strategy" do
      admin_officer = create(:officer, username: "admin")
      sign_in_officer(admin_officer)
      stub_admin_permissions(admin_officer)
      original_title = "Call case manager"
      new_title = "Response strategy 1"
      plan = create(:response_plan)
      create(:response_strategy, response_plan: plan, title: original_title)

      visit edit_response_plan_path(plan)
      first("input[name*='[title]']").set(new_title)
      click_on "Create Response plan"

      expect(page).not_to have_content(original_title)
      expect(page).to have_content(new_title)
    end
  end
end
