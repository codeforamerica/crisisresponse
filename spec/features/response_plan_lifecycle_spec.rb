# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Response Plan Lifecycle" do
  describe "creating a draft" do
    context "when the officer is not an admin" do
      scenario "they cannot create a draft" do
        sign_in_officer

        visit person_path(create(:person))

        expect(page).not_to have_link t("people.show.draft.new")
      end
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

      scenario "create a draft for a person who already has a plan" do
        officer = create(:officer, :admin)
        sign_in_officer(officer)
        person = create(:response_plan, :approved).person

        visit person_path(person)
        click_on t("people.show.draft.new")

        expect(page).to have_content \
          t("drafts.create.success.from_previous", name: person.name)
      end

      scenario "cannot create a draft for someone who already has a draft" do
        officer = create(:officer, :admin)
        sign_in_officer(officer)
        draft = create(:response_plan, :draft)
        person = draft.person

        visit person_path(person)
        expect(page).not_to have_link t("people.show.draft.new")
        expect(page).
          to have_content t("people.show.draft.exists", name: person.first_name)

        click_on t("people.show.draft.show")
        expect(current_path).to eq(draft_path(draft))
      end

      scenario "they cannot create a draft for someone who has a submitted plan" do
        officer = create(:officer, :admin)
        sign_in_officer(officer)
        submission = create(:response_plan, :submission)
        person = submission.person

        visit person_path(person)
        expect(page).not_to have_link t("people.show.draft.new")
        expect(page).to have_content \
          t("people.show.submission.exists", name: person.first_name)

        click_on t("people.show.submission.show")
        expect(current_path).to eq(submission_path(submission))
      end

      scenario "updating a draft" do
        person = create(:person, first_name: "Jane", last_name: "Doe")
        plan = create(:response_plan, :approved, person: person)
        officer = create(:officer, :admin)
        sign_in_officer(officer)

        visit person_path(person)
        click_on t("people.show.draft.new")
        fill_in "Background info", with: "Lorem Ipsum dolor si amet."
        click_on "Update Response plan"

        expect(page).to have_content t("drafts.show.title")
        # expect(page).
        #   to have_content(t("drafts.update.success", name: "Mary Doe"))
      end
    end
  end

  describe "managing drafts" do
    scenario "they can edit a draft they didn't create" do
      officer = create(:officer, :admin)
      sign_in_officer(officer)
      plan = create(:response_plan, :draft)

      visit drafts_path
      click_on "Profile"
      click_on t("drafts.show.edit")

      expect(current_path).to eq(edit_draft_path(plan))
    end

    scenario "they can submit a draft for approval" do
      officer = create(:officer, :admin)
      sign_in_officer(officer)
      plan = create(:response_plan, :draft)
      description = plan.person.shorthand_description

      visit drafts_path
      click_on "Profile"
      click_on t("drafts.show.submit")

      expect(page).to have_content t("submissions.create.success.text")
      expect(current_path).to eq(drafts_path)
      expect(page).not_to have_content(plan.person.shorthand_description)
    end

    scenario "they can delete a draft" do
      officer = create(:officer, :admin)
      sign_in_officer(officer)
      draft = create(:response_plan, :draft)

      visit draft_path(draft)
      click_on t("drafts.show.destroy")

      expect(page).to have_content t("drafts.destroy.success")
      expect { draft.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    scenario "draft a plan for a person who is not in the system", :js do
      officer = create(:officer, :admin)
      sign_in_officer(officer)

      visit people_path
      find(".menu-icon").trigger("click")
      click_on t("menu.new_person")

      fill_in "First name", with: "John"
      fill_in "Last name", with: "Doe"
      fill_in "DOB", with: "01-02-1980"
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

  describe "approval" do
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
        expect(person.reload).to be_visible
      end

      scenario "they can kick a submission back down to draft status" do
        officer = create(:officer, :admin)
        sign_in_officer(officer)
        plan = create(:response_plan, :submission, background_info: "unique")

        visit submission_path(plan)
        click_on t("submissions.show.destroy")

        expect(page).to have_content t("submissions.destroy.success", name: plan.person.name)
        expect(current_path).to eq draft_path(plan)
        expect(page).to have_link t("drafts.show.edit")
      end
    end
  end
end
