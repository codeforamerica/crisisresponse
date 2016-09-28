# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Response Plan Lifecycle" do
  describe "creating a draft" do
    context "when the officer is not an admin" do
      scenario "they cannot create a draft"
    end

    context "when the officer is an admin" do
      scenario "they can draft a plan for a person who doesn't have one" do
        officer = create(:officer, :admin)
        sign_in_officer(officer)
        person = create(:person)

        visit person_path(person)
        click_on t("people.show.new_plan")

        expect(page).to have_content \
          t("drafts.create.success.from_scratch", name: person.name)
      end

      scenario "they can draft a new plan for a person who already has one" do
        officer = create(:officer, :admin)
        sign_in_officer(officer)
        person = create(:response_plan, :approved).person

        visit person_path(person)
        click_on t("people.show.new_draft")

        expect(page).to have_content \
          t("drafts.create.success.from_previous", name: person.name)
      end

      scenario "updating a draft" do
        person = create(:person, first_name: "Jane", last_name: "Doe")
        plan = create(:response_plan, :approved, person: person)
        officer = create(:officer, :admin)
        sign_in_officer(officer)

        visit person_path(person)
        click_on t("people.show.new_draft")
        fill_in "Background info", with: "Lorem Ipsum dolor si amet."
        click_on "Update Response plan"

        expect(page).to have_content t("drafts.show.title")
        # expect(page).
        #   to have_content(t("drafts.update.success", name: "Mary Doe"))
      end
    end
  end

  describe "managing drafts" do
    context "when the officer is not an admin" do
      scenario "they cannot view drafts"
    end

    context "when the officer is an admin" do
      scenario "they can edit a draft that they created" do
        officer = create(:officer, :admin)
        sign_in_officer(officer)
        plan = create(:response_plan, :draft, author: officer)

        visit drafts_path
        click_on "Profile"
        click_on t("drafts.show.edit")

        expect(current_path).to eq(edit_draft_path(plan))
      end

      # Not sure if we want to do this or not
      scenario "they can(not?) edit a draft that someone else has created"

      scenario "they can submit a draft for approval" do
        officer = create(:officer, :admin)
        sign_in_officer(officer)
        plan = create(:response_plan, :draft, author: officer)
        description = plan.person.shorthand_description

        visit drafts_path
        click_on "Profile"
        click_on t("drafts.show.submit")

        expect(page).to have_content t("submissions.create.success.text")
        expect(current_path).to eq(drafts_path)
        expect(page).not_to have_content(plan.person.shorthand_description)
      end

      scenario "they can delete a draft that they've created"

      scenario "they can not delete a draft that another officer created"

      scenario "draft a plan for a person who is not in the system", :js do
        officer = create(:officer, :admin)
        sign_in_officer(officer)

        visit people_path
        find(".menu-icon").trigger("click")
        click_on t("menu.new_person")

        fill_in "First name", with: "John"
        fill_in "Last name", with: "Doe"
        fill_in "DOB", with: "01-02-1980"
        select "White", from: "Race"
        select "Male", from: "Sex"
        click_on "Create Person"

        person = Person.last
        expect(page).
          to have_content t("people.create.success", name: "Doe, John")
        expect(person.first_name).to eq("John")
        expect(person.last_name).to eq("Doe")
        expect(person.date_of_birth).to eq(Date.new(1980, 1, 2))
        expect(page).to have_link t("people.show.new_plan")
      end
    end
  end

  describe "approval" do
    context "when the officer is not an admin" do
      scenario "they cannot approve drafts"
    end

    context "when the officer is an admin" do
      scenario "they cannot delete a plan"
      scenario "they cannot approve a plan"
    end

    context "when the officer is a super admin" do
      scenario "they can approve submitted response plans" do
        officer = create(:officer, :admin)
        sign_in_officer(officer)
        plan = create(:response_plan, :submission, background_info: "unique")
        person = plan.person

        visit submissions_path
        click_on "Profile"
        click_on t("submissions.show.approve")

        expect(current_path).to eq(person_path(person))
        expect(page).
          to have_content t("submissions.approve.success", name: person.name)
        expect(page).to have_content plan.background_info
      end

      scenario "they cannot approve response plans that are still being drafted"
    end
  end
end
